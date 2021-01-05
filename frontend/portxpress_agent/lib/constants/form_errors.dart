// Form Error
import 'package:flutter/material.dart';
import 'package:portxpress_agent/themes/colors.dart';
import 'package:portxpress_agent/themes/size.dart';

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp phoneValidatorRegExp =
    RegExp(r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$");
final RegExp nameValidatorRegExp = RegExp(r"^[a-zA-Z, .\-]+$");
const String kPhoneNumberNullError = "Please Enter your Phone Number";
const String kInvalidPhoneNumberError = "Please Enter Valid Phone Number";
const String kEmailNullError = "Please Enter your Email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your Password";
const String kShortPassError = "Password is too Short";
const String kMatchPassError = "Passwords don't match";
const String kNameNullError = "Please Enter your Name";
const String kCompanyNameNullError = "Please Enter your Company Name";
const String kInvalidNameError = "Please Enter Valid Name";
const String kInvalidCompanyNameError = "Please Enter Valid Company Name";
const String kAddressNullError = "Please Enter your Address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
