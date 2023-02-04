import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../util/providers/auth_provider.dart';
import '../widgets/user_home_page.dart';
import '../widgets/user_explore_page.dart';
import '../widgets/my_search_bar.dart';

class NewsFeedWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NewsFeedWidget({required this.scaffoldKey, Key? key}) : super(key: key);

  @override
  State<NewsFeedWidget> createState() => _NewsFeedWidgetState();
}

class _NewsFeedWidgetState extends State<NewsFeedWidget> {
  final List<Widget> _homeOrExplore = const [UserHomePage(), UserExplorePage()];
  int _index = 0;

  void _searchArticle() {}

  void _changeScreen(int index) {
    if (index != _index) {
      setState(() {
        _index = index;
      });
    }
  }

  PreferredSizeWidget _buildAppBar(
      double avatarHeight, double searchBarHeight, double searchBarWidth) {
    GoogleSignInAccount? currentUser =
        Provider.of<AuthProvider>(context, listen: true).getCurrentUser;
    User? currentUserWithEmailLogin =
        Provider.of<AuthProvider>(context, listen: true)
            .getCurrentUserLoggedInWithEmail;
    return AppBar(
      scrolledUnderElevation: 0.0,
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Center(
          child: MySearchBar(
        height: searchBarHeight,
        width: searchBarWidth,
        searchFunction: _searchArticle,
      )),
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
        IconButton(
          onPressed: () {},
          icon: CircleAvatar(
            /*radius: avatarRadius,*/
            backgroundColor: const Color(0xffEBEBEB),
            child: SizedBox(
              height: avatarHeight,
              child: SvgPicture.network(
                placeholderBuilder: (ctx) {
                  return const CircularProgressIndicator();
                },
                currentUserWithEmailLogin?.photoURL ??
                    'https://firebasestorage.googleapis.com/v0/b/the-placee.appspot.com/o/avatars%2Favatar_5.svg?alt=media&token=f56ecf65-3504-4530-864a-db1b2f9353b9',
                fit: BoxFit.contain,
                semanticsLabel: 'your profile',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    GoogleSignInAccount? currentUser =
        Provider.of<AuthProvider>(context, listen: true).getCurrentUser;
    User? currentUserWithEmailLogin =
        Provider.of<AuthProvider>(context, listen: true)
            .getCurrentUserLoggedInWithEmail;

    if (currentUser != null) {
      return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Text(
                    currentUser.displayName ?? currentUser.email,
                  ),
                  TextButton(
                    onPressed: () =>
                        Provider.of<AuthProvider>(context, listen: false)
                            .signOut(),
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (currentUserWithEmailLogin != null) {
      return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Text(
                    currentUserWithEmailLogin.displayName ??
                        currentUserWithEmailLogin.email as String,
                  ),
                  TextButton(
                    onPressed: () =>
                        Provider.of<AuthProvider>(context, listen: false)
                            .signOut(),
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const Drawer();
    }
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
      body: _homeOrExplore[_index],
      bottomNavigationBar: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(bottom: size.height * 0.02),
        height: size.height * 0.08,
        width: size.width * 0.5,
        child: Center(
          child: Card(
            color: Colors.white,
            elevation: 2.3,
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
