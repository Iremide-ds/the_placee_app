import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import '../widgets/my_search_bar.dart';
//todo: under construction...
class UserProfileScreen extends StatefulWidget {
  static const String routeName = '/user_profile';

  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _searchArticle() {}

  PreferredSizeWidget _buildAppBar(
      double avatarHeight, double searchBarHeight, double searchBarWidth) {
    return AppBar(
      scrolledUnderElevation: 0.8,
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
          'assets/icons/back_button.svg',
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
              child: const Icon(
                Icons.settings,
                color: Color(0xff1E4B6C),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _toggleLoading();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: _buildAppBar(
          size.height * 0.036, size.height * 0.049, size.width * 0.599),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xff1E4B6C)),
            )
          : SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(size.width, size.height * 0.067),
                        backgroundColor: const Color(0xff1E4B6C),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {},
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.exit_to_app_rounded,
                                color: Colors.white),
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
            ),
    );
  }
}
