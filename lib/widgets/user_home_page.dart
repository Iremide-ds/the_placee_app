import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import './post_card_widget.dart';
import '../util/providers/auth_provider.dart';
import '../constants/my_constants.dart';

//news feed
class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final Map _userInterests = {};
  final List<Widget> hotTopics = [];
  final List<Widget> latestPosts = [];
  final Map<String, List> interestAndPosts = {};
  final List<Widget> interestFeed = [];
  Map? _userDetails;
  bool _isLoading = true;

  Future<void> _getCurrentUserDetails() async {
    var currentUserGoogle =
        Provider.of<AuthProvider>(context, listen: false).getCurrentUser;
    var currentUserEmail = Provider.of<AuthProvider>(context, listen: false)
        .getCurrentUserLoggedInWithEmail;

    await FirebaseFirestore.instance
        .collection('user_details')
        .where('email',
            isEqualTo: currentUserGoogle?.email ?? currentUserEmail?.email)
        .limit(1)
        .get()
        .then((result) {
      setState(() {
        _userDetails = result.docs.first.data();
      });
    });
  }

  Future<void> _fetchInterest() async {
    if (_userDetails == null) {
      if (kDebugMode) {
        print('no user details');
      }
      return;
    }
    for (String id in _userDetails!['interests']) {
      await FirebaseFirestore.instance
          .collection('topics')
          .where(
            'id',
            isEqualTo: int.parse(id),
          )
          .limit(1)
          .get()
          .then((result) {
        if (kDebugMode) {
          print('interest - ${result.docs.first.data()['name']}');
        }
        setState(() {
          _userInterests[id.toString()] = result.docs.first.data()['name'];
        });
      });
    }
  }

  void _buildHotTopics(List totalPosts) {
    hotTopics.clear();
    hotTopics.addAll(totalPosts.map((doc) {
      return PostCard(
          width: MediaQuery.of(context).size.width * 0.4,
          // height: MediaQuery.of(context).size.height * 0.2,
          title: doc['title'],
          borderRadius: MyBorderRadius.borderRadius,
          imageUrl: doc['image_url']);
    }).toList());
  }

  void _buildLatestStory(List totalPosts) {
    latestPosts.clear();
    int totalPostsCount = totalPosts.length;

    latestPosts.addAll(totalPosts
        .getRange(0, (totalPostsCount >= 5) ? 4 : totalPostsCount - 1)
        .map((doc) {
      return PostCard(
        width: MediaQuery.of(context).size.width * 0.8,
        // height: MediaQuery.of(context).size.height * 0.5,
        title: doc['title'],
        borderRadius: MyBorderRadius.borderRadius,
        imageUrl: doc['image_url'],
      );
    }).toList());
  }

  void _buildUserInterests(List totalPosts) {
    interestFeed.clear();
    Size size = MediaQuery.of(context).size;

    for (var i in _userDetails!['interests']) {
      List tempCon = totalPosts.where((element) {
        Map? temp = element.data() as Map?;
        return temp?['topic'].toString() == i.toString();
      }).toList();
      if (tempCon.isNotEmpty) {
        interestAndPosts[_userInterests[i.toString()]] = tempCon;
      }
      if (interestAndPosts.length == 5) {
        break;
      }
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
                            // height: size.height * 0.2,
                            title: doc['title'],
                            borderRadius: MyBorderRadius.borderRadius,
                            imageUrl: doc['image_url']))
                        .toList()),
              ),
            ],
          ),
        ],
      );
      interestFeed.add(feed);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserDetails().then((result) {
      return _fetchInterest();
    }).then((value) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((_, err) {
      if (kDebugMode) {
        print(err);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
            .animate()
            .fadeIn(curve: MyAnimationAttributes.curve)
        : StreamBuilder<QuerySnapshot>(
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
              _buildLatestStory(totalPosts);
              _buildUserInterests(totalPosts);

              if (kDebugMode) {
                print('debugging - ${interestAndPosts.length}');
                print('debugging1 - ${_userInterests.length}');
              }

              if (hotTopics.isEmpty ||
                  latestPosts.isEmpty ||
                  interestAndPosts.isEmpty) {
                if (kDebugMode) {
                  print('no data!!!!');
                }
                return const Center(child: CircularProgressIndicator());
              }

              return SizedBox(
                height: size.height,
                width: size.width,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          size.width * 0.045, size.height * 0.03, 0.0, size.height * 0.03),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Top Stories',
                            style: TextStyle(
                              color: Color(0xff1E4B6C),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.006,
                          ),
                          FeedListView(
                              height: size.height * 0.15,
                              width: size.width,
                              children: hotTopics),
                        ],
                      ),
                    ),
                    FeedListView(
                      //todo: change this to a page view widget
                        height: size.height * 0.3,
                        width: size.width,
                        children: latestPosts),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: interestFeed,
                    ),
                  ],
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
