import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/logo_icon_widget.dart';
import '../widgets/blurred_button_widget.dart';
import '../screens/sign_in_form_screen.dart';

class AuthGate extends StatelessWidget {
  final Function continueWithGoogle;
  final Function continueWithEmail;

  const AuthGate({
    Key? key,
    required this.continueWithGoogle,
    required this.continueWithEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    const TextStyle plainTextButton =
        TextStyle(color: Colors.white, fontSize: 16);

    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/bg/Rectangle_1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: size.height * 0.155),
            color: Colors.transparent,
            height: size.height * 0.22,
            width: size.width,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ThePlaceeIcon(),
                  SizedBox(
                    height: size.height * 0.022,
                  ),
                  SizedBox(
                    width: size.width * 0.4,
                    child: Text(
                      'Let\'s get you started',
                      style: theme.primaryTextTheme.labelLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.37,
          ),
          Center(
            child: BlurredBgButton(
              onTap: continueWithGoogle,
              height: size.height * 0.06,
              width: size.width * 0.7,
              iconWidget: SvgPicture.asset(
                'assets/icons/google_icon.svg',
                semanticsLabel: 'Google',
              ),
              text: 'Continue with Google',
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Center(
            child: BlurredBgButton(
              onTap: continueWithEmail,
              height: size.height * 0.06,
              width: size.width * 0.7,
              iconWidget: const Icon(
                Icons.mail,
                semanticLabel: 'Email',
                color: Colors.white,
              ),
              text: 'Continue with Email',
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.009),
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Already have an account?',
                  style: plainTextButton,
                ),
                SizedBox(
                  width: size.width * 0.135,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(SignInForm.routeName),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'Login',
                      style: plainTextButton,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
