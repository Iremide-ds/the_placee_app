import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../screens/article_screen.dart';
import './post_card_widget.dart';

// import '../util/providers/auth_provider.dart';
import '../util/providers/db_provider.dart';
import '../constants/my_constants.dart';

//news feed
class UserHomePage extends StatefulWidget {
  final Function changeScreen;
  final Function exploreArticle;

  const UserHomePage(
      {Key? key, required this.changeScreen, required this.exploreArticle})
      : super(key: key);

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
    await Provider.of<DBProvider>(context, listen: false)
        .getUserDetails(context)
        .then((result) {
      setState(() {
        _userDetails = result;
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
    if (_userDetails != null && _userDetails!.isEmpty) {
      if (kDebugMode) {
        print('no user details!!!');
      }
      await FirebaseFirestore.instance
          .collection('topics')
          .limit(5)
          .get()
          .then((result) {
        for (int i = 0; i < result.docs.length; i++) {
          if (kDebugMode) {
            print('interest - ${result.docs[i].data()['name']}');
          }
          setState(() {
            _userInterests[result.docs[i].data()['id']] =
                result.docs[i].data()['name'];
          });
        }
      });
      return;
    }

    _userInterests.clear();
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
    hotTopics.add(SizedBox(width: MediaQuery.of(context).size.width * 0.045));
    hotTopics.addAll(totalPosts.map((doc) {
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
  }

  void _buildLatestStory(List totalPosts) {
    latestPosts.clear();
    int totalPostsCount = totalPosts.length;

    latestPosts.addAll(totalPosts
        .getRange(0, (totalPostsCount >= 5) ? 4 : totalPostsCount - 1)
        .map((doc) {
      return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.045,
            vertical: MediaQuery.of(context).size.height * 0.03,
          ),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                ArticleScreen.routeName,
                arguments: {'post': doc, 'function': widget.changeScreen}),
            child: Card(
              elevation: 1.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: MyBorderRadius.borderRadius),
              child: SizedBox(
                // height: height,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: MyBorderRadius.borderRadius,
                        color: Colors.transparent,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            doc['image_url'],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: MyBorderRadius.borderRadius,
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
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 12.0),
                          child: Text(
                            doc['title'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.016,
                            right: MediaQuery.of(context).size.width * 0.06),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () =>
                                widget.exploreArticle(doc['title']),
                            icon: const Icon(
                              Icons.explore,
                              color: Color(0xff1E4B6C),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
    }).toList());
  }

  void _buildUserInterests(List totalPosts) {
    interestFeed.clear();
    final Size size = MediaQuery.of(context).size;

    if (_userDetails != null &&
        _userDetails!.isNotEmpty &&
        _userDetails!.containsKey('interests')) {
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
    } else {
      print(_userInterests.values);
      for (MapEntry i in _userInterests.entries) {
        List tempCon = totalPosts.where((element) {
          Map? temp = element.data() as Map?;
          return temp?['topic'].toString() == i.key.toString();
        }).toList();
        print('${i.value.toString()} -- ${tempCon.length}');
        if (tempCon.isNotEmpty) {
          interestAndPosts[i.value.toString()] = tempCon;
        }
        if (interestAndPosts.length == 5) {
          break;
        }
      }
    }

    for (MapEntry<String, List> i in interestAndPosts.entries) {
      final List<Widget> temp1 = [
        SizedBox(width: MediaQuery.of(context).size.width * 0.045)
      ];
      String topicString = i.key;
      //ensure first char is in uppercase
      topicString = topicString.replaceFirst(topicString.characters.first,
          topicString.characters.first.toUpperCase());
      temp1.addAll(i.value.map(
        (doc) => PostCard(
          width: size.width * 0.4,
          // height: size.height * 0.2,
          title: doc['title'],
          borderRadius: MyBorderRadius.borderRadius,
          imageUrl: doc['image_url'],
          post: doc,
          changeScreen: widget.changeScreen,
        ),
      ) /*.toList()*/);

      Widget feed = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.045),
            child: Text(
              topicString,
              style: const TextStyle(
                color: Color(0xff1E4B6C),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: size.width,
            height: size.height * 0.145,
            child: FeedListView(
                controller: ScrollController(),
                height: size.height * 0.14,
                width: size.width,
                children: temp1),
          ),
        ],
      );
      interestFeed.add(feed);
      print('.................1\n');
    }
    print('.................\n');
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
                print('check 1');
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null) {
                print('check 2');
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data?.docs == null) {
                print('check 3');
                return const Center(child: CircularProgressIndicator());
              }

              final List<QueryDocumentSnapshot<Object?>> totalPosts =
                  snapshot.data!.docs;

              _buildHotTopics(totalPosts);
              _buildLatestStory(totalPosts);
              _buildUserInterests(totalPosts);

              print('........\n');

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
                          0.0, size.height * 0.021, 0.0, 0.0),
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
                              controller:
                                  ScrollController(initialScrollOffset: 2),
                              height: size.height * 0.15,
                              width: size.width,
                              children: hotTopics),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.34,
                      width: size.width,
                      child: PageView(
                        padEnds: false,
                        controller: PageController(),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: latestPosts,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
