import 'package:audio_manager/audio_manager.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/book_file.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class Player {
  final String urlPrefix = "https://sluha.ch";
  Book book;
  int currentFileIndex;
  BehaviorSubject _playbackChanges = BehaviorSubject<bool>();
  BehaviorSubject _progressChanges = BehaviorSubject<Tuple2<Duration, Duration>>();
  ValueStream<bool> playbackChanges;
  ValueStream<Tuple2<Duration, Duration>> progressChanges;

  Player._internal() {
    playbackChanges = _playbackChanges.stream;
    progressChanges = _progressChanges.stream;

    setupAudio();
  }

  setupAudio() {
    // AudioManager.instance.play(auto: false);
    AudioManager.instance.onEvents((events, args) {
      switch (events) {
        case AudioManagerEvents.timeupdate:
          _progressChanges.add(Tuple2(
              AudioManager.instance.position, AudioManager.instance.duration));
          break;
        case AudioManagerEvents.ended:
          playNext();
          break;
        case AudioManagerEvents.playstatus:
          _playbackChanges.add(true);
          break;
        case AudioManagerEvents.stop:
        case AudioManagerEvents.error:
          _playbackChanges.add(false);
          break;
      }
    });
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
    AudioManager.instance.audioList = [fileToAudioInfo(file)];
    AudioManager.instance.play(index: 0, auto: true);
  }

  bool isCurrentlyPlayingThisFile(BookFile file) {
    return file == currentFile && AudioManager.instance.isPlaying;
  }

  void pause() async {
    if (currentFile != null) {
      await AudioManager.instance.playOrPause();
    }
  }

  void stop() async {
    if (currentFile != null) {
      await AudioManager.instance.stop();
    }
  }

  void resume() async {
    if (currentFile != null) {
      AudioManager.instance.playOrPause();
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
    AudioManager.instance.seekTo(newPosition);
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

  AudioInfo fileToAudioInfo(BookFile file) {
    return AudioInfo(
      "$urlPrefix/${file.url}",
      title: file.title,
      desc: file.title,
      coverUrl: "$urlPrefix/minecraft/night_of_the_bats/cover.png",
    );
  }
}
