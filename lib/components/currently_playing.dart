import 'package:audiobooks_app/components/headline_text.dart';
import 'package:audiobooks_app/components/marquee.dart';
import 'package:audiobooks_app/models/book_file.dart';
import 'package:audiobooks_app/models/player.dart';
import 'package:flutter/material.dart';

class CurrentlyPlaying extends StatelessWidget {
  final BookFile? file;
  final String bookTitle;

  CurrentlyPlaying(this.file, this.bookTitle);

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return HeadlineText("Трек не вибрано");
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: HeadlineText(file!.title),
      );
    }
  }
}
