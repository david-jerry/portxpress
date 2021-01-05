import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:portxpress_agent/screens/sign_in/sign_in_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3500,
      centered: true,
      splash: 'assets/images/logo.png',
      nextScreen: SignInScreen(),
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Colors.white70,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
    );
  }
}
