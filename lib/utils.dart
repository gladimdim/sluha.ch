import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getDocumentRootPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return dir.path;
}

const double ICON_SIZE = 24;

bool isPortrait(Size size) {
  return size.width < size.height;
}