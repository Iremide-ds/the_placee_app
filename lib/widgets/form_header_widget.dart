import 'package:flutter/material.dart';

class MyFormHeader extends StatelessWidget {
  final String header;
  final String description;
  const MyFormHeader({Key? key, required this.header, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: size.height * 0.1,
        maxHeight: size.height * 0.118,
        maxWidth: size.width,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            header,
            semanticsLabel: header,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xff1E4B6C),
            ),
          ),
          SizedBox(height: size.height * 0.012),
          Text(
            description,
            semanticsLabel:
            description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xffB4B4B4),
            ),
          ),
        ],
      ),
    );
  }
}
