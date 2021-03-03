import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/book_file.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter_playout/audio.dart';
import 'package:flutter_playout/player_observer.dart';
import 'package:rxdart/rxdart.dart';

class Player with PlayerObserver {
  final String urlPrefix = "https://sluha.ch";
  Audio audioPlayer = Audio.instance();
  PlayerState _playerState = PlayerState.STOPPED;
  Book book;
  int currentFileIndex;
  BehaviorSubject _playbackChanges = BehaviorSubject<AudioPlayerState>();
  BehaviorSubject _progressChanges = BehaviorSubject<Duration>();
  ValueStream<AudioPlayerState> playbackChanges;
  ValueStream<Duration> progressChanges;
  Duration totalDuration = Duration.zero;

  Player._internal() {
    playbackChanges = _playbackChanges.stream;
    listenForAudioPlayerEvents();
    progressChanges = _progressChanges.stream;
  }

  onTime(int seconds) {
    _progressChanges.add(Duration(seconds: seconds));
  }

  onDuration(int total) {
    var seconds = (total / 1000).toInt();
    totalDuration = Duration(seconds: seconds);
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
    await audioPlayer.play("$urlPrefix/${file.url}", title: "Title1");
    _playerState = PlayerState.PLAYING;
  }

  bool isCurrentlyPlayingThisFile(BookFile file) {
    return file == currentFile && _playerState == PlayerState.PLAYING;
  }

  void pause() async {
    if (currentFile != null) {
      await audioPlayer.pause();
      _playerState = PlayerState.PAUSED;
    }
  }

  void stop() async {
    if (currentFile != null) {
      await audioPlayer.reset();
      _playerState = PlayerState.STOPPED;
    }
  }

  void resume() async {
    if (currentFile != null) {
      await audioPlayer.play("$urlPrefix/${currentFile.url}");

      _playerState = PlayerState.PLAYING;
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
    audioPlayer.seekTo(newPosition.inSeconds.toDouble());
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

enum PlayerState {
  STOPPED, PLAYING, PAUSED
}
