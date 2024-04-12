import 'package:flutter/material.dart';

Color greenColor = const Color.fromRGBO(34, 159, 61, 1);
Color lightGray = const Color.fromRGBO(237, 248, 239, 1);
Color black = const Color.fromRGBO(3, 19, 7, 1);
Color gray = const Color.fromRGBO(107, 110, 108, 1);
Color white = const Color.fromRGBO(255, 255, 255, 1);

Color lowOpacityGreenColor = Color.fromARGB(67, 163, 237, 179);
Color midOpacityGreenColor = Color.fromRGBO(105, 244, 147, 0.6);

double getUnitHeight(BuildContext context) {
  double unitHeightVlaue = MediaQuery.of(context).size.height * 0.01;
  return unitHeightVlaue;
}

double getUnitWidth(BuildContext context) {
  double unitWidthVlaue = MediaQuery.of(context).size.width * 0.01;
  return unitWidthVlaue;
}
