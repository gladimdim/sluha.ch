import 'package:flutter/material.dart';

class BookMetaFieldView extends StatelessWidget {
  final String name;
  final String value;

  BookMetaFieldView(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name),
        Text(value),
      ],
    );
  }
}
