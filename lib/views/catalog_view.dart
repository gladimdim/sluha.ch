import 'package:audiobooks_app/components/book_flipper.dart';
import 'package:audiobooks_app/components/play_controls_view.dart';
import 'package:audiobooks_app/components/playlist_section.dart';
import 'package:audiobooks_app/components/responsive_content.dart';
import 'package:audiobooks_app/components/tags_view.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/player.dart';
import 'package:audiobooks_app/utils.dart';
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
    final size = MediaQuery.of(context).size;
    final portrait = isPortrait(size);
    return Column(
      children: [
        if (portrait)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TagsView(
              books: widget.books,
              onTagChange: onTagChange,
              rootTags: widget.rootTags,
            ),
          ),
        Expanded(
          flex: 8,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: ResponsiveContent(
              one: Expanded(
                flex: portrait ? 10 : 5,
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
                                  _navigateToBook(book);
                                },
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              two: portrait
                  ? Container()
                  : Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Hero(
                              tag: "PlayControls",
                              child: PlayControlsView(
                                onNavigateToBookPress: _onNavigateToBookPress,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
        if (portrait)
          Expanded(
            flex: 2,
            child: Hero(
              tag: "PlayControls",
              child: PlayControlsView(
                onNavigateToBookPress: _onNavigateToBookPress,
              ),
            ),
          ),
      ],
    );
  }

  _navigateToBook(Book book) {
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
  }

  _onNavigateToBookPress(Book? book) {
    if (book == null) {
      return;
    }
    _navigateToBook(book);
  }

  onTagChange(List<Book> books) {
    setState(() {
      availableBooks = books;
    });
  }
}
