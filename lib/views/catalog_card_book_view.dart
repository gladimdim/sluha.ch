import 'package:audiobooks_app/components/book_meta_field_view.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:flutter/material.dart';

class CatalogCardBookView extends StatelessWidget {
  final Book book;

  CatalogCardBookView({this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Hero(
          tag: book.id,
          child: Image.asset(
            book.imageUrl,
            width: 256,
            fit: BoxFit.fitWidth,
          ),
          // child: CatalogCardBookView(
          //   book: widget.book,
          // ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              book.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            BookMetaFieldView("Автор", book.author),
            BookMetaFieldView("Рік", book.year.toString()),
            BookMetaFieldView(
                "Тривалість", book.duration.inMinutes.toString()),
            BookMetaFieldView("Вік", "${book.ageRating}+"),
          ],
        ),
      ],
    );
  }
}
