import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poc_stack_finance/uicomponents.dart';
import 'constants.dart';
import 'dashboard.dart';

class Onboarding extends StatefulWidget {
  User user;

  Onboarding({this.user});

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppBar(),
      backgroundColor: parseColor(FILLCOLOUR),
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  WELCOME,
                  style: genericTextDecoration(fontSize: 35, colour: parseColor("#FFD9D4").withOpacity(0.75)),
                ),
                Opacity(
                  opacity: 0.75,
                  child: Text(
                    REGISTERATIONSUCCESS,
                    style: genericTextDecoration(fontSize: 15, colour: Colors.white, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Container(
                    height: 375,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: parseColor(FILLCOLOURLIGHT),
                    ),
                    child: SvgPicture.asset("Assets/Images/onboarding.svg"),
                    //TODO: Carousel View for app tour/guide
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(
                            user: widget.user,
                            isNewUser: true,
                          )),
                        );
                      },
                      child: Container(
                        height: 47,
                        width: 200,
                        decoration: genericButtonDecoration(),
                        child: Center(
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              CONTINUE,
                              style: genericTextDecoration(fontSize: 18, colour: Colors.white),
                            ),
                            Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            )
                          ],
                        )
                      ),
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
