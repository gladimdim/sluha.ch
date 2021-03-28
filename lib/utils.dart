import 'package:path_provider/path_provider.dart';

Future<String> getDocumentRootPath() async {
  return (await getApplicationDocumentsDirectory()).path;
}
