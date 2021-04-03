import 'package:audiobooks_app/models/book.dart';

import 'package:audiobooks_app/extensions/list.dart';

List<Book> booksWithTags(List<Book> books, List<String> tags) {
  return books.where((book) =>
      book.tags.intersection(tags, (a, b) => a == b).length == tags.length).toList();
}
