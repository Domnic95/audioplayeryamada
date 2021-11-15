import 'package:audiobook/core/utils/config.dart';
import 'package:flutter/material.dart';

import 'appColors.dart';
import 'appSettings.dart';

class AppTheme {
  static final ThemeData defTheme = ThemeData(
    //visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: AppColor.kScaffoldColor,
    //primaryIconTheme: IconThemeData(color: Colors.white),
    fontFamily: kAppFont,
    //iconTheme: IconThemeData(color: Colors.white),
    // splashColor: Colors.transparent,
    // highlightColor: Colors.transparent,
    // dividerTheme: DividerThemeData(space: 0),

    appBarTheme: AppBarTheme(
      color: Colors.white,
      shadowColor: Colors.black38,
      brightness: Brightness.light,
      centerTitle: true,
    ),
    textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.black, fontSize: getWidth(12))),
  );
}
