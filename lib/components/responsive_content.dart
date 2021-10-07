import 'package:flutter/cupertino.dart';
import 'package:audiobooks_app/utils.dart';
class ResponsiveContent extends StatelessWidget {
  final Widget one;
  final Widget two;

  const ResponsiveContent({Key? key, required this.one, required this.two})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (isPortrait(MediaQuery.of(context).size)) {
        return Column(
          children: [one, two],
        );
      } else {
        return Row(
          children: [one, two],
        );
      }
    });
  }
}
