import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/views/catalog_book_view.dart';
import 'package:audiobooks_app/views/catalog_card_book_view.dart';
import 'package:flutter/material.dart';

class CatalogView extends StatelessWidget {
  final List<Book> books;

  CatalogView({this.books});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: books
            .map(
              (book) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(6.0),
                    // color: Theme.of(context).backgroundColor,
                  ),
                  child: ElevatedButton(
                    child: Hero(
                      tag: book.id,
                      child: CatalogCardBookView(
                        book: book,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CatalogBookView(book: book);
                      }));
                    },
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
