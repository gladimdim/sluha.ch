import 'package:audiobooks_app/components/title_text.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:flutter/material.dart';

import 'package:audiobooks_app/extensions/list.dart';

class TagsView extends StatefulWidget {
  List<Book> books;
  Function(List<Book>) onTagChange;

  TagsView({this.books, this.onTagChange});

  @override
  _TagsViewState createState() => _TagsViewState();
}

class _TagsViewState extends State<TagsView> {
  Set<String> selectedTags = Set();
  final List<String> tags = ["майнкрафт", "фортнайт"];

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }

  amountOfBooksForTag(String tag) {
    return widget.books.fold(0, (previousValue, book) {
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
    final availableBooks = widget.books.where((book) {
      if (selectedTags.isEmpty) {
        return true;
      } else {
        return book.tags
                .intersection(selectedTags.toList(), (a, b) => a == b)
                .length ==
            selectedTags.length;
      }
    }).toList();

    widget.onTagChange(availableBooks);
    setState(() {});
  }
}
