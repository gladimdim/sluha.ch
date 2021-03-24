import 'package:audiobooks_app/models/server.dart';

class BookFile {
  final String title;
  final String url;
  bool queued;

  BookFile({this.title, this.url, this.queued = true});

  String remoteFullFilePath() {
    return "$URL_PREFIX$url";
  }
}
