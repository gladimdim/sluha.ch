import 'package:audiobooks_app/book_utils.dart';
import 'package:audiobooks_app/components/title_text.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:flutter/material.dart';

import 'package:audiobooks_app/extensions/list.dart';

class TagsView extends StatefulWidget {
  final List<Book> books;
  final List<String> rootTags;
  final Function(List<Book>) onTagChange;

  TagsView({this.books, this.onTagChange, this.rootTags = const ["майнкрафт", "фортнайт"]});

  @override
  _TagsViewState createState() => _TagsViewState();
}

class _TagsViewState extends State<TagsView> {
  Set<String> selectedTags = Set();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: activeTags.map(
        (tag) {
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
        },
      ).toList(),
    );
  }

  List<String> get activeTags {
    return selectedTags.isEmpty ? widget.rootTags : allTagsForBookSet(availableBooks).toList();
  }

  amountOfBooksForTag(String tag) {
    return availableBooks.fold(0, (previousValue, book) {
      if (book.tags.contains(tag)) {
        return previousValue + 1;
      }
      return previousValue;
    });
  }

  selectTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
    widget.onTagChange(availableBooks);
    setState(() {});
  }

  List<Book> get availableBooks {
    if (selectedTags.isEmpty) {
      return widget.books;
    }
    return booksWithTags(widget.books, selectedTags.toList());
  }

  List<String> allTagsForBookSet(List<Book> books) {
    List<String> allTags = [];
    books.forEach((book) {
      allTags.addAll(book.tags);
    });
    return allTags.toSet().toList();
  }
}
