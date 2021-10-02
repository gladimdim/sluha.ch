import 'package:audiobooks_app/components/play_controls_view.dart';
import 'package:audiobooks_app/components/tags_view.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/views/catalog_book_view.dart';
import 'package:audiobooks_app/views/catalog_card_book_view.dart';
import 'package:flutter/material.dart';

class CatalogView extends StatefulWidget {
  final List<Book> books;
  final List<String> rootTags;

  CatalogView(
      {required this.books, this.rootTags = const ["майнкрафт", "пірати"]});

  @override
  _CatalogViewState createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  late List<Book> availableBooks;

  @override
  void initState() {
    super.initState();
    availableBooks = widget.books;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TagsView(
              books: widget.books,
              onTagChange: onTagChange,
              rootTags: widget.rootTags,
            ),
          ),
        ),
        Expanded(
          flex: 15,
          child: SingleChildScrollView(
            child: Column(
              children: availableBooks
                  .map(
                    (book) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: ElevatedButton(
                          child: CatalogCardBookView(
                            book: book,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CatalogBookView(
                                    book: book,
                                    books: widget.books,
                                  );
                                },
                              ),
                            );
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
          flex: 3,
          child: Hero(
            tag: "PlayControls",
            child: PlayControlsView(),
          ),
        ),
      ],
    );
  }

  onTagChange(List<Book> books) {
    setState(() {
      availableBooks = books;
    });
  }
}
