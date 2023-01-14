import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/auth_gate_widget.dart';
import '../widgets/news_feed_page.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleSignInAccount? _currentUser;
  OAuthCredential? _credential;

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
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            log(snapshot.data!.email!, name: 'FirebaseAuth.snapshot');
          }

          return snapshot.hasData
              ? NewsFeedWidget(
                  currentUser: _currentUser!,
                  scaffoldKey: _scaffoldKey,
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
