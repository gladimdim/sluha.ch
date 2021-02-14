import 'dart:math';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Wrap(
                children: [
                  Center(
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
                  SingleChildScrollView(
                    child: Column(
                        children: widget.book.files.map((file) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 4, color: Theme
                                    .of(context)
                                    .buttonColor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        file.title,
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.play_arrow),
                                          onPressed: null)
                                    ]),
                              ),
                            ),
                          );
                        }).toList()),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 44,
                child: Container(
                  color: Theme
                      .of(context)
                      .backgroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(

                          icon: Icon(Icons.skip_previous_outlined),
                          iconSize: 32,
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.settings_backup_restore),
                          iconSize: 32,
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.play_circle_filled_outlined),
                          iconSize: 32,
                          onPressed: () {}),
                      Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: IconButton(
                              icon: Icon(Icons.settings_backup_restore),
                              iconSize: 32,
                              onPressed: () {})),
                      IconButton(
                          icon: Icon(Icons.skip_next_outlined),
                          iconSize: 32,
                          onPressed: () {}),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
