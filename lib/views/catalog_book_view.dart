import 'dart:math';

import 'package:audiobooks_app/components/book_cover.dart';
import 'package:audiobooks_app/components/book_meta_field_view.dart';
import 'package:audiobooks_app/components/flipper.dart';
import 'package:audiobooks_app/components/headline_text.dart';
import 'package:audiobooks_app/components/play_controls_view.dart';
import 'package:audiobooks_app/components/title_text.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/book_file.dart';
import 'package:audiobooks_app/models/player.dart';
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
    var player = Player.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Flipper(
                    frontBuilder: (context) => Center(
                      child: Hero(
                        tag: widget.book.id,
                        child: BookCover(
                          book: widget.book,
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
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              color:
                                  Theme.of(context).primaryColor.withAlpha(220),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TitleText(widget.book.title),
                                    ),
                                    BookMetaFieldView(
                                        "Серія", widget.book.seriesTitle),
                                    BookMetaFieldView(
                                        "Автор", widget.book.author),
                                    BookMetaFieldView(
                                        "Рік", widget.book.year.toString()),
                                    BookMetaFieldView(
                                        "Тривалість",
                                        widget.book.duration.inMinutes
                                            .toString()),
                                    BookMetaFieldView(
                                        "Вік", "${widget.book.ageRating}+"),
                                    Column(
                                      children: [
                                        TitleText("Описання"),
                                        Text(widget.book.description,
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
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: downloadBook,
                          icon: Icon(Icons.get_app),
                        ),
                        IconButton(
                          onPressed: removeDownloads,
                          icon: Icon(Icons.delete_forever),
                        ),
                        StreamBuilder<int>(
                          stream: widget.book.fileSizeChanges,
                          initialData: 0,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data;
                              var inMb = (data / 1000 / 1000).floor();
                              return Text("${inMb.toString()} Mb");
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: widget.book.files.fold(
                              true,
                              (previousValue, file) =>
                                  previousValue && file.queued),
                          onChanged: processPlayAll,
                        ),
                        Text("Грати все"),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: player.playbackChanges,
                          builder: (context, data) => Column(
                              children: widget.book.files.map((file) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: player.currentFile == file
                                        ? Theme.of(context).accentColor
                                        : null,
                                    border: Border.all(
                                        width: 4,
                                        color: Theme.of(context).buttonColor),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        HeadlineText(
                                          file.title,
                                        ),
                                        Wrap(children: [
                                          StreamBuilder(
                                            stream: file.changes,
                                            builder: (context, data) {
                                              switch (data.data) {
                                                case OFFLINE_STATUS.LOADED:
                                                  return Icon(Icons
                                                      .download_done_outlined);
                                                  break;
                                                case OFFLINE_STATUS.NOT_LOADED:
                                                  return Container();
                                                case OFFLINE_STATUS.LOADING:
                                                  return CircularProgressIndicator();
                                                default:
                                                  return Container();
                                              }
                                            },
                                          ),
                                          Checkbox(
                                              value: file.queued,
                                              onChanged: (value) {
                                                setState(() {
                                                  file.queued = value;
                                                });
                                              }),
                                          Icon(Player.instance
                                                  .isCurrentlyPlayingThisFile(
                                                      file)
                                              ? Icons
                                                  .pause_circle_filled_outlined
                                              : Icons.play_arrow_outlined),
                                        ]),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  player.play(widget.book, file);
                                },
                              ),
                            );
                          }).toList()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Hero(tag: "PlayControls", child: PlayControlsView()),
          )
        ],
      ),
    );
  }

  void downloadBook() async {
    await widget.book.downloadBook();
    setState(() {});
  }

  void removeDownloads() async {
    await widget.book.removeDownloads();
    setState(() {});
  }

  void processPlayAll(bool selectAll) {
    widget.book.files.forEach((file) {
      file.queued = selectAll;
    });
    setState(() {});
  }
}
