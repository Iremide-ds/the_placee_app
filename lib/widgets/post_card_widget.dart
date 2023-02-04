import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final double width/*, height*/;
  final String title;
  final BorderRadius borderRadius;
  final String imageUrl;

  const PostCard(
      {Key? key,
      required this.width,
      required this.title,
      required this.borderRadius,
      required this.imageUrl/*, required this.height*/})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: SizedBox(
        // height: height,
        width: width,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: Colors.transparent,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    imageUrl,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: Colors.white,
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.grey.withOpacity(0.0),
                    Colors.black54.withOpacity(0.9),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 12.0),
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
