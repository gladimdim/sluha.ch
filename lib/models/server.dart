import 'dart:convert';

import 'package:audiobooks_app/models/book.dart';
import 'package:http/http.dart' as http;

const URL_PREFIX = "https://sluha.ch";

Future<List<Book>> fetchBooks() async {
  try {
    var data = await http.get("$URL_PREFIX/catalog.json");
    if (data != null) {
      List json = jsonDecode(data.body);
      List<Book> results = (json as List).map((jsonItem) {
        return Book.fromJson(jsonItem);
      }).toList();
      return results;
    }
  } catch (exception) {
    print("Failed to fetch catalog: $exception");
  }
  return null;
}
