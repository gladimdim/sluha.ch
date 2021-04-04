import 'package:audiobooks_app/components/book_cover.dart';
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
          child: BookCover(
            book: book,
          ),
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
        Column(
          children: [
            Text("Теги"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: book.tags
                    .map(
                      (tag) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Chip(
                          backgroundColor: Theme.of(context).accentColor,
                          label: Text(tag),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ],
    );
  }
}
