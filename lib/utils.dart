import 'dart:io';

import 'package:audiobooks_app/models/server.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<File> saveTrackToFile(String url) async {
  var fileName = url.split("/").last;
  var filePaths = url.split("/");
  filePaths.removeLast();
  var fullUrl = "$URL_PREFIX$url";
  http.Client client = http.Client();
  final req = await client.get(Uri.parse(fullUrl));
  final bytes = req.bodyBytes;
  String docDir = (await getApplicationDocumentsDirectory()).path;
  Directory directory =
      Directory.fromUri(Uri(path: "$docDir${filePaths.join("/")}"));
  var fileDir = await directory.create(recursive: true);
  fileDir.listSync().map((e) => print("file: ${e.path}"));
  print("FIle: ${fileDir.path}/$fileName");
  File file = File("${fileDir.path}/$fileName");
  await file.writeAsBytes(bytes);
  return file;
}

Future ensureFilePath(List<String> parts, String rootPath) async {
  // var first = parts.first;
  // var newPath = "$rootPath/$first";
  // var exists = await Directory(newPath).exists();
  // if (exists) {
  //   parts.removeAt(0);
  //   return ensureFilePath(parts, newPath);
  // } else {
  //   await Directory.cre
  // }
}
