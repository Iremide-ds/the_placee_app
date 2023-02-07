import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';

import './sign_up_form_screen.dart';
import '../widgets/form_header_widget.dart';

class SignInForm extends StatefulWidget {
  static const String routeName = '/sign_in_form_screen';

  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailOrNicknameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loggingIn = false;

  Future<bool> _logIn() async {
    setState(() {
      _loggingIn = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailOrNicknameController.text,
          password: _passwordController.text);
      return true;
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loggingIn = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
      return false;
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Container(
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.zero,
        child: IconButton(
          padding: EdgeInsets.zero,
          tooltip: 'Back to landing page',
          // iconSize: MediaQuery.of(context).size.height * 0.06,
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            'assets/icons/back_button.svg',
            fit: BoxFit.contain,
          ),
        ),
      ),
      leadingWidth: MediaQuery.of(context).size.width * 0.13,
    );
  }

  Widget _buildBody(BuildContext context, Size size) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RepaintBoundary(
            child: const MyFormHeader(
              header: 'Let’s get you signed in',
              description: 'Welcome back you have been missed',
            ).animate().slideX(curve: Curves.easeIn).then(),
          ),
          SizedBox(
            height: size.height * 0.44,
            width: size.width,
            child: RepaintBoundary(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.019),
                    child: TextFormField(
                      controller: _emailOrNicknameController,
                      decoration: InputDecoration(
                        labelText: 'Email, Nickname',
                        hintText: 'Email, Nickname',
                        hintStyle: const TextStyle(
                          color: Color(0xffB4B4B4),
                          fontSize: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff1E4B6C), width: 0.9),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff1E4B6C), width: 1.2),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        enabled: true,
                      ),
                      autocorrect: true,
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.019),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: Color(0xffB4B4B4),
                          fontSize: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff1E4B6C), width: 0.9),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff1E4B6C), width: 1.2),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        enabled: true,
                      ),
                      autocorrect: true,
                      obscureText: false,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () {},
                      child: const Text(
                        'Forgot password?',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xffB4B4B4)),
                      ),
                    ),
                  ),
                ],
              ).animate().slideX(curve: Curves.easeIn).then(),
            ),
          ),
          RepaintBoundary(
            child: Container(
              height: size.height * 0.022,
              width: size.width,
              margin: EdgeInsets.only(
                  top: size.height * 0.19, bottom: size.height * 0.035),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Color(0xffB4B4B4), fontSize: 16),
                    ),
                    SizedBox(
                      width: size.width * 0.139,
                      child: TextButton(
                        onPressed: () => Navigator.of(context)
                            .popAndPushNamed(SignUpForm.routeName),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Color(0xff1E4B6C),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().slideX(curve: Curves.easeIn),
          ),
          RepaintBoundary(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(size.width, size.height * 0.067),
                backgroundColor: const Color(0xff1E4B6C),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () {
                _logIn().then((value) {
                  if (value) {
                    Navigator.of(context).pop();
                  } else {
                    return;
                  }
                });
              },
              child: _loggingIn
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ).animate().fadeIn(curve: Curves.easeIn),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06, vertical: size.height * 0.01),
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
            child: _buildBody(context, MediaQuery.of(context).size),),
      ),
    );
  }
}
