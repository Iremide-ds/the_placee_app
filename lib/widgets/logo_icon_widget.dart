import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class ThePlaceeIcon extends StatelessWidget {
  final Color? color;
  const ThePlaceeIcon({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/logo_1.svg',
      semanticsLabel: 'The Placee',
      color: color ?? Colors.white,
    );
  }
}
