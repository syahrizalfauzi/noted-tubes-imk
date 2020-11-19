import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

enum FontSize {
  small,
  medium,
  large,
}

FontSize fontSize = FontSize.medium;

String get fontSizeText {
  switch (fontSize) {
    case FontSize.small:
      return "Small";
    case FontSize.medium:
      return "Medium";
    case FontSize.large:
      return "Large";
    default:
      return "Medium";
  }
}

TextStyle get headerStyle => GoogleFonts.spartan(color: hitam, fontSize: 30, fontWeight: FontWeight.w600);

TextStyle get titleStyle {
  switch (fontSize) {
    case FontSize.small:
      return GoogleFonts.spartan(color: hitam, fontSize: 16, fontWeight: FontWeight.w700);
    case FontSize.medium:
      return GoogleFonts.spartan(color: hitam, fontSize: 18, fontWeight: FontWeight.w700);
    case FontSize.large:
      return GoogleFonts.spartan(color: hitam, fontSize: 28, fontWeight: FontWeight.w700);
    default:
      return GoogleFonts.spartan(color: hitam, fontSize: 18, fontWeight: FontWeight.w700);
  }
}

TextStyle get subtitleStyle {
  switch (fontSize) {
    case FontSize.small:
      return GoogleFonts.spartan(color: hitam, fontSize: 8, fontWeight: FontWeight.w700);
    case FontSize.medium:
      return GoogleFonts.spartan(color: hitam, fontSize: 10, fontWeight: FontWeight.w700);
    case FontSize.large:
      return GoogleFonts.spartan(color: hitam, fontSize: 14, fontWeight: FontWeight.w700);
    default:
      return GoogleFonts.spartan(color: hitam, fontSize: 10, fontWeight: FontWeight.w700);
  }
}

TextStyle get textStyle {
  switch (fontSize) {
    case FontSize.small:
      return GoogleFonts.lato(color: hitam, fontSize: 12, fontWeight: FontWeight.w400);
    case FontSize.medium:
      return GoogleFonts.lato(color: hitam, fontSize: 14, fontWeight: FontWeight.w400);
    case FontSize.large:
      return GoogleFonts.lato(color: hitam, fontSize: 18, fontWeight: FontWeight.w400);
    default:
      return GoogleFonts.lato(color: hitam, fontSize: 14, fontWeight: FontWeight.w400);
  }
}

TextStyle get trailingStyle {
  switch (fontSize) {
    case FontSize.small:
      return GoogleFonts.lato(color: hitam, fontSize: 8, fontWeight: FontWeight.w400);
    case FontSize.medium:
      return GoogleFonts.lato(color: hitam, fontSize: 10, fontWeight: FontWeight.w400);
    case FontSize.large:
      return GoogleFonts.lato(color: hitam, fontSize: 16, fontWeight: FontWeight.w400);
    default:
      return GoogleFonts.lato(color: hitam, fontSize: 10, fontWeight: FontWeight.w400);
  }
}
