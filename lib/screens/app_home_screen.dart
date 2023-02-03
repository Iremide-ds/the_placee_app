import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../widgets/auth_gate_widget.dart';
import '../widgets/news_feed_page.dart';
import '../util/providers/auth_provider.dart';

//landing page / root
class AppLandingPage extends StatefulWidget {
  const AppLandingPage({Key? key}) : super(key: key);

  @override
  State<AppLandingPage> createState() => _AppLandingPageState();
}

class _AppLandingPageState extends State<AppLandingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    //listener for when user switch account
    Provider.of<AuthProvider>(context, listen: false)
        .googleSignIn
        .onCurrentUserChanged
        .listen((GoogleSignInAccount? account) {
      Provider.of<AuthProvider>(context, listen: false).setCurrentUser(account);
      if (Provider.of<AuthProvider>(context, listen: false).getCurrentUser !=
          null) {
        log(
            Provider.of<AuthProvider>(context, listen: false)
                .getCurrentUser!
                .email,
            name: 'googleSignIn.onCurrentUserChanged.listen()');
      }
    });

    //automatic google sign in
    Provider.of<AuthProvider>(context, listen: false)
        .googleSignIn
        .signIn()
        .then((user) {
      Provider.of<AuthProvider>(context, listen: false).setCurrentUser(user);
      if (Provider.of<AuthProvider>(context, listen: false)
          .getCurrentUser != null) {
        log('continueWithGoogle() called',
            name: 'initState().googleSignIn.signInSilently()');
        Provider.of<AuthProvider>(context, listen: false).continueWithGoogle();
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

          return Provider.of<AuthProvider>(context).isUserSignedIn
              ? NewsFeedWidget(scaffoldKey: _scaffoldKey)
              : const Scaffold(
                  body: AuthGate(),
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
