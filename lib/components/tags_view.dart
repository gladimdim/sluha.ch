import 'package:audiobooks_app/book_utils.dart';
import 'package:audiobooks_app/components/title_text.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:flutter/material.dart';

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
              label: TitleText("$tag (${amountOfBooksForTag(tag, availableBooks)})"),
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
    return selectedTags.isEmpty ? widget.rootTags : allTagsForBooks(availableBooks).toList();
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

}
