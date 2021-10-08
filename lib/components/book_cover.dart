import 'package:audiobooks_app/models/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:transparent_image/transparent_image.dart';

class BookCover extends StatelessWidget {
  final Book? book;

  BookCover({required this.book});

  @override
  Widget build(BuildContext context) {
    if (book == null) {
      return Image.asset(
        "assets/sluhach_logo.png",
        fit: BoxFit.fitWidth,
      );
    } else {
      return book!.local
          ? Image.asset(
        book!.localImageUrl,
        fit: BoxFit.fitWidth,
      )
          : FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: book!.remoteImageUrl,
        fit: BoxFit.fitWidth,
      );
    }
  }
}
