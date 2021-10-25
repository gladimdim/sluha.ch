import 'dart:math';

import 'package:audiobooks_app/components/book_cover.dart';
import 'package:audiobooks_app/components/book_flipper.dart';
import 'package:audiobooks_app/components/book_meta_field_view.dart';
import 'package:audiobooks_app/components/flipper.dart';
import 'package:audiobooks_app/components/play_controls_view.dart';
import 'package:audiobooks_app/components/playlist_section.dart';
import 'package:audiobooks_app/components/responsive_content.dart';
import 'package:audiobooks_app/components/title_text.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/player.dart';
import 'package:audiobooks_app/utils.dart';
import 'package:flutter/material.dart';

class CatalogBookView extends StatefulWidget {
  final Book book;
  final List<Book> books;

  CatalogBookView({required this.book, required this.books});

  @override
  _CatalogBookViewState createState() => _CatalogBookViewState();
}

class _CatalogBookViewState extends State<CatalogBookView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final portrait = isPortrait(size);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: ResponsiveContent(
                  one: Expanded(
                    flex: portrait ? 8 : 1,
                    child: Column(
                      children: [
                        portrait
                            ? Expanded(
                                flex: 3,
                                child: Flipper(
                                  frontBuilder: (context) => Center(
                                    child: Hero(
                                      tag: widget.book.id,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: BookCover(
                                              book: widget.book,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                              child: Icon(Icons.touch_app)),
                                        ],
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
                                            book: widget.book,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Container(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withAlpha(220),
                                            child: SingleChildScrollView(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TitleText(
                                                          widget.book.title),
                                                    ),
                                                    BookMetaFieldView(
                                                        "Серія",
                                                        widget
                                                            .book.seriesTitle),
                                                    BookMetaFieldView("Автор",
                                                        widget.book.author),
                                                    BookMetaFieldView(
                                                        "Рік",
                                                        widget.book.year
                                                            .toString()),
                                                    BookMetaFieldView(
                                                        "Тривалість",
                                                        widget.book.duration
                                                            .inMinutes
                                                            .toString()),
                                                    BookMetaFieldView("Вік",
                                                        "${widget.book.ageRating}+"),
                                                    Column(
                                                      children: [
                                                        TitleText("Описання"),
                                                        Text(
                                                            widget.book
                                                                .description,
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
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : Expanded(
                                flex: 5,
                                child: PlaylistSection(
                                  book: widget.book,
                                )),
                        if (portrait)
                          Expanded(
                              flex: 2,
                              child: PlaylistSection(
                                book: widget.book,
                              )),
                      ],
                    ),
                  ),
                  two: portrait
                      ? Container()
                      : Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: StreamBuilder(
                                    stream: Player.instance.playbackChanges,
                                    builder: (context, snapshot) {
                                      return BookFlipper(
                                        book: widget.book,
                                      );
                                    }),
                              ),
                              Expanded(
                                flex: 1,
                                child: Hero(
                                  tag: "PlayControls",
                                  child: PlayControlsView(),
                                ),
                              ),
                            ],
                          ),
                        )),
            ),
          ),
          if (portrait)
            Expanded(
              flex: 2,
              child: Hero(
                tag: "PlayControls",
                child: PlayControlsView(),
              ),
            )
        ],
      ),
    );
  }
}
