// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final double height;
  final double width;
  final Function searchFunction;
  final TextEditingController searchController;

  const MySearchBar({super.key, required this.height, required this.width, required this.searchFunction, required this.searchController,});

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => searchFunction(searchController.text),
        ),
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: (text) => searchFunction(text),
      onSubmitted: (text) => searchFunction(text),
      textAlign: TextAlign.left,
      autocorrect: true,
      textInputAction: TextInputAction.search,
    );
  }
}
