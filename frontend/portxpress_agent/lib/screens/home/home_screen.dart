import 'package:flutter/material.dart';
import 'package:portxpress_agent/components/coustom_bottom_nav_bar.dart';
import 'package:portxpress_agent/screens/contact/contact_screen.dart';
import 'package:portxpress_agent/themes/colors.dart';

import '../../enums.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.pushNamed(context, ContactScreen.routeName);
        },
        child: Icon(Icons.phone),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
