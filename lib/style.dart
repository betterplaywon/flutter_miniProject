import 'package:flutter/material.dart';

var theme = ThemeData(

  appBarTheme: AppBarTheme(color: Colors.white,
    titleTextStyle: TextStyle(color: Colors.black),
    actionsIconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: TextTheme(
  bodyText2: TextStyle(color: Colors.red),
),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.red
  )
);