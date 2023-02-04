import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../screens/sign_up_form_screen.dart';
import '../util/providers/auth_provider.dart';
import '../widgets/logo_icon_widget.dart';
import '../widgets/blurred_button_widget.dart';
import '../screens/sign_in_form_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

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
          RepaintBoundary(
            child: Container(
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
            ).animate().fadeIn(curve: Curves.easeIn),
          ),
          SizedBox(
            height: size.height * 0.37,
          ),
          Center(
            child: RepaintBoundary(
              child: BlurredBgButton(
                hasArgs: false,
                onTap: Provider.of<AuthProvider>(context, listen: false)
                    .continueWithGoogle,
                height: size.height * 0.06,
                width: size.width * 0.7,
                iconWidget: SvgPicture.asset(
                  'assets/icons/google_icon.svg',
                  semanticsLabel: 'Google',
                ),
                text: 'Continue with Google',
              ).animate().fadeIn(curve: Curves.easeInOut),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Center(
            child: RepaintBoundary(
              child: BlurredBgButton(
                hasArgs: true,
                onTap: Provider.of<AuthProvider>(context, listen: false)
                    .continueWithEmail,
                onTapArgs: {'context': context, 'route': SignUpForm.routeName},
                height: size.height * 0.06,
                width: size.width * 0.7,
                iconWidget: const Icon(
                  Icons.mail,
                  semanticLabel: 'Email',
                  color: Colors.white,
                ),
                text: 'Continue with Email',
              ).animate().fadeIn(curve: Curves.easeInOut),
            ),
          ),
          RepaintBoundary(
            child: Container(
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
            ).animate().fadeIn(curve: Curves.easeInOut),
          ),
        ],
      ),
    );
  }
}
