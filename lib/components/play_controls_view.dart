import 'dart:math';

import 'package:audiobooks_app/components/currently_playing.dart';
import 'package:audiobooks_app/components/file_progress_view.dart';
import 'package:audiobooks_app/components/icon_button_styled.dart';
import 'package:audiobooks_app/models/player.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';

class PlayControlsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Player player = Player.instance;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: StreamBuilder(
                  stream: player.playbackChanges,
                  builder: (context, data) => CurrentlyPlaying(
                    Player.instance.currentFile,
                    player.getBookTitle,
                  ),
                ),
              ),
              Expanded(flex: 1, child: FileProgressView()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButtonStyled(
                  iconData: Icons.skip_previous_outlined,
                  onPressed: player.playPrevious),
              IconButtonStyled(
                  iconData: Icons.settings_backup_restore, onPressed: () {}),
              StreamBuilder(
                  stream: player.playbackChanges,
                  builder: (context, data) {
                    if (data.hasData) {
                      AudioPlayerState state = data.data;
                      if (state == AudioPlayerState.PLAYING) {
                        return IconButtonStyled(
                            iconData: Icons.pause_circle_filled_outlined,
                            onPressed: player.pause);
                      }
                      if (state == AudioPlayerState.PAUSED) {
                        return IconButtonStyled(
                            iconData: Icons.play_circle_filled_outlined,
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
    );
  }
}
