import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:portxpress_agent/components/custom_surfix_icon.dart';
import 'package:portxpress_agent/components/form_error.dart';
import 'package:portxpress_agent/constants/form_errors.dart';
import 'package:portxpress_agent/constants/progress_box.dart';
import 'package:portxpress_agent/helper/keyboard.dart';
import 'package:portxpress_agent/main.dart';
import 'package:portxpress_agent/screens/sign_in/sign_in_screen.dart';
import 'package:portxpress_agent/themes/colors.dart';
import 'package:portxpress_agent/themes/size.dart';

class SignUpForm extends StatefulWidget {
  final String message =
      "An email has just been sent to you, Click the link provided to complete registration";
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController companyTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  String email;
  String password;
  String company;
  String address;
  String name;
  String confirmPassword;
  String phoneNumber;
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
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildCompanyNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          RaisedButton(
            color: kPrimaryColor,
            textColor: Colors.white,
            child: Container(
              height: 54.0,
              child: Center(
                child: Text(
                  "REGISTER",
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
                  nameTextEditingController.text.length > 8 &&
                      phoneTextEditingController.text.isNotEmpty &&
                      nameTextEditingController.text.isNotEmpty &&
                      companyTextEditingController.text.isNotEmpty &&
                      emailTextEditingController.text.isNotEmpty &&
                      addressTextEditingController.text.isNotEmpty &&
                      emailTextEditingController.text.contains("@")) {
                //   _formKey.currentState.save();
                KeyboardUtil.hideKeyboard(context);
                registerNewUser(context);
                _formKey.currentState.save();
                //   // if all are valid then go to success screen
                //   // Navigator.pushNamed(context, HomeScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(
          message: "Creating Account Now! Please wait.",
        );
        // return ProgressDialog[message: "Authenticating! Please wait."];
      },
    );

    final User firebaseuser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
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
    await firebaseuser.sendEmailVerification();
    if (firebaseuser != null) {
      // Save user if not null
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "company": companyTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "address": phoneTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "type": "agent",
      };
      usersRef.child(firebaseuser.uid).set(userDataMap);
      deisplayToastMsg(
          "Account Creation Successful! \n\nWelcome onboard, Agent.",
          Colors.green[100],
          context);
      Navigator.pushNamed(context, SignInScreen.routeName);
    } else {
      Navigator.pop(context);
      // error occured display message
      deisplayToastMsg("Account Creation Failed! \n\nPlease try again.",
          Colors.red[200], context);
      Navigator.pushNamed(context, SignInScreen.routeName);
    }
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == confirmPassword) {
          removeError(error: kMatchPassError);
        }
        confirmPassword = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          deisplayToastMsg(kPassNullError, kDangerColor, context);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          deisplayToastMsg(kMatchPassError, kDangerColor, context);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordTextEditingController,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          deisplayToastMsg(kPassNullError, kDangerColor, context);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          deisplayToastMsg(kShortPassError, kDangerColor, context);
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
          deisplayToastMsg(kEmailNullError, kDangerColor, context);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          deisplayToastMsg(kInvalidEmailError, kDangerColor, context);
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

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      controller: phoneTextEditingController,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        } else if (phoneValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidPhoneNumberError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          deisplayToastMsg(kPhoneNumberNullError, kDangerColor, context);
          return "";
        } else if (!phoneValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidPhoneNumberError);
          deisplayToastMsg(kInvalidPhoneNumberError, kDangerColor, context);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your Phone Number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: nameTextEditingController,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && nameTextEditingController.text.length < 8) {
          removeError(error: kNameNullError);
        } else if (nameValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidNameError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNameNullError);
          deisplayToastMsg(kNameNullError, kDangerColor, context);
          return "";
        } else if (!nameValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidNameError);
          deisplayToastMsg(kInvalidNameError, kDangerColor, context);
          return "";
        } else if (value.length < 8) {
          deisplayToastMsg("Name too short, atleast should contain 8",
              kDangerColor, context);
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter your Full Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildCompanyNameFormField() {
    return TextFormField(
      controller: companyTextEditingController,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => company = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCompanyNameNullError);
        } else if (nameValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidCompanyNameError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kCompanyNameNullError);
          deisplayToastMsg(kCompanyNameNullError, kDangerColor, context);
          return "";
        } else if (!nameValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidCompanyNameError);
          deisplayToastMsg(kInvalidCompanyNameError, kDangerColor, context);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Company Name",
        hintText: "Enter your Company Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Shop Icon.svg"),
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      controller: addressTextEditingController,
      keyboardType: TextInputType.streetAddress,
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Street Address",
        hintText: "Enter your Street Address, City, State",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }
}

deisplayToastMsg(String message, Color color, BuildContext context) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: color,
    textColor: Colors.black87,
    fontSize: 17.0,
  );
}
