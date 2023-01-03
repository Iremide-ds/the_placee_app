// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final double height;
  final double width;
  final VoidCallback searchFunction;

  const MySearchBar({super.key, required this.height, required this.width, required this.searchFunction,});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        enabled: true,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        constraints: BoxConstraints(
          maxHeight: height,
          maxWidth: width,
        ),
        fillColor: const Color(0xffF5F5F5),
        prefixIconColor: const Color(0xff9BA6AE),
        hintText: 'Search',
        hintStyle: const TextStyle(
          color: Color(0xff9BA6AE),
          fontSize: 14,
        ),
        prefixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => searchFunction,
        ),
        contentPadding: EdgeInsets.zero,
      ),
      textAlign: TextAlign.left,
      autocorrect: true,
      textInputAction: TextInputAction.search,
    );
  }
}
