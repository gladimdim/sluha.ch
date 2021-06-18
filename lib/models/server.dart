import 'dart:convert';

import 'package:audiobooks_app/models/book.dart';
import 'package:http/http.dart' as http;

const URL_PREFIX = "sluha.ch";

Future<List<Book>> fetchBooks() async {
  try {
    var data = await http.get(Uri.https(URL_PREFIX, "/catalog.json"));
    List json = jsonDecode(data.body);
    List<Book> results = json.map((jsonItem) {
      return Book.fromJson(jsonItem);
    }).toList();
    return results;
  } catch (exception) {
    print("Failed to fetch catalog: $exception");
  }
  return [];
}
