import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/book_file.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:rxdart/rxdart.dart';

class Player {
  final String urlPrefix = "https://sluha.ch";
  final AudioPlayer audioPlayer = AudioPlayer();
  Book book;
  int currentFileIndex;
  BehaviorSubject _playbackChanges = BehaviorSubject<AudioPlayerState>();
  BehaviorSubject _progressChanges = BehaviorSubject<Duration>();
  ValueStream<AudioPlayerState> playbackChanges;
  ValueStream<Duration> progressChanges;

  Player._internal() {
    playbackChanges = _playbackChanges.stream;
    audioPlayer.onPlayerStateChanged.listen(_playbackChanges.add);
    audioPlayer.onAudioPositionChanged.listen(_progressChanges.add);
    audioPlayer.onAudioPositionChanged.listen((event) {
      print(event);
    });
    audioPlayer.onPlayerStateChanged.listen((event) {
      print(event);
    });

    progressChanges = _progressChanges.stream;
  }

  static final Player instance = Player._internal();

  BookFile get currentFile {
    if (book == null) {
      return null;
    }
    return book.files[currentFileIndex];
  }

  void play(Book book, BookFile file) async {
    this.book = book;
    this.currentFileIndex = this.book.files.indexOf(file);
    await audioPlayer.stop();
    await audioPlayer.play("$urlPrefix/${file.url}");
  }

  bool isCurrentlyPlayingThisFile(BookFile file) {
    return file == currentFile && audioPlayer.state == AudioPlayerState.PLAYING;
  }

  void pause() async {
    if (currentFile != null) {
      await audioPlayer.pause();
    }
  }

  void stop() async {
    if (currentFile != null) {
      await audioPlayer.stop();
    }
  }

  void resume() async {
    if (currentFile != null) {
      await audioPlayer.play("$urlPrefix/${currentFile.url}");
    }
  }

  void playPrevious() {
    jumpToOffset(-1);
  }

  void playNext() {
    jumpToOffset(1);
  }

  void jumpToOffset(int offset) async {
    if (book != null) {
      var next = book.files[currentFileIndex + offset];
      if (next != null) {
        play(book, next);
      }
    }
  }

  void dispose() {
    _playbackChanges.close();
  }
}
