import 'package:path_provider/path_provider.dart';

Future<String> getDocumentRootPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return dir.path;
}

const double ICON_SIZE = 24;