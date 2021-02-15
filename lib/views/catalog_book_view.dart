import 'dart:math';

import 'package:audiobooks_app/components/currently_playing.dart';
import 'package:audiobooks_app/components/headline_text.dart';
import 'package:audiobooks_app/components/icon_button_styled.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/book_file.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';

class CatalogBookView extends StatefulWidget {
  final Book book;

  CatalogBookView({this.book});

  @override
  _CatalogBookViewState createState() => _CatalogBookViewState();
}

class _CatalogBookViewState extends State<CatalogBookView> {
  final AudioPlayer _player = AudioPlayer();
  BookFile _currentFile;

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
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _currentFile == file
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
                                  Icon(
                                      isCurrentlyPlayingThisFile(file) ? Icons.pause_circle_filled_outlined :Icons.play_arrow_outlined
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            play(file);
                          },
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
                  CurrentlyPlaying(_currentFile),
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
                        StreamBuilder(
                            stream: _player.onPlayerStateChanged,
                            builder: (context, data) {
                              if (data.hasData) {
                                AudioPlayerState state = data.data;
                                if (state == AudioPlayerState.PLAYING) {
                                  return IconButtonStyled(
                                      iconData:
                                          Icons.pause_circle_filled_outlined,
                                      onPressed: pause);
                                }
                                if (state == AudioPlayerState.PAUSED) {
                                  return IconButtonStyled(
                                      iconData:
                                          Icons.play_circle_filled_outlined,
                                      onPressed: resume);
                                }
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

  bool isCurrentlyPlayingThisFile(BookFile file) {
    return file == _currentFile && _player.state == AudioPlayerState.PLAYING;
  }

  void play(BookFile file) async {
    if (file == _currentFile && _player.state == AudioPlayerState.PLAYING) {
      pause();
      return;
    }
    await _player.play("https://sluha.ch/${file.url}");
    setState(() {
      _currentFile = file;
    });
  }

  void pause() async {
    if (_currentFile != null) {
      await _player.pause();
    }
  }

  void stop() async {
    if (_currentFile != null) {
      await _player.stop();
    }
  }

  void resume() async {
    if (_currentFile != null) {
      await _player.play("https://sluha.ch/${_currentFile.url}");
    }
  }
}
