import 'package:http/http.dart' as http;

const URL_PREFIX = "sluha.ch";

Future<String?> fetchBooks() async {
  try {
    var data = await http.get(Uri.https(URL_PREFIX, "/catalog.json"));

    return data.body;
  } catch (exception) {
    print("Failed to fetch catalog: $exception");
  }
  return null;
}
