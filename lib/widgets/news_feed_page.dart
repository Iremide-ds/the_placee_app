import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';

import '../util/providers/auth_provider.dart';
import '../util/providers/db_provider.dart';
import '../widgets/user_home_page.dart';
import '../widgets/user_explore_page.dart';
import '../widgets/my_search_bar.dart';
import '../screens/user_profile_screen.dart';
import '../screens/article_screen.dart';
import '../screens/feedback_and_help_screen.dart';
import '../constants/my_constants.dart';
import '../util/dynamic_links.dart';

class NewsFeedWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NewsFeedWidget({required this.scaffoldKey, Key? key}) : super(key: key);

  @override
  State<NewsFeedWidget> createState() => _NewsFeedWidgetState();
}

class _NewsFeedWidgetState extends State<NewsFeedWidget> {
  final TextEditingController _searchController = TextEditingController();
  final List<Widget> _searchResult = [];
  PageController? _controller;
  int _index = 0;

  // final double _screenPad = 16.0;

  void _searchArticles(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    List<QueryDocumentSnapshot<Object?>> allPosts =
        await Provider.of<DBProvider>(context, listen: false)
            .getAllPosts(false);

    for (var post in allPosts) {
      if (post.get('title').contains(text)) {
        _searchResult.add(SearchResultWidget(post: post, changeScreen: _changeScreen,));
      }
    }
    setState(() {});
  }

  void _changeScreen(int index) {
    if (index != _index) {
      _controller?.animateToPage(index,
          duration: const Duration(milliseconds: 290),
          curve: Curves.fastOutSlowIn);
    }
  }

  void _exploreLatestStory(String title) {
    _searchController.text = title;
    _controller?.animateToPage(1,
        duration: const Duration(milliseconds: 290),
        curve: Curves.fastOutSlowIn);
    _searchArticles(title);
  }

