import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_stack_finance/signin.dart';
import 'package:poc_stack_finance/signup.dart';
import 'package:poc_stack_finance/splashScreen.dart';
import 'constants.dart';
import 'onboarding.dart';

FirebaseDatabase database;
String userFirstName = "First Name";
String userLastName = "Last Name";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: APPNAME,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
