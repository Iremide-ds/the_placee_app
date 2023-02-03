import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import './post_card_widget.dart';
import '../util/providers/auth_provider.dart';

//news feed
class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  void _getCurrentUser(currentUser) async {}

  Widget _buildTopStories() {
    return const CircularProgressIndicator();
  }

  Widget _buildLatestStory() {
    return const CircularProgressIndicator();
  }

  List<Widget> _buildUserInterests() {
    //build user's top 5 interests
    return [
      const CircularProgressIndicator(),
      const CircularProgressIndicator()
    ];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        if (snapshot.data == null) return const CircularProgressIndicator();
        if (snapshot.data?.docs == null) {
          return const CircularProgressIndicator();
        }

        var currentUserGoogle =
            Provider.of<AuthProvider>(context).getCurrentUser;

        var currentUserEmail =
            Provider.of<AuthProvider>(context).getCurrentUserLoggedInWithEmail;

        const double radius = 20.0;
        const borderRadius = BorderRadius.only(
          bottomLeft: Radius.circular(radius),
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        );

        final List<QueryDocumentSnapshot<Object?>> totalPosts =
            snapshot.data!.docs;

        List<Widget> hotTopics = totalPosts.map((doc) {
          return PostCard(
              width: size.width * 0.32,
              title: doc['title'],
              borderRadius: borderRadius,
              imageUrl: doc['image_url']);
        }).toList();

        final int totalPostsCount = totalPosts.length;

        List<Widget> latestPosts = totalPosts
            .getRange(0, (totalPostsCount >= 5) ? 4 : totalPostsCount - 1)
            .map((doc) {
          return PostCard(
            width: size.width * 0.4,
            title: doc['title'],
            borderRadius: borderRadius,
            imageUrl: doc['image_url'],
          );
        }).toList();

        final List userInterests = [];
        Map<String, List> interestAndPosts = {};
        final List<Widget> interestFeed = [];
        List temp = [];
        FirebaseFirestore.instance
            .collection('user_details')
            .where('email',
                isEqualTo: currentUserGoogle?.email ?? currentUserEmail?.email)
            .limit(1)
            .get()
            .then((result) {
          if (kDebugMode) {
            print(result.docs.first.data()['interests'].runtimeType);
          }
          result.docs.first.data()['interests'].forEach((e) {
            userInterests.add(e);
          });

          for (var i in userInterests) {
            List tempCon = totalPosts.where((element) {
              Map? temp = element.data() as Map?;
              return temp?['topic'].toString() == i.toString();
            }).toList();

            interestAndPosts[i] = tempCon;
          }
          if (kDebugMode) {
            print('debugging - ${interestAndPosts.length}');
            print('debugging1 - ${userInterests.length}');
          }

          for (MapEntry<String, List> i in interestAndPosts.entries) {
            Widget feed = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(i.key),
                Row(
                  children: [
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.2,
                      child: FeedListView(
                          height: size.height * 0.14,
                          width: size.width,
                          children: i.value
                              .map((doc) => PostCard(
                              width: size.width * 0.4,
                              title: 'testing',
                              borderRadius: borderRadius,
                              imageUrl: doc['image_url']))
                              .toList()),
                    ),
                  ],
                ),
              ],
            );
            interestFeed.add(feed);
          }
          // userInterests.addAll(result.docs.first.data()['interests']);
        });
        //todo: loop the async gaps so that by the time the widgets are rendered the data would have arrived

        if (hotTopics.isEmpty ||
            latestPosts.isEmpty ||
            interestAndPosts.isEmpty) {
          if (kDebugMode) {
            print('no data!!!!');
          }
          return const CircularProgressIndicator();
        }

        return SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FeedListView(
                    height: size.height * 0.14,
                    width: size.width,
                    children: hotTopics),
                FeedListView(
                    height: size.height * 0.19,
                    width: size.width,
                    children: latestPosts),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: interestFeed,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FeedListView extends StatelessWidget {
  final double height, width;
  final List<Widget> children;

  const FeedListView(
      {Key? key,
      required this.height,
      required this.width,
      required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ListView(
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
