import 'dart:math';

import 'package:audiobooks_app/components/headline_text.dart';
import 'package:audiobooks_app/components/icon_button_styled.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:flutter/material.dart';

class CatalogBookView extends StatefulWidget {
  final Book book;

  CatalogBookView({this.book});

  @override
  _CatalogBookViewState createState() => _CatalogBookViewState();
}

class _CatalogBookViewState extends State<CatalogBookView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Hero(
                      tag: widget.book.id,
                      child: Image.asset(
                        widget.book.imageUrl,
                        width: 256,
                        fit: BoxFit.fitWidth,
                      ),
                      // child: CatalogCardBookView(
                      //   book: widget.book,
                      // ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                        children: widget.book.files.map((file) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 4, color: Theme.of(context).buttonColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HeadlineText(
                                  file.title,
                                ),
                                IconButtonStyled(
                                  iconData: Icons.play_arrow_outlined,
                                  onPressed: null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList()),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeadlineText("Зараз грає"),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButtonStyled(
                            iconData: Icons.skip_previous_outlined,
                            onPressed: () {}),
                        IconButtonStyled(
                            iconData: Icons.settings_backup_restore,
                            onPressed: () {}),
                        IconButtonStyled(
                            iconData: Icons.play_circle_filled_outlined,
                            onPressed: () {}),
                        Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(pi),
                            child: IconButtonStyled(
                                iconData: Icons.settings_backup_restore,
                                onPressed: () {})),
                        IconButtonStyled(
                            iconData: Icons.skip_next_outlined,
                            onPressed: () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
