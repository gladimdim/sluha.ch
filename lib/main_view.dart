import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/server.dart';
import 'package:audiobooks_app/views/catalog_view.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final AsyncMemoizer<List<Book>> _fetchCatalog = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<List<Book>>(
            future: _fetchData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final data = snapshot.data;
                  if (data == null || data.isEmpty) {
                    return CatalogView(
                      books: generateLocalBooks(),
                    );
                  } else {
                    final List<Book> books = snapshot.data!;
                    return CatalogView(
                      books: books,
                    );
                  }
                default:
                  return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Future<List<Book>> _fetchData() {
    return _fetchCatalog.runOnce(() async {
      var result = await fetchBooks();
      return result;
    });
  }

  List<Book> generateBooksFromJson(List<Map<String, Object>> json) {
    return json.map((jsonItem) {
      return Book.fromJson(jsonItem);
    }).toList();
  }
}
