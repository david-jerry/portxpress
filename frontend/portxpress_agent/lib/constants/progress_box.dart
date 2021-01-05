import 'package:flutter/material.dart';
import 'package:portxpress_agent/themes/colors.dart';
import 'package:portxpress_agent/themes/size.dart';

class ProgressDialog extends StatelessWidget {
  String message;
  ProgressDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kPrimaryColor,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20.0),
            vertical: getProportionateScreenHeight(20.0)),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              SizedBox(
                width: getProportionateScreenWidth(6.0),
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
              SizedBox(
                width: getProportionateScreenWidth(16.0),
              ),
              Text(
                message,
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
