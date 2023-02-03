import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredBgButton extends StatelessWidget {
  const BlurredBgButton({
    Key? key,
    required this.height,
    required this.width,
    required this.iconWidget,
    required this.text, required this.onTap, required this.hasArgs, this.onTapArgs,
  }) : super(key: key);

  final double height;
  final double width;
  final Widget iconWidget;
  final String text;
  final Function onTap;
  final bool hasArgs;
  final Map<String, dynamic>? onTapArgs;

  @override
  Widget build(BuildContext context) {
    // ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    const TextStyle blurredTextStyle = TextStyle(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600);
    final BorderRadius blurredBorderRadius = BorderRadius.circular(20);

    return ClipRRect(
      borderRadius: blurredBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: blurredBorderRadius),
          height: height,
          width: width,
          child: TextButton(
            onPressed: () {
              if (hasArgs) {
                onTap(onTapArgs);
              }else {
                onTap();
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox.fromSize(
                    size: const Size.fromRadius(12),
                    child: FittedBox(
                      child: iconWidget,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.019,
                  ),
                  Text(
                    text,
                    style: blurredTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
