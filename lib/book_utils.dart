import 'package:audiobooks_app/models/book.dart';

import 'package:audiobooks_app/extensions/list.dart';

List<Book> booksWithTags(List<Book> books, List<String> tags) {
  return books.where((book) =>
      book.tags.intersection(tags, (a, b) => a == b).length == tags.length).toList();
}

List<String> allTagsForBooks(List<Book> books) {
  List<String> allTags = [];
  books.forEach((book) {
    allTags.addAll(book.tags);
  });
  return allTags.toSet().toList();
}

int amountOfBooksForTag(String tag, List<Book> books) {
  return books.fold(0, (previousValue, book) {
    if (book.tags.contains(tag)) {
      return previousValue + 1;
    }
    return previousValue;
  });
}