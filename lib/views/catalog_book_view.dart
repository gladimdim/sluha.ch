import 'dart:math';

import 'package:audiobooks_app/components/currently_playing.dart';
import 'package:audiobooks_app/components/file_progress_view.dart';
import 'package:audiobooks_app/components/headline_text.dart';
import 'package:audiobooks_app/components/icon_button_styled.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/player.dart';
import 'package:audioplayer/audioplayer.dart';
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
                    child: StreamBuilder(
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
                                    Icon(Player.instance
                                            .isCurrentlyPlayingThisFile(file)
                                        ? Icons.pause_circle_filled_outlined
                                        : Icons.play_arrow_outlined),
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
                  StreamBuilder(
                    stream: player.playbackChanges,
                    builder: (context, data) => CurrentlyPlaying(
                      Player.instance.currentFile,
                    ),
                  ),
                  FileProgressView(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButtonStyled(
                            iconData: Icons.skip_previous_outlined,
                            onPressed: player.playPrevious),
                        IconButtonStyled(
                            iconData: Icons.settings_backup_restore,
                            onPressed: () {}),
                        StreamBuilder(
                            stream: player.playbackChanges,
                            builder: (context, data) {
                              if (data.hasData) {
                                AudioPlayerState state = data.data;
                                if (state == AudioPlayerState.PLAYING) {
                                  return IconButtonStyled(
                                      iconData:
                                          Icons.pause_circle_filled_outlined,
                                      onPressed: player.pause);
                                }
                                if (state == AudioPlayerState.PAUSED) {
                                  return IconButtonStyled(
                                      iconData:
                                          Icons.play_circle_filled_outlined,
                                      onPressed: player.resume);
                                }
                                return IconButtonStyled(
                                  iconData: Icons.play_circle_filled_outlined,
                                );
                              } else {
                                return IconButtonStyled(
                                  iconData: Icons.play_circle_filled_outlined,
                                );
                              }
                            }),
                        Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(pi),
                            child: IconButtonStyled(
                                iconData: Icons.settings_backup_restore,
                                onPressed: () {})),
                        IconButtonStyled(
                            iconData: Icons.skip_next_outlined,
                            onPressed: player.playNext),
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
