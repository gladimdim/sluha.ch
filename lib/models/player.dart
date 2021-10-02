import 'dart:io';

import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/book_file.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:just_audio/just_audio.dart';

class Player {
  final player = AudioPlayer();
  Book? book;
  int? currentFileIndex;
  BehaviorSubject<bool> _playbackChanges = BehaviorSubject<bool>();
  BehaviorSubject<Tuple2<Duration, Duration>> _progressChanges =
      BehaviorSubject<Tuple2<Duration, Duration>>();
  late ValueStream<bool> playbackChanges;
  late ValueStream<Tuple2<Duration, Duration>> progressChanges;

  Player._internal() {
    playbackChanges = _playbackChanges.stream;
    progressChanges = _progressChanges.stream;

    setupAudio();
  }

  setupAudio() {
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
    return lBook.files[currentFileIndex!];
  }

  void play(Book book, BookFile file) async {
    this.book = book;
    this.currentFileIndex = this.book!.files.indexOf(file);
    final url = await file.getUrl();
    await player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    await player.play();
    // if (file.canPlayOffline) {
    //   player.setFilePath(url);
    // } else {
    //   player.setUrl(url);
    // }
  }

  bool isCurrentlyPlayingThisFile(BookFile file) {
    return file == currentFile && player.playing;
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
    if (newOffset > progresses.item1) {
      playNext();
      return;
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
      var next = findNextToPlay(currentFileIndex! + offset, offset);
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
