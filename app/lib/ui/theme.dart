import 'package:flutter/material.dart';

class ThemeUtils {
  ThemeUtils._();

  static ThemeData get _baseDark => ThemeData(
        brightness: Brightness.dark,
      );

  static ThemeData get _baseLight => ThemeData(
        brightness: Brightness.light,
      );

  static Color get sepiaColor => Color.fromRGBO(239, 232, 211, 1);

  static ThemeData get light => _baseLight.copyWith(
        brightness: Brightness.light,
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              brightness: Brightness.dark,
              color: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              textTheme: _baseLight.textTheme.copyWith(
                title: _baseLight.textTheme.title.copyWith(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
              elevation: 1.0,
            ),
        bottomAppBarTheme:
            BottomAppBarTheme(color: ThemeData.light().scaffoldBackgroundColor),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
        ),
        primaryColor: Colors.black,
        accentColor: Colors.red,
      );

  static ThemeData get lightThemeSepia => _baseLight.copyWith(
        brightness: Brightness.light,
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              brightness: Brightness.dark,
              color: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              textTheme: _baseLight.textTheme.copyWith(
                title: _baseLight.textTheme.title.copyWith(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
              elevation: 1.0,
            ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
        ),
        scaffoldBackgroundColor: sepiaColor,
        primaryColor: Colors.black,
        accentColor: Colors.red,
      );

  static ThemeData get dark => _baseDark.copyWith(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: ThemeData.dark().accentColor,
        appBarTheme: ThemeData.dark().appBarTheme.copyWith(
              elevation: 1.0,
            ),
        textTheme: _baseDark.textTheme.copyWith(
          title: _baseDark.textTheme.title.copyWith(
            fontSize: 22,
          ),
        ),
        cardTheme: CardTheme(color: Colors.black, elevation: 0),
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.black),
        backgroundColor: Colors.black,
        bottomAppBarColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
      );
}
