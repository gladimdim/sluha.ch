import 'package:flutter/material.dart';

class BookMetaFieldView extends StatelessWidget {
  final String name;
  final String value;

  BookMetaFieldView(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 3,
            color: Theme.of(context).accentColor,
          )
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: Theme.of(context).textTheme.headline6,),
          Text(value, style: Theme.of(context).textTheme.headline6,),
        ],
      ),
    );
  }
}
