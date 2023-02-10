import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../widgets/my_search_bar.dart';
import '../util/providers/auth_provider.dart';
import '../util/providers/db_provider.dart';

//todo: under construction...
class UserProfileScreen extends StatefulWidget {
  static const String routeName = '/user_profile';

  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> _userInterests = [];
  GoogleSignInAccount? currentUser;
  User? currentUserWithEmailLogin;

  bool _isLoading = true;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  double _fetchTextScale() {
    return MediaQuery.of(context).textScaleFactor;
  }

  void _fetchUser() {
    setState(() {
      currentUser =
          Provider.of<AuthProvider>(context, listen: false).getCurrentUser;
      currentUserWithEmailLogin =
          Provider.of<AuthProvider>(context, listen: false)
              .getCurrentUserLoggedInWithEmail;
    });
  }

  Future<void> _buildUserInterests() async {
    // print('building interests');
    Map<String, String> interests =
        await Provider.of<DBProvider>(context, listen: false)
            .getUserInterests(context);
    for (MapEntry<String, String> i in interests.entries) {
      // print(i.value);
      _userInterests.add(Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color(0xffEBEBEB),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          i.value.replaceFirst(
              i.value.characters.first, i.value.characters.first.toUpperCase()),
          style: TextStyle(
            color: const Color(0xff8C8D8D),
            fontSize: 14 * _fetchTextScale(),
            fontWeight: FontWeight.w500,
          ),
        ),
      ));
    }
  }

  PreferredSizeWidget _buildAppBar(
      double avatarHeight, double searchBarHeight, double searchBarWidth) {
    return AppBar(
      scrolledUnderElevation: 0.8,
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          'Your Profile',
          style: TextStyle(
            color: const Color(0xff1E4B6C),
            fontWeight: FontWeight.w600,
            fontSize: 16 * MediaQuery.textScaleFactorOf(context),
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: SvgPicture.asset(
          'assets/icons/back_button.svg',
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            //todo: show a dropdown that allows user to toggle dark mode
          },
          icon: SizedBox(
            height: avatarHeight,
            child: const Icon(
              Icons.settings,
              color: Color(0xff1E4B6C),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _buildUserInterests().then((_) => _toggleLoading());
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double textScaleFactor = _fetchTextScale();

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(
          size.height * 0.036, size.height * 0.049, size.width * 0.599),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xff1E4B6C)),
            )
          : Container(
              height: size.height,
              width: size.width,
              padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.028, horizontal: size.width * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xffEBEBEB),
                    minRadius: size.width * 0.3,
                    child: SvgPicture.network(
                      currentUser?.photoUrl ??
                          currentUserWithEmailLogin?.photoURL as String,
                      placeholderBuilder: (context) {
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CountAndLabel(count: '44', label: 'Interests'),
                      CountAndLabel(count: '4', label: 'Saved'),
                    ],
                  ),
                  Container(
                    width: size.width,
                    // height: size.height * 0.084,
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.009,
                        horizontal: size.width * 0.04),
                    decoration: const BoxDecoration(
                      color: Color(0xffEBEBEB),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(
                            color: const Color(0xff8C8D8D),
                            fontSize: 14 * textScaleFactor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: size.height * 0.004),
                        Text(
                          currentUser?.displayName ??
                              currentUserWithEmailLogin?.displayName as String,
                          style: TextStyle(
                            color: const Color(0xff1E4B6C),
                            fontSize: 20 * textScaleFactor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.016),
                  Container(
                    width: size.width,
                    // height: size.height * 0.084,
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.009,
                        horizontal: size.width * 0.04),
                    decoration: const BoxDecoration(
                      color: Color(0xffEBEBEB),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            color: const Color(0xff8C8D8D),
                            fontSize: 14 * textScaleFactor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: size.height * 0.004),
                        Text(
                          currentUser?.email ??
                              currentUserWithEmailLogin?.email as String,
                          style: TextStyle(
                            color: const Color(0xff1E4B6C),
                            fontSize: 20 * textScaleFactor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Interests',
                          style: TextStyle(
                            color: const Color(0xff1E4B6C),
                            fontSize: 20 * textScaleFactor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        SizedBox(
                          width: size.width,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceEvenly,
                            runAlignment: WrapAlignment.spaceEvenly,
                            children: _userInterests,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(size.width * 0.73, size.height * 0.067),
                        backgroundColor: const Color(0xff1E4B6C),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .signOut();
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.exit_to_app_rounded,
                                color: Colors.white),
                            SizedBox(width: size.width * 0.017),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16 * textScaleFactor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(curve: Curves.easeIn),
    );
  }
}

class CountAndLabel extends StatelessWidget {
  final String count;
  final String label;

  const CountAndLabel({Key? key, required this.count, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 64 * MediaQuery.of(context).textScaleFactor,
              color: const Color(0xff1E4B6C),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 16 * MediaQuery.of(context).textScaleFactor,
              color: const Color(0xff1E4B6C),
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
