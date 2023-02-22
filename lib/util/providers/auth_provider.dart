import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import '../dynamic_links.dart';

class AuthProvider with ChangeNotifier {
  //google sign in object
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  GoogleSignInAccount? _currentUser;
  User? _currentUserEmail;
  OAuthCredential? _credential;

  GoogleSignInAccount? get getCurrentUser {
    return _currentUser;
  }

  User? get getCurrentUserLoggedInWithEmail {
    return _currentUserEmail;
  }

  OAuthCredential? get getCurrentUserCredential {
    return _credential;
  }

  bool get isUserSignedIn {
    _currentUserEmail = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      return true;
    } else if (_currentUserEmail != null) {
      return true;
    } else {
      return false;
    }
  }

  void setCurrentUser(GoogleSignInAccount? newUser) {
    _currentUser = newUser;
    notifyListeners();
  }

  Future<void> continueWithGoogle() async {
    //generate dynamic link
    /*DynamicLinksProvider().createLink().then((value) {
      if (kDebugMode) {
        print('\n $value \n');
      }
    }).catchError((err) {if (kDebugMode) {
      print(err);
    }});*/
    try {
      await googleSignIn.signIn().then((account) async {
        setCurrentUser(account);
        if (_currentUser != null) {
          final GoogleSignInAuthentication googleAuth =
              await _currentUser!.authentication;
          _credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
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
    if (kDebugMode) {
      print('Continue with google');
    }
    notifyListeners();
  }

  void continueWithEmail(Map<String, dynamic> args) {
    final BuildContext context = args['context'];
    final String route = args['route'];

    log(
      'continue with email',
      name: 'AuthProvider()._continueWithEmail()',
      time: DateTime.now(),
    );
    Navigator.of(context).pushReplacementNamed(route);
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    _currentUser = null;
    _currentUserEmail = null;
    notifyListeners();
  }

  get getUserDetails {}
}
