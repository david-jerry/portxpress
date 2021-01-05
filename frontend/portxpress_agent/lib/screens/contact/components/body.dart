// import 'dart:html';

import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';
import 'package:portxpress_agent/themes/colors.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContactUs(
      textColor: kTextColor,
      cardColor: Colors.white,
      taglineColor: kTextColor,
      companyColor: kPrimaryColor,
      logo: AssetImage('images/logo.png'),
      email: 'info@portxpress.com.ng',
      companyName: 'PortXpress Nig Limited',
      phoneNumber: '+2341123456789',
      website: 'https://www.portxpress.com.ng',
      tagLine: 'Delivery Satisfaction Guaranteed',
      twitterHandle: 'portxpress_ng',
      instagram: 'portxpress_ng',
    );
  }
}
