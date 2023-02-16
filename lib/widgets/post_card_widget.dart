import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/article_screen.dart';

class PostCard extends StatelessWidget {
  final double width /*, height*/;
  final String title;
  final BorderRadius borderRadius;
  final String imageUrl;
  final QueryDocumentSnapshot<Object?> post;
  final Function changeScreen;

  const PostCard(
      {Key? key,
      required this.width,
      required this.title,
      required this.borderRadius,
      required this.imageUrl, required this.post, required this.changeScreen /*, required this.height*/
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ArticleScreen.routeName, arguments: {'post': post, 'function': changeScreen});
      },
      child: Card(
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14 * MediaQuery.of(context).textScaleFactor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
