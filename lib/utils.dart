import 'package:path_provider/path_provider.dart';

Future<String> getDocumentRootPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return dir.path;
}
