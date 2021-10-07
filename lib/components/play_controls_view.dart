import 'dart:math';

import 'package:audiobooks_app/components/book_cover.dart';
import 'package:audiobooks_app/components/currently_playing.dart';
import 'package:audiobooks_app/components/file_progress_view.dart';
import 'package:audiobooks_app/components/icon_button_styled.dart';
import 'package:audiobooks_app/components/interactive_slider.dart';
import 'package:audiobooks_app/models/player.dart';
import 'package:audiobooks_app/utils.dart';
import 'package:flutter/material.dart';

final playerControlsKey = GlobalKey();

class PlayControlsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Player player = Player.instance;
    final portrait = isPortrait(MediaQuery.of(context).size);
    return Material(
      color: Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.only(top: 2.0),
        // color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            if (!portrait)  Expanded(
              flex: 2,
              child: StreamBuilder(
                stream: player.playbackChanges,
                builder: (context, snapshot) {
                  return BookCover(book: Player.instance.book);
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: StreamBuilder(
                    stream: player.playbackChanges,
                    builder: (context, snapshot) {
                      return BookCover(book: Player.instance.book);
                    },
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2.0, left: 8.0, right: 8.0),
                        child: StreamBuilder(
                          stream: player.playbackChanges,
                          builder: (context, data) => CurrentlyPlaying(
                            Player.instance.currentFile,
                            player.getBookTitle,
                          ),
                        ),
                      ),
                      InteractiveSlider(
                        player: player,
                        key: GlobalKey(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButtonStyled(
                              iconData: Icons.skip_previous_outlined,
                              onPressed: player.playPrevious),
                          StreamBuilder<bool>(
                              stream: player.playbackChanges,
                              builder: (context, data) {
                                if (data.hasData) {
                                  var isPlaying = data.data!;
                                  if (isPlaying) {
                                    return IconButtonStyled(
                                        iconData:
                                            Icons.pause_circle_filled_outlined,
                                        onPressed: player.pause);
                                  } else {
                                    return IconButtonStyled(
                                        iconData:
                                            Icons.play_circle_filled_outlined,
                                        onPressed: () => player.resume());
                                  }
                                } else {
                                  return IconButtonStyled(
                                    iconData: Icons.play_circle_filled_outlined,
                                  );
                                }
                              }),
                          IconButtonStyled(
                              iconData: Icons.skip_next_outlined,
                              onPressed: player.playNext),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
