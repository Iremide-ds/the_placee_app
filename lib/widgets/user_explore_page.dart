import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import './post_card_widget.dart';
import '../constants/my_constants.dart';

class UserExplorePage extends StatefulWidget {
  final List<Widget> searchResults;

  const UserExplorePage({Key? key, required this.searchResults})
      : super(key: key);

  @override
  State<UserExplorePage> createState() => _UserExplorePageState();
}

class _UserExplorePageState extends State<UserExplorePage> {
  final List<Widget> _hotTopics = [];
  final List<Widget> _topicsFeed = [];

  void _buildHotTopics(List totalPosts) {
    _hotTopics.clear();
    _hotTopics.add(SizedBox(width: MediaQuery.of(context).size.width * 0.045));
    _hotTopics.addAll(totalPosts.map((doc) {
      return PostCard(
          width: MediaQuery.of(context).size.width * 0.4,
          // height: MediaQuery.of(context).size.height * 0.2,
          title: doc['title'],
          borderRadius: MyBorderRadius.borderRadius,
          imageUrl: doc['image_url']);
    }).toList());
  }

  void _buildExploreFeed(List totalPosts) {
    int count = 0;
    _topicsFeed.clear();
    _topicsFeed.add(SizedBox(width: MediaQuery.of(context).size.width * 0.045));
    _topicsFeed.addAll(totalPosts.map((doc) {
      count += 1;
      return StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: (count % 2 == 0) ? 1.7 : 2,
          child: PostCard(
              width: MediaQuery.of(context).size.width * 0.4,
              // height: MediaQuery.of(context).size.height * 0.2,
              title: doc['title'],
              borderRadius: MyBorderRadius.borderRadius2,
              imageUrl: doc['image_url']));
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data?.docs == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<QueryDocumentSnapshot<Object?>> totalPosts =
              snapshot.data!.docs;

          _buildHotTopics(totalPosts);
          _buildExploreFeed(totalPosts);

          return ListView(
            children: [
              Container(
                padding:
                    EdgeInsets.fromLTRB(0.0, size.height * 0.021, 0.0, 0.0),
                child: Column(
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
              Container(
                padding: EdgeInsets.fromLTRB(size.width * 0.02,
                    size.height * 0.021, size.width * 0.02, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.04),
                      child: Text(
                        widget.searchResults.isEmpty ? 'Trending' : 'Results',
                        style: const TextStyle(
                          color: Color(0xff1E4B6C),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.006,
                    ),
                    SizedBox(
                      width: size.width,
                      child: widget.searchResults.isEmpty
                          ? StaggeredGrid.count(
                              crossAxisCount: 2,
                              children: _topicsFeed,
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: widget.searchResults,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
