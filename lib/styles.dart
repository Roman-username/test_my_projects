import 'package:flutter/material.dart';

const Color kMainTextColor = Color(0xFF4F4F4F);
const TextStyle kSignInStepTitleStyle = TextStyle(
  fontSize: 34,
  fontWeight: FontWeight.w700,
  color: kMainTextColor,
  fontFamily: 'SF Pro Display',
);
const TextStyle kSignInStepSubTitleStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  color: kMainTextColor,
);

const Color kSignInPrimaryColor = Color(0xFFFFB800);

const kInputTheme = InputDecorationTheme(
  hintStyle: TextStyle(fontSize: 16, color: Color(0xFFC6C6C8)),
  filled: true,
  fillColor: Colors.white,
  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: Color(0xFFD9D9D9)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: kSignInPrimaryColor),
  ),
);

const kUnselectedItemColor = Color(0xFF7D7D7D);
const kSelectedItemColor = Color(0xFF0098EE);

const kScaffoldBackground = Color(0xFFF6F6F6);

class MyProjectIcons {
  MyProjectIcons._();

  static const String _fontFamily = 'MyProjectIcons';

  static const IconData account = IconData(0xe903, fontFamily: _fontFamily);
  static const IconData projects = IconData(0xe900, fontFamily: _fontFamily);
}

const kAppBarTheme = AppBarTheme(
  titleTextStyle: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: Color(0xFF4D4D4D),
  ),
  backgroundColor: kScaffoldBackground,
  centerTitle: true,
);
