import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poc_stack_finance/signup.dart';
import 'package:poc_stack_finance/uicomponents.dart';
import 'constants.dart';
import 'customIcons.dart';
import 'dashboard.dart';
import 'externalAlerts.dart';
import 'main.dart' as main;

final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final FirebaseAuth _auth = FirebaseAuth.instance;
bool obscureText = true;
bool statusForEmail = true;
bool statusForPassword = true;

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  void initState() {
    _emailController.clear();
    _passwordController.clear();
    obscureText = true;
    firebaseDatabaseInitialisation().then((value) {
      main.database = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: genericAppBar(),
      backgroundColor: parseColor(FILLCOLOUR),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height-MediaQuery.of(context).viewInsets.bottom,
            // color: Colors.red,
            color: parseColor(FILLCOLOUR),
            child: Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: SvgPicture.asset(
                            "Assets/Images/insidelogo.svg",
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 17),
                              child: Text(
                                EMAILID,
                                style: genericTextDecoration(colour: parseColor(TEXTCOLOUR)),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 45,
                          decoration: statusForEmail
                            ? genericTextFieldDecoration()
                            : genericTextFieldDecoration(colour: Colors.red),
                          child: TextField(
                            controller: _emailController,
                            onChanged: (value) {},
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: statusForEmail
                                  ? Image.asset("Assets/Images/username_correct.png")
                                  : Image.asset("Assets/Images/username_error.png"),
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 15, 0, 17),
                              child: Text(
                                PASSWORD,
                                style: genericTextDecoration(colour: parseColor(TEXTCOLOUR)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                child: obscureText
                                  ? Image.asset("Assets/Images/password_eye_closed.png")
                                  : Image.asset("Assets/Images/password_eye_opened.png")
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 45,
                          decoration: statusForPassword
                            ? genericTextFieldDecoration()
                            : genericTextFieldDecoration(colour: Colors.red),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: obscureText,
                            onChanged: (value) {},
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => FocusScope.of(context).unfocus(),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: statusForPassword
                                  ? Image.asset("Assets/Images/password_correct.png")
                                  : Image.asset("Assets/Images/password_error.png"),
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5)
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              if (_emailController == null || _emailController.text.trim().length == 0)
                                setState(() {
                                  statusForEmail = false;
                                  statusForPassword = true;
                                  EdgeAlert.show(context,
                                    gravity: EdgeAlert.TOP,
                                    icon: CustomIcons.erroralert,
                                    description: EMPTYMAILADDRESS,
                                    backgroundColor: parseColor(DELETECOLOUR)
                                  );
                                });
                              else if (_passwordController == null || _passwordController.text.trim().length == 0)
                                setState(() {
                                  statusForEmail = true;
                                  statusForPassword = false;
                                  EdgeAlert.show(context,
                                    gravity: EdgeAlert.TOP,
                                    icon: CustomIcons.erroralert,
                                    description: EMPTYPASSWORDADDRESS,
                                    backgroundColor: parseColor(DELETECOLOUR)
                                  );
                                });
                              else {
                                setState(() {
                                  statusForEmail = true;
                                  statusForPassword = true;
                                });
                                autheticate(context);
                              }
                            },
                            child: Container(
                              height: 47,
                              width: 307,
                              decoration: genericButtonDecoration(),
                              child: Center(
                                child: Text(
                                  SIGNIN,
                                  style: genericTextDecoration(colour: Colors.white),
                                )
                              ),
                            )
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.75,
                          child: Text(
                            SIGNUPGUIDE,
                            style: genericTextDecoration(colour: parseColor("#fbfbfb"), fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: GestureDetector(
                            onTap: () async {
                              // var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()),);
                              // _emailController.clear();
                              // _passwordController.clear();
                              // obscureText = true;
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()),
                              );
                            },
                            child: Container(
                              height: 33,
                              width: 82,
                              decoration: genericButtonDecoration(),
                              child: Center(
                                child: Text(
                                  SIGNUP,
                                  style: genericTextDecoration(fontSize: 14, colour: Colors.white),
                                )
                              ),
                            )
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void autheticate(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    child: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(parseColor(TEXTCOLOUR)),
      ),
    )
  );
  try {
    final User user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )).user;
    Navigator.pop(context);
    var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(
          user: user,
          isNewUser: false,
        )),);
    _emailController.clear();
    _passwordController.clear();
    obscureText = true;
  } catch (error) {
    Navigator.pop(context);
    if (error.code.toString() == "invalid-email")
      EdgeAlert.show(context,
        gravity: EdgeAlert.TOP,
        icon: CustomIcons.erroralert,
        description: INVALIDMAILADDRESS,
        backgroundColor: parseColor(DELETECOLOUR)
      );
    else if (error.code.toString() == "user-not-found")
      EdgeAlert.show(context,
        gravity: EdgeAlert.TOP,
        icon: CustomIcons.erroralert,
        description: "No Such User Exist",
        backgroundColor: parseColor(DELETECOLOUR)
      );
    else if (error.code.toString() == "wrong-password")
      EdgeAlert.show(context,
          gravity: EdgeAlert.TOP,
          icon: CustomIcons.erroralert,
          description: INVALIDPASSWORDADDRESS,
          backgroundColor: parseColor(DELETECOLOUR));
    else
      EdgeAlert.show(context,
        gravity: EdgeAlert.TOP,
        icon: CustomIcons.erroralert,
        description: SOMETHINGWENTWRONG,
        backgroundColor: parseColor(DELETECOLOUR)
      );
    print(error);
  }
}

Future<FirebaseDatabase> firebaseDatabaseInitialisation() async {
  final FirebaseApp app = await Firebase.initializeApp(
    options: FirebaseOptions(
      appId: APPID,
      apiKey: APPKEY,
      projectId: PROJECTID,
      messagingSenderId: SENDERID,
      databaseURL: DATABASEURL,
    )
  );
  final FirebaseDatabase database = FirebaseDatabase(app: app);
  return database;
}
