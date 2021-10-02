import 'dart:convert';
import 'dart:io';

import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/server.dart';
import 'package:audiobooks_app/utils.dart';

class Catalog {
  static final catalogFilename = "catalog.json";
  static final Catalog _instance = Catalog._internal();

  Catalog._internal();

  static Catalog get instance => _instance;

  Future<List<Book>> readLocalCatalog() async {
    final rootPath = await getDocumentRootPath();
    final fullPath = "$rootPath/$catalogFilename";
    final file = File(fullPath);
    final exists = await file.exists();
    if (exists) {
      final content = await file.readAsString();
      List json = jsonDecode(content) as List;
      List<Book> results = json.map<Book>((jsonItem) {
        return Book.fromJson(jsonItem);
      }).toList();
      return results;
    }
    return [];
  }

  Future<List<Book>> fetchRemoteCatalogAndSave() async {
    final catalogString = await fetchBooks();
    if (catalogString == null) {
      return [];
    }
    List json = jsonDecode(catalogString);
    List<Book> results = [];
    try {
      results = json.map<Book>((jsonItem) {
        return Book.fromJson(jsonItem);
      }).toList();
      return results;
    } catch (e) {
      print("Failed while fetching and parsing catalog remote: $e");
    }

    if (results.isNotEmpty) {
      Catalog.instance.saveToLocalfile(catalogString);
    }

    return results;
  }

  Future saveToLocalfile(String content) async {
    final rootPath = await getDocumentRootPath();
    final fullPath = "$rootPath/$catalogFilename";
    final file = File(fullPath);
    await file.writeAsString(content);
  }
}
