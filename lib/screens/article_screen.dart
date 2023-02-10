import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:the_placee/util/providers/db_provider.dart';

import '../widgets/post_card_widget.dart';
import '../constants/my_constants.dart';

class ArticleScreen extends StatefulWidget {
  static const String routeName = '/article_screen';

  final QueryDocumentSnapshot<Object?> post;
  final Function changeScreen;

  const ArticleScreen(
      {Key? key, required this.post, required this.changeScreen})
      : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final List<Widget> _hotTopics = [];

  void _buildHotTopics() {
    Provider.of<DBProvider>(context, listen: false).getAllPosts(true).then((totalPosts) {
      _hotTopics.clear();
      _hotTopics.add(SizedBox(width: MediaQuery.of(context).size.width * 0.045));
      _hotTopics.addAll(totalPosts.map((doc) {
        return PostCard(
          width: MediaQuery.of(context).size.width * 0.4,
          // height: MediaQuery.of(context).size.height * 0.2,
          title: doc['title'],
          borderRadius: MyBorderRadius.borderRadius,
          imageUrl: doc['image_url'],
          post: doc,
          changeScreen: widget.changeScreen,
        );
      }).toList());
    }).whenComplete(() {
      setState(() {});
    });
  }


  @override
  void initState() {
    super.initState();
    _buildHotTopics();
  }

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset(
            'assets/icons/back_button.svg',
            color: Colors.white,
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.changeScreen(1);
              Navigator.of(context).pop();
            },
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.explore, color: Color(0xff1E4B6C)),
            ),
          )
        ],
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height * 0.56,
              width: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    widget.post['image_url'],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.04, bottom: size.height * 0.01),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.thumb_up_alt_rounded,
                                color: Colors.white),
                            SizedBox(width: size.width * 0.007),
                            Text(
                              'Helpful',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16 * textScaleFactor),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: size.width * 0.04, bottom: size.height * 0.01),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.thumb_down_alt_rounded,
                                color: Colors.white),
                            SizedBox(width: size.width * 0.007),
                            Text(
                              'Not Helpful',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16 * textScaleFactor),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                width: size.width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.get('title'),
                        style: TextStyle(
                          color: const Color(0xff1E4B6C),
                          fontWeight: FontWeight.w600,
                          fontSize: 24 * textScaleFactor,
                        ),
                      ),
                      SizedBox(height: size.height * 0.009),
                      Text(
                        widget.post.get('content'),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16 * textScaleFactor,
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                maximumSize: Size.fromWidth(size.width * 0.34),
                                backgroundColor: Colors.white,
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  side: BorderSide(
                                    color: Color(0xff1E4B6C),
                                    width: 0.9,
                                  ),
                                ),
                              ),
                              child: Row(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/arrow.svg',
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: size.width * 0.007),
                                  Text(
                                    'Previous',
                                    style: TextStyle(
                                        color: const Color(0xff1E4B6C),
                                        fontSize: 16 * textScaleFactor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                maximumSize: Size.fromWidth(size.width * 0.34),
                                backgroundColor: Colors.white,
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  side: BorderSide(
                                    color: Color(0xff1E4B6C),
                                    width: 0.9,
                                  ),
                                ),
                              ),
                              child: Row(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                        color: const Color(0xff1E4B6C),
                                        fontSize: 16 * textScaleFactor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(width: size.width * 0.007),
                                  SvgPicture.asset(
                                    'assets/icons/arrow_2.svg',
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                        EdgeInsets.fromLTRB(0.0, size.height * 0.021, 0.0, 0.0),
                        child: _hotTopics.isEmpty ? const CircularProgressIndicator() : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: size.width * 0.045),
                              child: const Text(
                                'Top Stories',
                                style: TextStyle(
                                  color: Color(0xff1E4B6C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.006,
                            ),
                            FeedListView(
                                controller: ScrollController(initialScrollOffset: 2),
                                height: size.height * 0.15,
                                width: size.width,
                                children: _hotTopics),
                          ],
                        ),
                      ),
                    ],
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

class FeedListView extends StatelessWidget {
  final double height, width;
  final List<Widget> children;
  final ScrollController controller;

  const FeedListView(
      {Key? key,
        required this.height,
        required this.width,
        required this.children,
        required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ListView(
        controller: controller,
        physics: children.isEmpty
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: children.isEmpty
            ? [SizedBox(width: width, child: const CircularProgressIndicator())]
            : children,
      ),
    );
  }
}
