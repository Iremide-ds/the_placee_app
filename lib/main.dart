import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:provider/provider.dart';

import './themes/light_theme.dart';
import './screens/app_home_screen.dart';
import './screens/sign_up_form_screen.dart';
import './screens/sign_in_form_screen.dart';
import './screens/spalsh_screen.dart';
import './screens/user_profile_screen.dart';
import './util/providers/auth_provider.dart';

PendingDynamicLinkData? initialLink;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    if (initialLink != null) {
      if (kDebugMode) {
        print(initialLink?.link);
      }
    }

    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The Placee',
        theme: AppTheme.lightThemeData,
        initialRoute: MySplashScreen.routeName,
        routes: {
          '/': (_) => const AppLandingPage(),
          SignUpForm.routeName: (_) => const SignUpForm(),
          SignInForm.routeName: (_) => const SignInForm(),
          MySplashScreen.routeName: (_) => const MySplashScreen(),
          UserProfileScreen.routeName: (_) => const UserProfileScreen(),
        },
        themeAnimationCurve: Curves.easeIn,
      ),
    );
  }
}
