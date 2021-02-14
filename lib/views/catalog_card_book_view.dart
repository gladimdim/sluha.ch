import 'package:audiobooks_app/components/book_meta_field_view.dart';
import 'package:audiobooks_app/components/title_text.dart';
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TitleText(book.title),
            ),
            BookMetaFieldView("Автор", book.author),
            BookMetaFieldView("Рік", book.year.toString()),
            BookMetaFieldView("Тривалість", book.duration.inMinutes.toString()),
            BookMetaFieldView("Вік", "${book.ageRating}+"),
          ],
        ),
      ],
    );
  }
}