  PreferredSizeWidget _buildAppBar(
      double avatarHeight, double searchBarHeight, double searchBarWidth) {
    GoogleSignInAccount? currentUser =
        Provider.of<AuthProvider>(context, listen: true).getCurrentUser;
    User? currentUserWithEmailLogin =
        Provider.of<AuthProvider>(context, listen: true)
            .getCurrentUserLoggedInWithEmail;

    var photoURL = currentUserWithEmailLogin?.photoURL ?? currentUser?.photoUrl;

    return AppBar(
      scrolledUnderElevation: 0.8,
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Visibility(
        visible: (_index == 1),
        child: Center(
          child: RepaintBoundary(
            child: MySearchBar(
              searchController: _searchController,
              height: searchBarHeight,
              width: searchBarWidth,
              searchFunction: _searchArticles,
            ).animate().fadeIn(),
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () {
          widget.scaffoldKey.currentState?.openDrawer();
        },
        icon: SvgPicture.asset(
          'assets/icons/drawer_icon.svg',
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        Hero(
          tag: HeroTags.profilePic,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(UserProfileScreen.routeName);
            },
            icon: CircleAvatar(
              /*radius: avatarRadius,*/
              backgroundColor: const Color(0xffEBEBEB),
              child: SizedBox(
                height: avatarHeight,
                child: Image.network(
                  photoURL ??
                      'https://firebasestorage.googleapis.com/v0/b/the-placee.appspot.com/o/avatars%2Fjpg%2Favatar_10.png?alt=media&token=3b2ac9f7-0c74-4024-9e60-5d3ccfd8832e',
                  errorBuilder: (ctx, error, stacktrace) {
                    return const Icon(Icons.person);
                  },
                  fit: BoxFit.contain,
                  semanticLabel: 'your profile',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    final Size size = MediaQuery.of(context).size;
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);

    GoogleSignInAccount? currentUser =
        Provider.of<AuthProvider>(context, listen: true).getCurrentUser;
    User? currentUserWithEmailLogin =
        Provider.of<AuthProvider>(context, listen: true)
            .getCurrentUserLoggedInWithEmail;

    final List<Map<String, dynamic>> drawerActions = [
      {
        'title': 'News Feed',
        'icon': Icons.feed_outlined,
        'onTap': () {
          _changeScreen(0);
          widget.scaffoldKey.currentState?.closeDrawer();
        }
      },
      {
        'title': 'Explore',
        'icon': Icons.explore_outlined,
        'onTap': () {
          _changeScreen(1);
          widget.scaffoldKey.currentState?.closeDrawer();
        }
      },
      {
        'title': 'Feedback & Help',
        'icon': Icons.feedback_outlined,
        'onTap': () {
          Navigator.of(context).pushNamed(FeedBackScreen.routeName);
        }
      },
    ];

    if (currentUser != null) {
      return Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.06),
              CircleAvatar(
                backgroundColor: const Color(0xffEBEBEB),
                maxRadius: MediaQuery.of(context).size.width * 0.22,
                child: Image.network(
                  currentUser.photoUrl ??
                      'https://firebasestorage.googleapis.com/v0/b/the-placee.appspot.com/o/avatars%2Fjpg%2Favatar_10.png?alt=media&token=3b2ac9f7-0c74-4024-9e60-5d3ccfd8832e',
                  errorBuilder: (ctx, error, stacktrace) {
                    return const Icon(Icons.person);
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                currentUser.displayName ?? currentUser.email,
                style: TextStyle(
                  color: const Color(0xff1E4B6C),
                  fontSize: 20 * MediaQuery.textScaleFactorOf(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  color: Colors.white,
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: drawerActions.map((dashboardAction) {
                      return ListTile(
                        onTap: dashboardAction['onTap'],
                        title: Text(dashboardAction['title']),
                        leading: Icon(dashboardAction['icon']),
                      );
                    }).toList(),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Uri dynamicLink = await DynamicLinksProvider().createLink();
                  Share.share(dynamicLink.toString(), subject: 'Check out the placee!');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.share),
                    SizedBox(width: size.width * 0.03),
                    Text(
                      'Share with a friend',
                      style: TextStyle(
                        color: const Color(0xff1E4B6C),
                        fontSize: 20 * textScaleFactor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (currentUserWithEmailLogin != null) {
      return Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.06),
              CircleAvatar(
                backgroundColor: const Color(0xffEBEBEB),
                maxRadius: MediaQuery.of(context).size.width * 0.22,
                child: Image.network(
                  currentUserWithEmailLogin.photoURL ??
                      'https://firebasestorage.googleapis.com/v0/b/the-placee.appspot.com/o/avatars%2Fjpg%2Favatar_10.png?alt=media&token=3b2ac9f7-0c74-4024-9e60-5d3ccfd8832e',
                  errorBuilder: (ctx, error, stacktrace) {
                    return const Icon(Icons.person);
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                currentUserWithEmailLogin.displayName ??
                    currentUserWithEmailLogin.email as String,
                style: TextStyle(
                  color: const Color(0xff1E4B6C),
                  fontSize: 20 * textScaleFactor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  color: Colors.white,
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: drawerActions.map((dashboardAction) {
                      return ListTile(
                        onTap: dashboardAction['onTap'],
                        title: Text(dashboardAction['title']),
                        leading: Icon(dashboardAction['icon']),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () async {
                    Uri dynamicLink = await DynamicLinksProvider().createLink();
                    Share.share(dynamicLink.toString(), subject: 'Check out the placee!');
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.share),
                      Text(
                        'Share with a friend',
                        style: TextStyle(
                          color: const Color(0xff1E4B6C),
                          fontSize: 20 * textScaleFactor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Drawer();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: _index,
      // viewportFraction: (1 + (_screenPad * 2 / widget.screenWidth)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(
          size.height * 0.036, size.height * 0.049, size.width * 0.599),
      drawer: _buildDrawer(),
      body: PageView(
          padEnds: false,
          controller: _controller,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (int page) {
            setState(() {
              _index = page;
            });
          },
          children: [
            UserHomePage(
                changeScreen: _changeScreen,
                exploreArticle: _exploreLatestStory),
            UserExplorePage(
                searchResults: _searchResult, changeScreen: _changeScreen)
          ]),
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(bottom: size.height * 0.02),
        height: size.height * 0.08,
        width: size.width * 0.5,
        child: Center(
          child: Card(
            color: Colors.white,
            elevation: 2.3,
            surfaceTintColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () => _changeScreen(0),
                  icon: Icon(
                    Icons.home_filled,
                    color: (_index == 0)
                        ? const Color(0xff1E4B6C)
                        : const Color(0xffAEAEAE),
                  ),
                ),
                SizedBox(width: size.width * 0.05),
                IconButton(
                  onPressed: () => _changeScreen(1),
                  icon: Icon(
                    Icons.explore,
                    color: (_index == 1)
                        ? const Color(0xff1E4B6C)
                        : const Color(0xffAEAEAE),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchResultWidget extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> post;
  final Function changeScreen;

  const SearchResultWidget({Key? key, required this.post, required this.changeScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: Text(post['date'].toDate().toString()),
      title: Text(post['title']),
      subtitle: Text(post['author'].toString()),
      onTap: () {
        Navigator.of(context).pushNamed(ArticleScreen.routeName,
            arguments: {'post': post, 'function': changeScreen});
      },
    ); /*SizedBox(
      child: Text(post['title']),
    );*/
  }
}
