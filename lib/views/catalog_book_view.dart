import 'package:audiobooks_app/main.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/views/catalog_card_book_view.dart';
import 'package:flutter/material.dart';

class CatalogBookView extends StatefulWidget {
  final Book book;

  CatalogBookView({this.book});

  @override
  _CatalogBookViewState createState() => _CatalogBookViewState();
}

class _CatalogBookViewState extends State<CatalogBookView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: Column(
        children: [
          Hero(
              tag: widget.book.id,
              child: CatalogCardBookView(
                book: widget.book,
              )),
          Column(
            children: [
              Text("Playlist"),
              ...widget.book.files.map((file) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: DEEP_COLOR),
                    )
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          file.title,
                        ),
                        IconButton(icon: Icon(Icons.play_arrow), onPressed: null)
                      ]),
                );
              }).toList()
            ],
          )
        ],
      ),
    );
  }
}
