import 'package:flutter/material.dart';
import 'package:portxpress_agent/themes/size.dart';

const kPrimaryColor = Color(0xFF38A8AD);
const kPrimaryLightColor = Color(0xFF6FF5FC);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kPrimaryColor, kPrimaryLightColor],
);
const kSecondaryColor = Color(0xFF414141);
const kTextColor = Color(0xFF676767);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const kDangerColor = Color(0xFFFF9595);
