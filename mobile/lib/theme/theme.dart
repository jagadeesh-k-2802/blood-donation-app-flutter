import 'package:flutter/material.dart';

const Color primaryColor = Color(0xfffb4458);
const Color secondaryColor = Color(0xffe1051c);
const double defaultPagePadding = 16;

const MaterialColor primaryMaterialColor = MaterialColor(4294657112, {
  50: Color(0xfffee6e9),
  100: Color(0xfffecdd2),
  200: Color(0xfffd9ba6),
  300: Color(0xfffc6979),
  400: Color(0xfffb374d),
  500: Color(0xfffa0520),
  600: Color(0xffc8041a),
  700: Color(0xff960313),
  800: Color(0xff64020d),
  900: Color(0xff320106)
});

ThemeData bloodDonationAppTheme = ThemeData(
  primaryColor: primaryColor,
  colorScheme: const ColorScheme.light().copyWith(primary: primaryColor),
  primarySwatch: primaryMaterialColor,
  scrollbarTheme: const ScrollbarThemeData().copyWith(
    thumbColor: MaterialStateProperty.all(primaryMaterialColor[500]),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: secondaryColor,
      minimumSize: const Size.fromHeight(40),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
  ),
  sliderTheme: SliderThemeData(
    showValueIndicator: ShowValueIndicator.always,
    overlayShape: SliderComponentShape.noOverlay,
  ),
);
