import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/my_search_bar.dart';
import '../widgets/auth_gate_widget.dart';
import '../widgets/user_home_page.dart';
import '../widgets//user_explore_page.dart';
import '../screens/sign_up_form_screen.dart';

//google sign in object
final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

//landing page / root
class AppLandingPage extends StatefulWidget {
  const AppLandingPage({Key? key}) : super(key: key);

  @override
  State<AppLandingPage> createState() => _AppLandingPageState();
}

class _AppLandingPageState extends State<AppLandingPage> {
  final List<Widget> _homeOrExplore = const [UserHomePage(), UserExplorePage()];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleSignInAccount? _currentUser;
  OAuthCredential? _credential;
  int _index = 0;

  void _searchArticle() {}

  Future<void> _continueWithGoogle() async {
    try {
      await _googleSignIn.signIn().then((account) async {
        if (_currentUser != null) {
          final GoogleSignInAuthentication googleAuth =
              await _currentUser!.authentication;
          _setCurrentUser(account);
          setState(() {
            _credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
          });
        }
      });
      if (_credential != null) {
        FirebaseAuth.instance.signInWithCredential(_credential!);
      } else {
        log(
          'No credentials',
          name: 'AppLandingPage()._continueWithGoogle() attempt firebase login',
        );
      }
    } catch (error) {
      log(
        error.toString(),
        name: 'AppLandingPage()._continueWithGoogle()',
        time: DateTime.now(),
      );
    }
  }

  void _continueWithEmail() {
    Navigator.of(context).pushNamed(SignUpForm.routeName);
  }

  void _setCurrentUser(GoogleSignInAccount? account) {
    setState(() {
      _currentUser = account;
    });
  }

  void _signOut() {
    FirebaseAuth.instance.signOut();
  }

  Widget _buildDrawer() {
    if (_currentUser == null) return const Drawer();

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Text(
                  _currentUser?.displayName ?? _currentUser?.email as String,
                ),
                TextButton(
                  onPressed: () => _signOut(),
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      double avatarHeight, double searchBarHeight, double searchBarWidth) {
    return AppBar(
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
          _scaffoldKey.currentState?.openDrawer();
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
              child: SvgPicture.asset(
                'assets/icons/brown_avatar.svg',
                fit: BoxFit.contain,
                semanticsLabel: 'your profile',
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _changeScreen(int index) {
    if (index != _index) {
      setState(() {
        _index = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //listener for when user switch account
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _setCurrentUser(account);
      if (_currentUser != null) {
        log(_currentUser!.email,
            name: '_googleSignIn.onCurrentUserChanged.listen()');
      }
    });

    //automatic google sign in
    _googleSignIn.signIn().then((user) {
      _setCurrentUser(user);
      if (_currentUser != null) {
        log('_continueWithGoogle() called',
            name: 'initState()._googleSignIn.signInSilently()');
        _continueWithGoogle();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            log(snapshot.data!.email!, name: 'FirebaseAuth.snapshot');
          }

          return snapshot.hasData
              ? Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: Colors.white,
                  appBar: _buildAppBar(size.height * 0.036, size.height * 0.049,
                      size.width * 0.599),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(29)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero),
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
                )
              : Scaffold(
                  body: AuthGate(
                    continueWithGoogle: _continueWithGoogle,
                    continueWithEmail: _continueWithEmail,
                  ),
                );
        });
  }

/*@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentUser != null) {
      if (mounted) {
        log(_currentUser!.email, name: 'didChangeDependencies', time: DateTime.now());
        Navigator.of(context).popAndPushNamed(UserHomePage.routeName);
      }
    }
  }*/
}
