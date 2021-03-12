import 'dart:math';

import 'package:audiobooks_app/components/currently_playing.dart';
import 'package:audiobooks_app/components/file_progress_view.dart';
import 'package:audiobooks_app/components/icon_button_styled.dart';
import 'package:audiobooks_app/components/interactive_slider.dart';
import 'package:audiobooks_app/models/player.dart';
import 'package:flutter/material.dart';

class PlayControlsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Player player = Player.instance;
    return Material(
      color: Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.only(top: 4.0),
        // color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0),
              child: StreamBuilder(
                stream: player.playbackChanges,
                builder: (context, data) => CurrentlyPlaying(
                  Player.instance.currentFile,
                  player.getBookTitle,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: InteractiveSlider(
                    player: player,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: FileProgressView(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButtonStyled(
                    iconData: Icons.skip_previous_outlined,
                    onPressed: player.playPrevious),
                IconButtonStyled(
                    iconData: Icons.settings_backup_restore,
                    onPressed: player.rewind30),
                StreamBuilder(
                    stream: player.playbackChanges,
                    builder: (context, data) {
                      if (data.hasData) {
                        var isPlaying = data.data;
                        if (isPlaying) {
                          return IconButtonStyled(
                              iconData: Icons.pause_circle_filled_outlined,
                              onPressed: player.pause);
                        } else {
                          return IconButtonStyled(
                              iconData: Icons.play_circle_filled_outlined,
                              onPressed: player.resume);
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
                        onPressed: player.skip30)),
                IconButtonStyled(
                    iconData: Icons.skip_next_outlined,
                    onPressed: player.playNext),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
