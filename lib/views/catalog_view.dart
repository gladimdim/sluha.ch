import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/views/catalog_book_view.dart';
import 'package:audiobooks_app/views/catalog_card_book_view.dart';
import 'package:flutter/material.dart';

class CatalogView extends StatelessWidget {
  final List<Book> books;

  CatalogView({this.books});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: books.map(
            (book) =>
            InkWell(
              child: Hero(
                tag: book.id,
                child: CatalogCardBookView(
                  book: book,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)
                {
                  return CatalogBookView(book: book);
                }));
              },
            ),
      ).toList(),
    );
  }
}
