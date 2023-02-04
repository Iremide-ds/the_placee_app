import 'package:flutter/material.dart';

enum Genders { Male, Female, Transgender, Binary, Human }

enum Interests {
  Food,
  Anime,
  Sports,
  Gaming,
  Outdoor,
  School,
  Hobbies,
  Music,
  Advice,
  Tech,
  News,
  Art,
  Design,
}

class AvatarImages {
  static const String avatar_1 = 'assets/avatars/avatar_1.svg';
  static const String avatar_2 = 'assets/avatars/avatar_2.svg';
  static const String avatar_3 = 'assets/avatars/avatar_3.svg';
  static const String avatar_4 = 'assets/avatars/avatar_4.svg';
  static const String avatar_5 = 'assets/avatars/avatar_5.svg';
  static const String avatar_6 = 'assets/avatars/avatar_6.svg';
  static const String avatar_7 = 'assets/avatars/avatar_7.svg';
  static const String avatar_8 = 'assets/avatars/avatar_8.svg';
  static const String avatar_9 = 'assets/avatars/avatar_9.svg';
  static const String avatar_10 = 'assets/avatars/avatar_10.svg';
  static const List<String> allAvatars = [
    avatar_1,
    avatar_2,
    avatar_3,
    avatar_4,
    avatar_5,
    avatar_6,
    avatar_7,
    avatar_8,
    avatar_9,
    avatar_10,
  ];
}


class MyBorderRadius {
  static const double radius = 20.0;
  static const borderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(radius),
    topLeft: Radius.circular(radius),
    topRight: Radius.circular(radius),
  );
}

class MyAnimationAttributes {
  static const curve = Curves.easeIn;
}