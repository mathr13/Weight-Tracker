import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poc_stack_finance/constants.dart';
import 'package:poc_stack_finance/signin.dart';
import 'package:poc_stack_finance/uicomponents.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  Animation<Offset> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    waitAndNavigate(context);
    _controller = AnimationController(
        duration: const Duration(seconds: SPLASHANIMATIONDURATION),
        vsync: this,
      )..forward();
      _animation = Tween<Offset>(
        begin: const Offset(0.0, 0.75),
        end: const Offset(1, 0.75),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInCubic,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: parseColor(FILLCOLOUR),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("Assets/Images/insidelogo.svg"),
                SizedBox(
                  height: 25,
                ),
                Text(
                  APPNAME,
                  style: GoogleFonts.satisfy(
                    fontSize: 40,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) => Center(
              child: SlideTransition(
                position: _animation,
                child: Container(
                  height: 75,
                  color: parseColor(FILLCOLOUR),
                  // color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void waitAndNavigate(context) async {
  await Future.delayed(Duration(seconds: SPLASHANIMATIONDURATION+1));
  Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()),);
}