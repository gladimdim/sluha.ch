import 'package:flutter/material.dart';

class IconButtonStyled extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;
  final double size;

  IconButtonStyled({required this.iconData, this.onPressed, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        highlightColor: Theme.of(context).accentColor,
        hoverColor: Theme.of(context).accentColor,
        splashColor: Theme.of(context).backgroundColor,
        icon: Icon(
          iconData,
          color: Theme.of(context).buttonColor,
        ),
        iconSize: size,
        onPressed: onPressed);
  }
}
