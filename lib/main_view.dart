import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/server.dart';
import 'package:audiobooks_app/views/catalog_view.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class MainView extends StatelessWidget {
  final AsyncMemoizer _fetchCatalog = AsyncMemoizer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Слухач"),
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot
              .connectionState == ConnectionState.done && snapshot.hasData) {
            return CatalogView(
              books: generateBooksFromJson(snapshot.data),
            );
          } else {
            return CatalogView(
              books: generateLocalBooks(),
            );
          }
        }
      ),
    );
  }

  Future _fetchData() {
    return _fetchCatalog.runOnce(() async {
      return await fetchBooks();
    });
  }

  List<Book> generateBooksFromJson(Map<String, Object> json) {
    var bookJson = json as List;
    return bookJson.map((jsonItem) {
      return Book.fromJson(jsonItem);
    }).toList();
  }
}
