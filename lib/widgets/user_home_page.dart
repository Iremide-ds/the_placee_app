import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//news feed
class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  List<Widget>? _getPosts(AsyncSnapshot<QuerySnapshot> snapshot) {
    print(snapshot.data?.size);
    return snapshot.data?.docs.map((doc) {
      print(doc);
      return ListTile(
        title: Text(doc["title"]),
        subtitle: Text(
          doc["author"].toString(),
        ),
        leading: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.height * 0.4,
            child: Image.network(doc["image_url"])),
      );
    }).toList();
  }

  Widget _buildTopStories() {
    return const CircularProgressIndicator();
  }

  Widget _buildLatestStory() {
    return const CircularProgressIndicator();
  }

  List<Widget> _buildUserInterests() {
    //build user's top 5 interests
    return [
      const CircularProgressIndicator(),
      const CircularProgressIndicator()
    ];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          return SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...?_getPosts(snapshot),
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
        });
  }
}
