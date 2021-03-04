import 'package:audio_service/audio_service.dart';
import 'package:audiobooks_app/models/book.dart';
import 'package:audiobooks_app/views/catalog_view.dart';
import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  final AudioHandler audioHandler;

  MainView({this.audioHandler});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Слухач"),
      ),
      body: CatalogView(books: generateBooks(), audioHandler: audioHandler),
    );
  }
}
