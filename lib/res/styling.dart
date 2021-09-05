import 'package:flutter/material.dart';
import 'package:kasir_mri/res/size_config.dart';

class AppTheme {
  AppTheme._();

  static const Color appBackgroundColor = Color(0xFFFFFFFF);
  static const Color topBarBackgroundColor = Color(0xCCFFC107);
  static const Color selectedTabBackgroundColor = Color(0xFFFFC107);
  static const Color unSelectedTabBackgroundColor = Color(0xFFFFFFFC);
  static const Color subTitleTextColor = Color(0xFF9F988F);
  static const Color hintTextColor = Color(0xFFBB9B9B9);
  static const Color redBackgroundColor = Color(0xDCFF0000);
  static const Color blueBackgroundColor = Color(0xff0036ff);

  static final ThemeData lightTheme = ThemeData(
    fontFamily: "Nunito",
    scaffoldBackgroundColor: AppTheme.appBackgroundColor,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
  );

  static final TextStyle titleLight = TextStyle(
    color: Colors.black,
    fontFamily: "Nunito",
    fontSize: 3.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle _subTitleLight = TextStyle(
    color: subTitleTextColor,
    fontSize: 2 * SizeConfig.textMultiplier,
    height: 1.5,
  );

  static final TextStyle _buttonLight = TextStyle(
    color: Colors.black,
    fontSize: 2.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle _greetingLight = TextStyle(
    color: Colors.black,
    fontSize: 2.0 * SizeConfig.textMultiplier,
  );

  static final TextStyle _searchLight = TextStyle(
    color: Colors.black,
    fontSize: 2.3 * SizeConfig.textMultiplier,
  );

  static final TextStyle _selectedTabLight = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle _unSelectedTabLight = TextStyle(
    color: Colors.grey,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle titleDark = titleLight.copyWith(color: Colors.white);

  static final TextStyle _subTitleDark =
      _subTitleLight.copyWith(color: Colors.white70);

  static final TextStyle _buttonDark =
      _buttonLight.copyWith(color: Colors.black);

  static final TextStyle _greetingDark =
      _greetingLight.copyWith(color: Colors.black);

  static final TextStyle _searchDark =
      _searchDark.copyWith(color: Colors.black);

  static final TextStyle _selectedTabDark =
      _selectedTabDark.copyWith(color: Colors.white);

  static final TextStyle _unSelectedTabDark =
      _selectedTabDark.copyWith(color: Colors.white70);
}
