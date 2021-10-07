import 'package:flutter/cupertino.dart';

class ResponsiveContent extends StatelessWidget {
  final Widget one;
  final Widget two;

  const ResponsiveContent({Key? key, required this.one, required this.two})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isPortrait = MediaQuery.of(context).size.height >
          MediaQuery.of(context).size.width;
      if (isPortrait) {
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
