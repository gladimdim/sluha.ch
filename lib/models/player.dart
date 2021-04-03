import 'package:audio_manager/audio_manager.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/book_file.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class Player {
  Book book;
  int currentFileIndex;
  BehaviorSubject _playbackChanges = BehaviorSubject<bool>();
  BehaviorSubject _progressChanges =
      BehaviorSubject<Tuple2<Duration, Duration>>();
  ValueStream<bool> playbackChanges;
  ValueStream<Tuple2<Duration, Duration>> progressChanges;

  Player._internal() {
    playbackChanges = _playbackChanges.stream;
    progressChanges = _progressChanges.stream;

    setupAudio();
  }

  setupAudio() {
    AudioManager.instance.onEvents((events, args) {
      print(events);
      switch (events) {
        case AudioManagerEvents.timeupdate:
          _progressChanges.add(Tuple2(
              AudioManager.instance.position, AudioManager.instance.duration));
          break;
        case AudioManagerEvents.ended:
          playNext();
          break;
        case AudioManagerEvents .playstatus:
          _playbackChanges.add(true);
          break;
        case AudioManagerEvents.stop:
        case AudioManagerEvents.error:
          _playbackChanges.add(false);
          break;
        case AudioManagerEvents.next:
          playNext();
          break;
        case AudioManagerEvents.previous:
          playPrevious();
          break;
        default:
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
    var audioFileInfo = await fileToAudioInfo(file);
    AudioManager.instance.audioList = [audioFileInfo];
    AudioManager.instance.play(index: 0, auto: true);
  }

  bool isCurrentlyPlayingThisFile(BookFile file) {
    return file == currentFile && AudioManager.instance.isPlaying;
  }

  void pause() async {
    if (currentFile != null) {
      playOrPause();
    }
  }

  void stop() async {
    if (currentFile != null) {
      await AudioManager.instance.stop();
    }
  }

  void resume() async {
    if (currentFile != null) {
      playOrPause();
    }
  }

  void playOrPause() async {
    var isPlaying = await AudioManager.instance.playOrPause();
    _playbackChanges.add(isPlaying);
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
    var newPosition = current + offset;
    AudioManager.instance.seekTo(newPosition);
  }

  void seekTo(Duration to) {
    AudioManager.instance.seekTo(to);
  }

  void playPrevious() {
    jumpToTrack(-1);
  }

  void playNext() {
    jumpToTrack(1);
  }

  void jumpToTrack(int offset) async {
    if (book != null) {
      var next = findNextToPlay(currentFileIndex + offset, offset);
      if (next != null) {
        play(book, next);
      }
    }
  }

  BookFile findNextToPlay(startIndex, offset) {
    print("processing: $startIndex, $offset");
    if (book.files.length <= startIndex || startIndex < 0) {
      return null;
    }
    var start = book.files[startIndex];
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

  Future<AudioInfo> fileToAudioInfo(BookFile file) async {
    var url = await file.getPlaybackUrl();
    return AudioInfo(
      file.canPlayOffline ? "file://$url" : url,
      title: file.title,
      desc: book.title,
      coverUrl: book.remoteImageUrl,
    );
  }
}
