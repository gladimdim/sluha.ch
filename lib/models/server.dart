import 'dart:convert';

import 'package:http/http.dart' as http;

const URL_PREFIX = "https://sluha.ch";

Future<Map> fetchBooks() async {
  try {
    var data = await http.get("$URL_PREFIX/public/catalog.json");
    if (data != null) {
      return jsonDecode(data.body);
    }
  } catch (exception) {
    print("Failed to fetch catalog: $exception");
  }
  return null;
}
