import 'package:audiobooks_app/components/play_controls_view.dart';
import 'package:audiobooks_app/components/title_text.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/views/catalog_book_view.dart';
import 'package:audiobooks_app/views/catalog_card_book_view.dart';
import 'package:flutter/material.dart';
import 'package:audiobooks_app/extensions/list.dart';
class CatalogView extends StatefulWidget {
  final List<Book> books;

  CatalogView({this.books});

  @override
  _CatalogViewState createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  Set<String> selectedTags = Set();
  final List<String> tags = ["майнкрафт", "фортнайт"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Row(
              children: tags.map((tag) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                  child: InputChip(
                    backgroundColor: Theme.of(context).primaryColor,
                    selectedColor: Theme.of(context).accentColor,
                    label: TitleText("$tag (${amountOfBooksForTag(tag)})"),
                    selected: selectedTags.contains(tag),
                    onSelected: (selected) {
                      selectTag(tag);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          flex: 15,
          child: SingleChildScrollView(
            child: Column(
              children: widget.books
                  .where((book) {
                    if (selectedTags.isEmpty) {
                      return true;
                    } else {
                      return book.tags.intersection(selectedTags.toList(), (a, b) => a == b).isNotEmpty;
                    }
                  })
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
                                  return CatalogBookView(book: book);
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
          child: Hero(tag: "PlayControls", child: PlayControlsView()),
        ),
      ],
    );
  }

  selectTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
    setState(() {});
  }

  amountOfBooksForTag(String tag) {
    return widget.books.fold(0, (previousValue, book) {
      if (book.tags.contains(tag)) {
        return previousValue + 1;
      }
      return previousValue;
    });
  }
}
