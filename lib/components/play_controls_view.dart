import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks_app/components/currently_playing.dart';
import 'package:audiobooks_app/components/file_progress_view.dart';
import 'package:audiobooks_app/components/icon_button_styled.dart';
import 'package:audiobooks_app/models/player.dart';
import 'package:flutter/material.dart';

class PlayControlsView extends StatelessWidget {
  final AudioHandler audioHandler;

  PlayControlsView({this.audioHandler});

  @override
  Widget build(BuildContext context) {
    final Player player = Player.instance;
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 4.0),
        color: Theme.of(context).primaryColor,
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
                  child: StreamBuilder(
                      stream: player.progressChanges,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Duration value = snapshot.data;
                          var max = Player
                              .instance.audioPlayer.duration.inSeconds
                              .toDouble();
                          var inDouble = value.inSeconds.toDouble();
                          return Slider(
                            min: 0,
                            max: max,
                            value: inDouble,
                            label: "Duration",
                            onChanged: (value) {},
                          );
                        } else {
                          return Container();
                        }
                      }),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButtonStyled(
                      iconData: Icons.skip_previous_outlined,
                      onPressed: player.playPrevious),
                  IconButtonStyled(
                      iconData: Icons.settings_backup_restore,
                      onPressed: player.rewind30),
                  StreamBuilder(
                      stream: audioHandler.playbackState,
                      builder: (context, data) {
                        if (data.hasData) {
                          PlaybackState state = data.data;
                          if (state.playing) {
                            return IconButtonStyled(
                                iconData: Icons.pause_circle_filled_outlined,
                                onPressed: () {
                                  audioHandler.pause();
                                  // Player.instance.pause();
                                });
                          }
                          if (!state.playing) {
                            return IconButtonStyled(
                                iconData: Icons.play_circle_filled_outlined,
                                onPressed: () {
                                  audioHandler.play();
                                });
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
                          onPressed: () {
                            audioHandler.skipToPrevious();
                            player.skip30();
                          })),
                  IconButtonStyled(
                      iconData: Icons.skip_next_outlined,
                      onPressed: () {
                        audioHandler.skipToNext();
                        player.playNext();
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
