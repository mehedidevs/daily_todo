import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color blueish= Colors.blueAccent;
Color yellowish= Colors.purple;
const Color pinkish= Colors.pinkAccent;
const Color white= Colors.white;
const Color darkGrey= Colors.grey;
const Color darkHeader= Colors.blueGrey;


class Themes{

  static final light=ThemeData(
    backgroundColor: darkGrey,
        primaryColor: darkGrey,
        brightness: Brightness.light,


  );
  static final dark=ThemeData(
    backgroundColor: darkGrey,
    primaryColor: darkHeader,
    brightness: Brightness.dark,

  );




}
TextStyle get subHeadingStyle{

  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
      )

  );
}

TextStyle get headingStyle{

  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold
      )

  );
}

TextStyle get titleStyle{

  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400
      )

  );
}

TextStyle get subTitleStyle{

  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,

      )

  );
}