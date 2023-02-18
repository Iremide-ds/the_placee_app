import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/logo_icon_widget.dart';

class FeedBackScreen extends StatelessWidget {
  static const String routeName = '/feedback_and_help';

  const FeedBackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: size.height * 0.11,
                width: size.width,
                child: const Center(
                    child: ThePlaceeIcon(color: Color(0xff1E4B6C)))),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: size.height * 0.08,
                        backgroundColor: const Color(0xffEBEBEB),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xff1E4B6C),
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        'David Ayewa',
                        style: TextStyle(fontSize: 16 * textScaleFactor),
                      ),
                      Text(
                        'Designer',
                        style: TextStyle(
                          color: const Color(0xff1E4B6C),
                          fontSize: 16 * textScaleFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/linkedin_icon.svg',
                          fit: BoxFit.contain,
                          height: size.height * 0.035,
                          width: size.width * 0.2,
                          color: const Color(0xff1E4B6C),
                        ),
                        SizedBox(width: size.width * 0.01),
                        Text(
                          'Loading...',
                          style: TextStyle(fontSize: 16 * textScaleFactor),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/behance_icon.svg',
                          fit: BoxFit.contain,
                          height: size.height * 0.035,
                          width: size.width * 0.2,
                          color: const Color(0xff1E4B6C),
                        ),
                        SizedBox(width: size.width * 0.01),
                        Text(
                          'Loading...',
                          style: TextStyle(fontSize: 16 * textScaleFactor),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: size.height * 0.08,
                        backgroundColor: const Color(0xffEBEBEB),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xff1E4B6C),
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        'Iremide Adeboye',
                        style: TextStyle(fontSize: 16 * textScaleFactor),
                      ),
                      Text(
                        'Developer',
                        style: TextStyle(
                          color: Color(0xff1E4B6C),
                          fontSize: 16 * textScaleFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/linkedin_icon.svg',
                          fit: BoxFit.contain,
                          height: size.height * 0.035,
                          width: size.width * 0.2,
                          color: const Color(0xff1E4B6C),
                        ),
                        SizedBox(width: size.width * 0.01),
                        Text(
                          'Iremide Adeboye',
                          style: TextStyle(fontSize: 16 * textScaleFactor),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/github_icon.svg',
                          fit: BoxFit.contain,
                          height: size.height * 0.035,
                          width: size.width * 0.2,
                          color: const Color(0xff1E4B6C),
                        ),
                        SizedBox(width: size.width * 0.01),
                        Text(
                          'Iremide-ds',
                          style: TextStyle(fontSize: 16 * textScaleFactor),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
