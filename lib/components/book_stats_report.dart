import 'package:audiobooks_app/models/book.dart';
import 'package:flutter/material.dart';

class BookStatsReport extends StatefulWidget {
  final Book book;
  const BookStatsReport({Key? key, required this.book}) : super(key: key);

  @override
  State<BookStatsReport> createState() => _BookStatsReportState();
}

class _BookStatsReportState extends State<BookStatsReport> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: downloadBook,
              icon: Icon(Icons.get_app),
            ),
            IconButton(
              onPressed: removeDownloads,
              icon: Icon(Icons.delete_forever),
            ),
            StreamBuilder<int>(
              stream: widget.book.fileSizeChanges,
              initialData: 0,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;
                  var inMb = (data / 1000 / 1000).floor();
                  return Text("${inMb.toString()} Mb");
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void downloadBook() async {
    await widget.book.downloadBook();
    setState(() {});
  }

  void removeDownloads() async {
    await widget.book.removeDownloads();
    setState(() {});
  }
}
