import 'package:audiobooks_app/components/book_stats_report.dart';
import 'package:audiobooks_app/components/headline_text.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/models/book_file.dart';
import 'package:audiobooks_app/models/player.dart';
import 'package:flutter/material.dart';

class PlaylistSection extends StatefulWidget {
  final Book book;

  const PlaylistSection({Key? key, required this.book}) : super(key: key);

  @override
  _PlaylistSectionState createState() => _PlaylistSectionState();
}

class _PlaylistSectionState extends State<PlaylistSection> {
  @override
  Widget build(BuildContext context) {
    final player = Player.instance;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: BookStatsReport(book: widget.book),
          ),
          Column(
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
                              width: 4, color: Theme.of(context).buttonColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HeadlineText(
                                file.title,
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  StreamBuilder(
                                    stream: file.changes,
                                    builder: (context, data) {
                                      switch (data.data) {
                                        case OFFLINE_STATUS.LOADED:
                                          return Icon(
                                            Icons.offline_pin,
                                            size: 32,
                                          );
                                        case OFFLINE_STATUS.NOT_LOADED:
                                          return Container();
                                        case OFFLINE_STATUS.LOADING:
                                          return CircularProgressIndicator(color: Theme.of(context).backgroundColor,);
                                        default:
                                          return Container();
                                      }
                                    },
                                  ),
                                  Checkbox(
                                      value: file.queued,
                                      onChanged: (value) {
                                        setState(() {
                                          file.queued = value!;
                                        });
                                      }),
                                  Icon(Player.instance
                                          .isCurrentlyPlayingThisFile(file)
                                      ? Icons.pause_circle_filled_outlined
                                      : Icons.play_arrow_outlined),
                                ],
                              ),
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
        ],
      ),
    );
  }
}
