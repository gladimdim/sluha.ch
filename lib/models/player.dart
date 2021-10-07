import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/book_file.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:just_audio/just_audio.dart';

class Player {
  final player = AudioPlayer();
  Book? book;
  BehaviorSubject<bool> _playbackChanges = BehaviorSubject<bool>();
  BehaviorSubject<Tuple2<Duration, Duration>> _progressChanges =
      BehaviorSubject<Tuple2<Duration, Duration>>();
  late ValueStream<bool> playbackChanges;
  late ValueStream<Tuple2<Duration, Duration>> progressChanges;
  bool shouldRestorePlaying = false;

  Player._internal() {
    playbackChanges = _playbackChanges.stream;
    progressChanges = _progressChanges.stream;

    setupAudio();
  }

  setupAudio() async {
    Rx.combineLatest2<Duration?, Duration, Tuple2<Duration, Duration>>(
        player.durationStream, player.positionStream, (duration, position) {
      return Tuple2(position, duration ?? Duration.zero);
    }).listen((duration) {
      _progressChanges.add(Tuple2(duration.item1, duration.item2));
    });

    player.playerStateStream.listen((event) {
      _playbackChanges.add(event.playing);
      if (event.processingState == ProcessingState.completed) {
        playNext();
      }
    });

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    session.interruptionEventStream.listen((event) {
      if (event.begin && player.playing) {
        shouldRestorePlaying = true;
        pause();
      } else if (shouldRestorePlaying) {
        playOrPause();
      }
    });
  }

  static final Player instance = Player._internal();

  String get getBookTitle {
    if (book != null) {
      return book!.title;
    } else {
      return "";
    }
  }

  BookFile? get currentFile {
    final lBook = book;
    if (lBook == null) {
      return null;
    }
    return lBook.files[player.currentIndex!];
  }

  void play(Book book, BookFile file) async {
    final session = await AudioSession.instance;
    if (!(await session.setActive(true))) {
      return;
    }
    this.book = book;
    var index = this.book!.files.indexOf(file);
    List<AudioSource> playlist = [];
    for (var file in book.files) {
      var url = await file.getUrl();
      var audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: file.title,
          title: file.title,
          album: book.title,
          artist: book.author,
          artUri: Uri.parse(book.remoteImageUrl),
        ),
      );
      playlist.add(audioSource);
    }

    await player.setAudioSource(ConcatenatingAudioSource(children: playlist),
        initialIndex: index);
    await player.play();
  }

  bool isCurrentlyPlayingThisFile(BookFile file) {
    var b = book;
    if (b == null) {
      return false;
    }
    var index = b.files.indexOf(file);
    return player.currentIndex == index && player.playing;
  }

  void pause() async {
    if (currentFile != null) {
      playOrPause();
    }
  }

  void stop() async {
    if (currentFile != null) {
      await player.stop();
    }
  }

  void resume() async {
    if (currentFile != null) {
      playOrPause();
    }
  }

  void playOrPause() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
    _playbackChanges.add(player.playing);
  }

  void skip30() {
    jumpToOffset(Duration(seconds: 30));
  }

  void rewind30() {
    jumpToOffset(Duration(seconds: -30));
  }

  void jumpToOffset(Duration offset) async {
    Tuple2<Duration, Duration> progresses = await _progressChanges.first;
    Duration current = progresses.item1;
    Duration newOffset = current + offset;
    if (newOffset > progresses.item2) {
      playNext();
      return;
    } else if (newOffset < Duration.zero) {
      await player.seek(Duration.zero);
    } else {
      await player.seek(newOffset);
    }
  }

  void seekTo(Duration to) {
    player.seek(to);
  }

  void playPrevious() {
    jumpToTrack(-1);
  }

  void playNext() {
    jumpToTrack(1);
  }

  void jumpToTrack(int offset) async {
    if (book != null) {
      var next = findNextToPlay(player.currentIndex! + offset, offset);
      if (next != null) {
        play(book!, next);
      }
    }
  }

  BookFile? findNextToPlay(startIndex, offset) {
    print("processing: $startIndex, $offset");
    if (book!.files.length <= startIndex || startIndex < 0) {
      return null;
    }
    var start = book!.files[startIndex];
    if (start.queued) {
      return start;
    } else {
      return findNextToPlay(startIndex + offset, offset);
    }
  }

  void dispose() {
    _playbackChanges.close();
    _progressChanges.close();
  }
}
