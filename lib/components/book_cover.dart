import 'package:audiobooks_app/models/book.dart';
import 'package:flutter/cupertino.dart';

class BookCover extends StatelessWidget {
  final Book book;

  BookCover({this.book});

  @override
  Widget build(BuildContext context) {
    return book.local
        ? Image.asset(
            book.fullImageUrl,
            width: 256,
            fit: BoxFit.fitWidth,
          )
        : Image.network(
            book.fullImageUrl,
            width: 256,
            fit: BoxFit.fitWidth,
          );
  }
}
