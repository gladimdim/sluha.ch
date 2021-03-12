import 'package:flutter/material.dart';

class HeadlineText extends StatelessWidget {
  final String text;

  HeadlineText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // overflow: TextOverflow.fade,
      maxLines: 1,
      softWrap: false,
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
