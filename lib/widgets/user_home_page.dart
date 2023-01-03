import 'package:flutter/material.dart';

//news feed
class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Widget _buildTopStories() {
    return const CircularProgressIndicator();
  }

  Widget _buildLatestStory() {
    return const CircularProgressIndicator();
  }

  List<Widget> _buildUserInterests() {
    //build user's top 5 interests
    return [const CircularProgressIndicator(), const CircularProgressIndicator()];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopStories(),
              _buildLatestStory(),
              ..._buildUserInterests(),
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'Loading...',
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}
