import 'package:audiobooks_app/components/play_controls_view.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/views/catalog_book_view.dart';
import 'package:audiobooks_app/views/catalog_card_book_view.dart';
import 'package:flutter/material.dart';

class CatalogView extends StatelessWidget {
  final List<Book> books;

  CatalogView({this.books});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: SingleChildScrollView(
            child: Column(
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
                          child: CatalogCardBookView(
                            book: book,
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
          ),
        ),
        Expanded(
          flex: 2,
          child: Hero(tag: "PlayControls", child: PlayControlsView()),
        ),
      ],
    );
  }
}
