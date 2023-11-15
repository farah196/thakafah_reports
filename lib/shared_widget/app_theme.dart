import 'package:flutter/material.dart';

class AppTheme {


  static const Color accentColor = Color(0xFFDFE7DE);
  static const Color primaryColorDark = Color(0xFF01522A);
  static const Color primaryColorLight = Color(0xFF6F9D83);
  // Background colors
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color scaffoldBackgroundColor = Color(0xFFF4F4F4);

  // Text colors
  static const Color textColor = Color(0xFF333333);
  static const Color subtitleColor = Color(0xFF666666);
  static const Color darkGrey = Color(0xFF211f1f);
  static const Color hintColor = Color(0xFFCCCCCC);

  //Task Category Color

  static const Color category1 = Color(0xFFF3BE59);
  static const Color category2 = Color(0xFFADBCB3);
  static const Color category3 = Color(0xFFf5e0ba);
  static const Color category4 = Color(0xFFBFC194);
  static const Color category5 = Color(0xFF064724);



  // Custom text styles
  static const TextStyle headline1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColor,
    fontFamily: 'Tajawal',

  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: textColor,
    fontFamily: 'Tajawal',
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 15,
    color: textColor,
    fontFamily: 'Tajawal',
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 13,
    color: subtitleColor,
    fontFamily: 'Tajawal',
  );


  static TextStyle customTextStyle({
    double fontSize = 15,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: decoration,
      fontFamily: 'Tajawal',
    );
  }

  // App bar theme
  static ThemeData getAppTheme() {
    return ThemeData(
      primaryColor: primaryColorLight,
      hintColor: accentColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: ColorScheme.light(
        // change the border color
        primary: primaryColorLight,
        secondary:primaryColorLight,
        onSecondary: Colors.white,
        onSurface: accentColor,
      ),
      fontFamily: 'Tajawal',
      textTheme:  const TextTheme(
        displayLarge: headline1,
        displayMedium: headline2,
        bodyLarge: bodyText1,
        bodyMedium: bodyText2,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColorLight,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
