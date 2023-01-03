import 'package:flutter/material.dart';

class UserExplorePage extends StatefulWidget {
  const UserExplorePage({Key? key}) : super(key: key);

  @override
  State<UserExplorePage> createState() => _UserExplorePageState();
}

class _UserExplorePageState extends State<UserExplorePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: size.width,
      child: const Center(child: CircularProgressIndicator(),),
    );
  }
}
