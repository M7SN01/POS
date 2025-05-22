import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
#00932a
Button
icons
price
selected card borders


#f5f5f5
background



#373737
other icons


*/
ThemeData t1 = ThemeData(
  fontFamily: GoogleFonts.cairo().fontFamily,
  scaffoldBackgroundColor: const Color(0xFFf5f7f9),
  cardColor: const Color.fromRGBO(0, 0, 0, 1),
  primaryColor: Colors.green,

  // work-----------------------
  dialogBackgroundColor: Colors.yellow,
  cardTheme: const CardTheme(
    color: Colors.white,
  ),

  //Work #text Filed &Form
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      gapPadding: 4,
      borderSide: BorderSide(width: 2, color: Colors.grey),
      borderRadius: BorderRadius.all(
        Radius.circular(
          4,
        ),
      ),
    ),
    focusColor: Color(0xFF00932a),
  ),
);
