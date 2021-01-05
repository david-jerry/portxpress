import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:portxpress_agent/components/custom_surfix_icon.dart';
import 'package:portxpress_agent/components/form_error.dart';
import 'package:portxpress_agent/constants/form_errors.dart';
import 'package:portxpress_agent/constants/progress_box.dart';
import 'package:portxpress_agent/helper/keyboard.dart';
import 'package:portxpress_agent/screens/forgot_password/forgot_password_screen.dart';
import 'package:portxpress_agent/screens/home/home_screen.dart';
import 'package:portxpress_agent/screens/sign_up/components/sign_up_form.dart';
import 'package:portxpress_agent/screens/sign_up/sign_up_screen.dart';
import 'package:portxpress_agent/themes/colors.dart';
import 'package:portxpress_agent/themes/size.dart';

import '../../../main.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  String email;
  String password;
  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          RaisedButton(
            color: kPrimaryColor,
            textColor: Colors.white,
            child: Container(
              height: 54.0,
              child: Center(
                child: Text(
                  "SIGNIN",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22.0,
                  ),
                ),
              ),
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(16)),
            onPressed: () {
              if (_formKey.currentState.validate() ||
                  emailTextEditingController.text.isNotEmpty &&
                      emailTextEditingController.text.contains("@") &&
                      passwordTextEditingController.text.isNotEmpty) {
                //   _formKey.currentState.save();
                // Navigator.pushNamed(context, HomeScreen.routeName);
                loginSuccessful(context);
                KeyboardUtil.hideKeyboard(context);
                // _formKey.currentState.save();
              }
            },
          ),
        ],
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginSuccessful(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(
          message: "Authenticating! Please wait.",
        );
        // return ProgressDialog[message: "Authenticating! Please wait."];
      },
    );
    final User firebaseuser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError(
      (errMsg) {
        Navigator.pop(context);
        deisplayToastMsg(
            "Error: " + errMsg.message.toString(), kDangerColor, context);
      },
    ))
        .user;

    if (firebaseuser != null && firebaseuser.emailVerified) {
      // Save user if not null
      usersRef.child(firebaseuser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pop(context);
          Navigator.pushNamed(context, HomeScreen.routeName);
          deisplayToastMsg("Login Successful.", kPrimaryColor, context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          deisplayToastMsg("No records found!", kDangerColor, context);
          Navigator.pushNamed(context, SignUpScreen.routeName);
        }
      });
    } else {
      // error occured display message
      Navigator.pop(context);
      firebaseuser.sendEmailVerification();
      deisplayToastMsg("Verify Your Email", kDangerColor, context);
    }
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      controller: passwordTextEditingController,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailTextEditingController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
