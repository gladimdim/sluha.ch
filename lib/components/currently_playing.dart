import 'package:audiobooks_app/components/headline_text.dart';
import 'package:audiobooks_app/components/title_text.dart';
import 'package:audiobooks_app/models/book_file.dart';
import 'package:flutter/material.dart';

class CurrentlyPlaying extends StatelessWidget {
  final BookFile file;
  final String bookTitle;

  CurrentlyPlaying(this.file, this.bookTitle);
  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return HeadlineText("Трек не вибрано");
    } else {
      return HeadlineText("$bookTitle: ${file.title}");
    }
  }
}
