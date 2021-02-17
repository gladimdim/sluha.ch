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
    audioPlayer.onPlayerStateChanged.listen((event) {
      switch (event) {
        case AudioPlayerState.COMPLETED:
          playNext();
          break;
        default:
          break;
      }
    });

    progressChanges = _progressChanges.stream;
  }

  static final Player instance = Player._internal();

  String get getBookTitle {
    if (book != null) {
      return book.title;
    } else {
      return "";
    }
  }

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

  void skip30() {
    jumpToOffset(Duration(seconds: 30));
  }

  void rewind30() {
    jumpToOffset(Duration(seconds: -30));
  }

  void jumpToOffset(Duration offset) async {
    Duration current = await _progressChanges.first;
    var newPosition = current + offset;
    audioPlayer.seek(newPosition.inSeconds.toDouble());
  }

  void playPrevious() {
    jumpToTrack(-1);
  }

  void playNext() {
    jumpToTrack(1);
  }

  void jumpToTrack(int offset) async {
    if (book != null) {
      var next = book.files[currentFileIndex + offset];
      if (next != null) {
        play(book, next);
      }
    }
  }

  void dispose() {
    _playbackChanges.close();
    _progressChanges.close();
  }
}
