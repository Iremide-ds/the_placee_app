import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/logo_icon_widget.dart';

class MySplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  const MySplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/');
    });

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? const Color(0xff2d383c)
            : Colors.white,
        child: Center(
          child:
              RepaintBoundary(child: const ThePlaceeIcon().animate().fadeIn()),
        ),
      ),
    );
  }
}
