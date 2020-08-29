import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_stack_finance/customIcons.dart';
import 'package:poc_stack_finance/onboarding.dart';
import 'package:poc_stack_finance/uicomponents.dart';
import 'constants.dart';
import 'externalAlerts.dart';
import 'main.dart' as main;

bool statusForEmail = true;
bool statusForUsername = true;
bool statusForPassword = true;
bool statusForVerifyPassword = true;
bool statusForFirstName = true;
bool statusForLastName = true;
bool obscurePassword = true;
bool tncChecked = false;

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _reenterPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    statusForEmail = true;
    statusForPassword = true;
    statusForFirstName = true;
    statusForLastName = true;
    statusForVerifyPassword = true;
    statusForUsername = true;
    tncChecked = false;
    obscurePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: parseColor(TEXTCOLOUR),
            ),
          ),
          elevation: 0,
        ),
      ),
      backgroundColor: parseColor(FILLCOLOUR),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Center(
              child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 17, 0, 17),
                child: Text(
                  FIRSTNAME,
                  style: genericTextDecoration(colour: parseColor(TEXTCOLOUR)),
                ),
              ),
              Container(
                height: 45,
                decoration: statusForFirstName
                  ? genericTextFieldDecoration()
                  : genericTextFieldDecoration(colour: Colors.red),
                child: TextField(
                  controller: _firstNameController,
                  onChanged: (value) {},
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  inputFormatters: <TextInputFormatter>[
                    new WhitelistingTextInputFormatter(RegExp("[a-zA-Z]"))
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: statusForFirstName
                        ? Image.asset("Assets/Images/name_correct.png")
                        : Image.asset("Assets/Images/name_error.png"),
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 17, 0, 17),
                child: Text(
                  LASTNAME,
                  style: genericTextDecoration(colour: parseColor(TEXTCOLOUR)),
                ),
              ),
              Container(
                height: 45,
                decoration: statusForLastName
                  ? genericTextFieldDecoration()
                  : genericTextFieldDecoration(colour: Colors.red),
                child: TextField(
                  controller: _lastNameController,
                  onChanged: (value) {},
                  inputFormatters: <TextInputFormatter>[
                    new WhitelistingTextInputFormatter(RegExp("[a-zA-Z]"))
                  ],
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: statusForLastName
                        ? Image.asset("Assets/Images/name_correct.png")
                        : Image.asset("Assets/Images/name_error.png"),
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 17, 0, 17),
                child: Text(
                  EMAILID,
                  style: genericTextDecoration(colour: parseColor(TEXTCOLOUR)),
                ),
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
                        ? Image.asset("Assets/Images/email_correct.png")
                        : Image.asset("Assets/Images/email_error.png"),
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 17, 0, 17),
                child: Text(
                  USERNAME,
                  style: genericTextDecoration(colour: parseColor(TEXTCOLOUR)),
                ),
              ),
              Container(
                height: 45,
                decoration: statusForUsername
                  ? genericTextFieldDecoration()
                  : genericTextFieldDecoration(colour: Colors.red),
                child: TextField(
                  controller: _usernameController,
                  onChanged: (value) {},
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: statusForUsername
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
                    padding: EdgeInsets.fromLTRB(0, 17, 0, 17),
                    child: Text(
                      PASSWORD,
                      style: genericTextDecoration(colour: parseColor(TEXTCOLOUR)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      child: obscurePassword
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
                  obscureText: obscurePassword,
                  onChanged: (value) {
                    setState(() {
                      _reenterPasswordController.text = "";
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: statusForPassword
                        ? Image.asset("Assets/Images/password_correct.png")
                        : Image.asset("Assets/Images/password_error.png")
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 17, 0, 17),
                child: Text(
                  VERIFYPASSWORD,
                  style: genericTextDecoration(colour: parseColor(TEXTCOLOUR)),
                ),
              ),
              Container(
                height: 45,
                decoration: statusForVerifyPassword
                  ? genericTextFieldDecoration()
                  : genericTextFieldDecoration(colour: Colors.red),
                child: TextField(
                  controller: _reenterPasswordController,
                  obscureText: obscurePassword,
                  onChanged: (value) {},
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: statusForVerifyPassword
                        ? Image.asset("Assets/Images/reenter_password_correct.png")
                        : Image.asset("Assets/Images/reenter_password_error.png"),
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            tncChecked = !tncChecked;
                          });
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          child: tncChecked
                              ? Image.asset("Assets/Images/checkbox_selected.png")
                              : Image.asset("Assets/Images/checkbox_unselected.png"),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        AGREEMENT + " ",
                        style: genericTextDecoration(fontSize: 15, colour: parseColor(TEXTCOLOUR)),
                      ),
                      Opacity(
                        opacity: 0.75,
                        child: Text(
                          TERMSANDCONDITIONS,
                          style: genericTextDecoration(
                            fontSize: 14,
                            textDecoration: TextDecoration.underline,
                            colour: Colors.white
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                    child: GestureDetector(
                      onTap: () async {
                        if (_firstNameController == null || _firstNameController.text.trim().length == 0)
                          setState(() {
                            statusForEmail = true;
                            statusForUsername = true;
                            statusForPassword = true;
                            statusForVerifyPassword = true;
                            statusForFirstName = false;
                            statusForLastName = true;
                            EdgeAlert.show(context,
                              gravity: EdgeAlert.TOP,
                              icon: CustomIcons.erroralert,
                              description: EMPTYLASTNAME,
                              backgroundColor: parseColor(DELETECOLOUR)
                            );
                          });
                        else if (_lastNameController == null || _lastNameController.text.trim().length == 0)
                          setState(() {
                            statusForEmail = true;
                            statusForUsername = true;
                            statusForPassword = true;
                            statusForVerifyPassword = true;
                            statusForFirstName = true;
                            statusForLastName = false;
                            EdgeAlert.show(context,
                              gravity: EdgeAlert.TOP,
                              icon: CustomIcons.erroralert,
                              description: EMPTYLASTNAME,
                              backgroundColor: parseColor(DELETECOLOUR)
                            );
                          });
                        else if (_emailController == null || _emailController.text.trim().length == 0)
                          setState(() {
                            statusForEmail = false;
                            statusForUsername = true;
                            statusForPassword = true;
                            statusForVerifyPassword = true;
                            statusForFirstName = true;
                            statusForLastName = true;
                            EdgeAlert.show(context,
                              gravity: EdgeAlert.TOP,
                              icon: CustomIcons.erroralert,
                              description: INVALIDMAILADDRESS,
                              backgroundColor: parseColor(DELETECOLOUR)
                            );
                          });
                        else if (_usernameController == null || _usernameController.text.trim().length == 0)
                          setState(() {
                            statusForEmail = true;
                            statusForUsername = false;
                            statusForPassword = true;
                            statusForVerifyPassword = true;
                            statusForFirstName = true;
                            statusForLastName = true;
                            EdgeAlert.show(context,
                              gravity: EdgeAlert.TOP,
                              icon: CustomIcons.erroralert,
                              description: INVALIDUSERNAME,
                              backgroundColor: parseColor(DELETECOLOUR)
                            );
                          });
                        else if (_passwordController == null || _passwordController.text.trim().length == 0)
                          setState(() {
                            statusForEmail = true;
                            statusForUsername = true;
                            statusForPassword = false;
                            statusForVerifyPassword = true;
                            statusForFirstName = true;
                            statusForLastName = true;
                            EdgeAlert.show(context,
                              gravity: EdgeAlert.TOP,
                              icon: CustomIcons.erroralert,
                              description: INVALIDPASSWORDADDRESS,
                              backgroundColor: parseColor(DELETECOLOUR)
                            );
                          });
                        else if (_reenterPasswordController == null || _reenterPasswordController.text.trim().length == 0 || _reenterPasswordController.text.trim() != _passwordController.text.trim())
                          setState(() {
                            statusForEmail = true;
                            statusForUsername = true;
                            statusForPassword = true;
                            statusForVerifyPassword = false;
                            statusForFirstName = true;
                            statusForLastName = true;
                            EdgeAlert.show(context,
                              gravity: EdgeAlert.TOP,
                              icon: CustomIcons.erroralert,
                              description: PASSWORDMISMATCH,
                              backgroundColor: parseColor(DELETECOLOUR)
                            );
                          });
                        else if (!tncChecked) {
                          setState(() {
                            statusForEmail = true;
                            statusForPassword = true;
                            statusForUsername = true;
                            statusForVerifyPassword = true;
                            statusForFirstName = true;
                            statusForLastName = true;
                          });
                          EdgeAlert.show(context,
                            gravity: EdgeAlert.TOP,
                            icon: CustomIcons.erroralert,
                            description: TNCACCEPTANCEALERT,
                            backgroundColor: parseColor(DELETECOLOUR)
                          );
                        } else {
                          setState(() {
                            statusForEmail = true;
                            statusForPassword = true;
                            statusForUsername = true;
                            statusForVerifyPassword = true;
                            statusForFirstName = true;
                            statusForLastName = true;
                          });
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  parseColor(TEXTCOLOUR)
                                ),
                              ),
                            )
                          );
                          await Firebase.initializeApp();
                          try {
                            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            main.userFirstName = _firstNameController.text;
                            main.userLastName = _lastNameController.text;
                            Navigator.push(context,MaterialPageRoute(builder: (context) => Onboarding(
                              user: userCredential.user,
                            )),
                            );
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            Navigator.pop(context);
                            if (e.code == 'weak-password') {
                              setState(() {
                                statusForPassword = false;
                              });
                              EdgeAlert.show(context,
                                gravity: EdgeAlert.TOP,
                                icon: CustomIcons.erroralert,
                                description: SHORTPASSWORD,
                                backgroundColor: parseColor(DELETECOLOUR)
                              );
                            } else if (e.code == 'email-already-in-use') {
                              setState(() {
                                statusForEmail = false;
                              });
                              EdgeAlert.show(context,
                                gravity: EdgeAlert.TOP,
                                icon: CustomIcons.erroralert,
                                description: IDALREADYREGISTERED,
                                backgroundColor: parseColor(DELETECOLOUR)
                              );
                            }
                          } catch (e) {
                            print(e.toString());
                          }
                        }
                      },
                      child: Container(
                        height: 47,
                        width: 307,
                        decoration: genericButtonDecoration(),
                        child: Center(
                          child: Text(
                            REGISTER,
                            style: genericTextDecoration(colour: Colors.white),
                          )
                        ),
                      )
                    ),
                  )
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
