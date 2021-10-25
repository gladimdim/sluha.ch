import 'package:async/async.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/catalog.dart';
import 'package:audiobooks_app/utils.dart';
import 'package:audiobooks_app/views/catalog_view.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  AsyncMemoizer<List<Book>> _fetchCatalog = AsyncMemoizer();
  bool usesLocalCatalog = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Слухач"),
          actions: [
            IconButton(
              onPressed: _updateCatalog,
              tooltip: "Оновити каталог",
              icon: Icon(
                Icons.refresh,
                size: ICON_SIZE,
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<Book>>(
            future: _fetchData(false),
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

  void _updateCatalog() async {
    setState(() {
      _fetchCatalog = AsyncMemoizer();

    });
    await _fetchData(true);
  }

  Future<List<Book>> _fetchData(bool refreshFromServer) {
    return _fetchCatalog.runOnce(() async {
      if (refreshFromServer) {
        return await fetchRemoteData();
      }
      // check for local books first and use its catalog
      final localCatalog = await Catalog.instance.readLocalCatalog();
      if (localCatalog.isEmpty) {
        return await fetchRemoteData();
      }
      usesLocalCatalog = true;
      return localCatalog;
    });
  }

  Future<List<Book>> fetchRemoteData() async {
    setState(() {
      usesLocalCatalog = false;
    });
    List<Book> books = await Catalog.instance.fetchRemoteCatalogAndSave();
    if (books.isNotEmpty) {
      setState(() {
        usesLocalCatalog = true;
      });
    }
    return books;
  }

  List<Book> generateBooksFromJson(List<Map<String, Object>> json) {
    return json.map((jsonItem) {
      return Book.fromJson(jsonItem);
    }).toList();
  }
}
