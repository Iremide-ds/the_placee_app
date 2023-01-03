import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import './themes/light_theme.dart';
import './screens/app_home_screen.dart';
import './screens/sign_up_form_screen.dart';
import './screens/sign_in_form_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Placee',
      theme: AppLightTheme().themeData,
      routes: {
        '/': (_) => const AppLandingPage(),
        SignUpForm.routeName: (_) => const SignUpForm(),
        SignInForm.routeName: (_) => const SignInForm(),
      },
      themeAnimationCurve: Curves.easeIn,
    );
  }
}
