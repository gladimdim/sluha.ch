import 'package:flutter/material.dart';

class IconButtonStyled extends StatelessWidget {
  final IconData iconData;
  final Function onPressed;

  IconButtonStyled({this.iconData, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          iconData,
          color: Theme.of(context).buttonColor,
        ),
        iconSize: 60,
        onPressed: onPressed);
  }
}
