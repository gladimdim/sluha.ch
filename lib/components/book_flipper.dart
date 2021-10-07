import 'dart:math';

import 'package:audiobooks_app/components/book_cover.dart';
import 'package:audiobooks_app/components/book_meta_field_view.dart';
import 'package:audiobooks_app/components/flipper.dart';
import 'package:audiobooks_app/components/title_text.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:flutter/material.dart';

class BookFlipper extends StatelessWidget {
  final Book? book;
  const BookFlipper({Key? key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final b = book;
    if (b == null) {
      return Image.asset(
        "assets/sluhach_logo.png",
        width: 256,
        fit: BoxFit.fitWidth,
      );
    } else {
      return Flipper(
        frontBuilder: (context) =>
            Center(
              child: Hero(
                tag: b.id,
                child: BookCover(
                  book: b,
                ),
              ),
            ),
        backBuilder: (context) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform(
                transform: Matrix4.rotationY(pi),
                alignment: Alignment.center,
                child: BookCover(
                  book: b,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0),
                child: Container(
                  color: Theme
                      .of(context)
                      .primaryColor
                      .withAlpha(220),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.all(
                              8.0),
                          child: TitleText(
                              b.title),
                        ),
                        BookMetaFieldView("Серія",
                            b.seriesTitle),
                        BookMetaFieldView("Автор",
                            b.author),
                        BookMetaFieldView(
                            "Рік",
                            b.year
                                .toString()),
                        BookMetaFieldView(
                            "Тривалість",
                            b.duration
                                .inMinutes
                                .toString()),
                        BookMetaFieldView("Вік",
                            "${b.ageRating}+"),
                        Column(
                          children: [
                            TitleText("Описання"),
                            Text(
                                b.description,
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
