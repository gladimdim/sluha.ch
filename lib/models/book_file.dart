import 'dart:io';

import 'package:audiobooks_app/models/server.dart';
import 'package:audiobooks_app/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class BookFile {
  final String title;
  final String url;
  bool queued;
  bool canPlayOffline;

  BehaviorSubject _offlineChanges = BehaviorSubject<OFFLINE_STATUS>();
  ValueStream<OFFLINE_STATUS> changes;

  BookFile({this.title, this.url, this.queued = true}) {
    changes = _offlineChanges.stream;
    changes.listen((newState) {
      canPlayOffline = newState == OFFLINE_STATUS.LOADED;
    });
    checkOfflineStatus();
  }

  String remoteFullFilePath() {
    return "$URL_PREFIX$url";
  }

  dispose() {
    _offlineChanges.close();
  }

  Future checkOfflineStatus() async {
    var rootPath = await getDocumentRootPath();
    var fullFilePath = "$rootPath${getRelativeFolderPath()}/${getFileName()}";
    File file = File(fullFilePath);
    var exists = await file.exists();
    _offlineChanges.add(exists ? OFFLINE_STATUS.LOADED : OFFLINE_STATUS.NOT_LOADED);
  }

  String getFileName() {
    return url.split("/").last;
  }

  String getRelativeFolderPath() {
    var filePaths = url.split("/");
    filePaths.removeLast();
    return "${filePaths.join("/")}";
  }

  Future<String> getFullFilePath() async {
    String docDir = await getDocumentRootPath();
    return "$docDir$getRelativeFolderPath()/$getFileName()";
  }

  Future<Directory> createFolderPath() async {
    Directory directory = Directory.fromUri(Uri(path: getRelativeFolderPath()));
    var fileDir = await directory.create(recursive: true);
    return fileDir;
  }

  Future saveForOffline() async {
    _offlineChanges.add(OFFLINE_STATUS.LOADING);
    var fileName = this.getFileName();
    var fullUrl = "$URL_PREFIX$url";
    http.Client client = http.Client();
    final req = await client.get(Uri.parse(fullUrl));
    final bytes = req.bodyBytes;
    String docDir = await getDocumentRootPath();
    Directory directory =
        Directory.fromUri(Uri(path: "$docDir${getRelativeFolderPath()}"));
    var fileDir = await directory.create(recursive: true);
    // await for (var file in fileDir.list(recursive: false, followLinks: false)) {
    //   print("content: ${file.path}");
    // }

    print("File for saving: ${fileDir.path}/$fileName");
    File file = File("${fileDir.path}/$fileName");
    await file.writeAsBytes(bytes);
    _offlineChanges.add(OFFLINE_STATUS.LOADED);
    return file;
  }

  Future<bool> isOfflineReady() async {
    var fullPath = await getFullFilePath();
    File file = File(fullPath);
    var exists = await file.exists();
    return exists;
  }
}

enum OFFLINE_STATUS { LOADED, NOT_LOADED, LOADING }
