import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:poc_stack_finance/customIcons.dart';
import 'package:poc_stack_finance/externalAlerts.dart';
import 'package:poc_stack_finance/timeFormatting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poc_stack_finance/uicomponents.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart' as main;
import 'models.dart';
import 'package:intl/intl.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

final dBRef = FirebaseDatabase.instance.reference();
Map<String, dynamic> dataSource = {};
final _scrollController = ScrollController();
bool isDataFetched = false;
final _weightController = TextEditingController();

List<Weight> listOfObjects = [];

class Dashboard extends StatefulWidget {
  User user;
  bool isNewUser;
  Dashboard({this.user, this.isNewUser});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    listOfObjects.clear();
    isDataFetched = false;
    if (widget.isNewUser == null)
      widget.isNewUser = false;
    fetchDataFromFirebase(main.database, widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)
                  ),
                ),
                height: 200,
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                RECORDS,
                                style: genericTextDecoration(
                                  fontSize: 40,
                                  colour: parseColor(TEXTCOLOUR)
                                )
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8, left: 10),
                                child: Container(
                                  height: 28,
                                  width: 34,
                                  decoration: BoxDecoration(
                                    color: parseColor(PRIMARYCOLOUR),
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      listOfObjects.length > 99
                                        ? "99+"
                                        : listOfObjects.length.toString(),
                                      style: genericTextDecoration(colour: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              showGeneralDialog(
                                barrierDismissible: true,
                                barrierLabel: "",
                                barrierColor: Colors.black38,
                                transitionDuration: Duration(milliseconds: 200),
                                pageBuilder: (ctx, anim1, anim2) => getPopUpScreenForEntry(),
                                transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 4 * anim1.value,
                                    sigmaY: 4 * anim1.value
                                  ),
                                  child: FadeTransition(
                                    child: child,
                                    opacity: anim1,
                                  ),
                                ),
                                context: context,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Icon(
                                Icons.add,
                                size: 35,
                                color: parseColor(PRIMARYCOLOUR),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: CircularProfileAvatar(
                      "",
                      backgroundColor: parseColor(BORDERCOLOUR),
                      borderColor: Colors.white,
                      borderWidth: 0.75,
                      initialsText: Text(
                        main.userFirstName.toUpperCase().substring(0, 1) + main.userLastName.toUpperCase().substring(0, 1),
                        style: genericTextDecoration(fontSize: 16, colour: Colors.white),
                      ),
                      radius: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SvgPicture.asset(
                      "Assets/Images/insidelogo.svg",
                      height: 90,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                        barrierDismissible: false,
                        barrierLabel: "",
                        barrierColor: Colors.black38,
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (ctx, anim1, anim2) => getPopUpScreenForProfile(),
                        transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
                          child: FadeTransition(
                            child: child,
                            opacity: anim1,
                          ),
                        ),
                        context: context,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Opacity(
                        opacity: 0.70,
                        child: Image.asset(
                          "Assets/Images/exit.png",
                          color: Colors.white,
                          height: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: parseColor(FILLCOLOUR),
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: !isDataFetched
        ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              parseColor(TEXTCOLOUR)
            ),
          ),
        )
        : listOfObjects.length == 0
          ? Center(
              child: Opacity(
                opacity: 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      NORECORDS,
                      style: genericTextDecoration(
                        colour: parseColor(TEXTCOLOUR),
                        fontSize: 22,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          GOAHEAD+", ",
                          style: genericTextDecoration(
                            colour: parseColor(TEXTCOLOUR),
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showGeneralDialog(
                              barrierDismissible: true,
                              barrierLabel: "",
                              barrierColor: Colors.black38,
                              transitionDuration: Duration(milliseconds: 200),
                              pageBuilder: (ctx, anim1, anim2) => getPopUpScreenForEntry(),
                              transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
                                child: FadeTransition(
                                  child: child,
                                  opacity: anim1,
                                ),
                              ),
                              context: context,
                            );
                          },
                          child: Text(
                            ADDENTRY.toLowerCase(),
                            style: genericTextDecoration(
                              colour: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          " "+NEWENTRY,
                          style: genericTextDecoration(
                            colour: parseColor(TEXTCOLOUR),
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
            controller: _scrollController,
            itemCount: listOfObjects.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  showGeneralDialog(
                    barrierDismissible: true,
                    barrierLabel: "",
                    barrierColor: Colors.black38,
                    transitionDuration: Duration(milliseconds: 200),
                    pageBuilder: (ctx, anim1, anim2) => getPopUpScreenForEntry(index: index),
                    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
                      child: FadeTransition(
                        child: child,
                        opacity: anim1,
                      ),
                    ),
                    context: context,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: unitCellWidget(listOfObjects[index]),
                ),
              );
            },
          ),
      ),
    );
  }

  void addDataFromFirebase(FirebaseDatabase database, User user, double weight) async {
    DatabaseReference _userRef = database.reference().child(user.uid);
    _userRef.push().set(<String, dynamic>{
      "weight": weight,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "change": listOfObjects.length == 0 ? 0.01 : weight - listOfObjects.first.value
    }).then((_) {
      Navigator.pop(context);
      EdgeAlert.show(context,
        backgroundColor: parseColor(EDITCOLOUR),
        description: WEIGHTADDED,
        icon: CustomIcons.successalert
      );
      fetchDataFromFirebase(database, user);
    });
  }

  void deleteChildFromDatabase(FirebaseDatabase database, User user, Weight weight) {
    database.reference().child(user.uid + "/" + weight.uniqueId).remove().then((value) {
      EdgeAlert.show(context,
        backgroundColor: parseColor(EDITCOLOUR),
        description: WEIGHTREMOVED,
        icon: CustomIcons.successalert
      );
      fetchDataFromFirebase(database, user);
    });
  }

  void fetchDataFromFirebase(FirebaseDatabase database, User user) async {
    database.reference().child(user.uid).orderByChild("/weight").once().then((DataSnapshot dataSnapshot) {
      isDataFetched = true;
      listOfObjects.clear();
      if (dataSnapshot.value != null) {
        dataSource = Map<String, dynamic>.from(dataSnapshot.value);
        dataSnapshot.value.forEach((key, value) {
          value["weight"] = double.parse(value["weight"].toStringAsFixed(2));
          value["change"] = double.parse(value["change"].toStringAsFixed(2));
          Weight weightObject = Weight.fromJson(value);
          weightObject.uniqueId = key;
          listOfObjects.add(weightObject);
        });
        listOfObjects.sort((a, b) {
          return b.timestamp.compareTo(a.timestamp);
        });
      }
      try {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      } catch (error) {
        print(error);
      }
      setState(() {});
    });
  }

  void updateDataInFirebase(FirebaseDatabase database, User user, int index) async {
    bool isUpdated = false;
    Weight weight = listOfObjects[index];
    if (weight.value != double.parse(_weightController.text)) isUpdated = true;
    database.reference().child(user.uid + "/" + weight.uniqueId + "/").update({
      "weight": double.parse(_weightController.text),
      "timestamp": weight.timestamp,
      "change": index == listOfObjects.length - 1
      ? 0.01
      : double.parse(_weightController.text) - listOfObjects[index + 1].value
    }).then((_) {
      if (index > 0) {
        Weight impactedWeight = listOfObjects[index - 1];
        database.reference().child(user.uid + "/" + impactedWeight.uniqueId + "/").update({
          "change": impactedWeight.value - double.parse(_weightController.text)
        }).then((value) {
          Navigator.pop(context);
          if (isUpdated) {
            EdgeAlert.show(context,
              backgroundColor: parseColor(EDITCOLOUR),
              description: WEIGHTUPDATED,
              icon: CustomIcons.successalert
            );
          }
          fetchDataFromFirebase(database, user);
        });
      } else {
        Navigator.pop(context);
        if (isUpdated) {
          EdgeAlert.show(context,
            backgroundColor: parseColor(EDITCOLOUR),
            description: WEIGHTUPDATED,
            icon: CustomIcons.successalert
          );
        }
        fetchDataFromFirebase(database, user);
      }
    });
  }

  Widget getPopUpScreenForEntry({int index}) {
    Weight weight;
    DateTime date;
    String formattedDate;
    if (index != null) {
      weight = listOfObjects[index];
      date = new DateTime.fromMillisecondsSinceEpoch(weight.timestamp);
      formattedDate = DateFormat.yMMMd().format(date);
    }
    String title = ADDWEIGHT;
    String leftButtonLabel = CANCEL;
    String rightButtonLabel = ADDENTRY;
    _weightController.clear();
    if (weight != null) {
      title = EDITWEIGHT;
      _weightController.text = weight.value.toString();
      leftButtonLabel = DELETE;
      rightButtonLabel = UPDATE;
    }
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 80,
              child: Center(
                child: Text(
                  title,
                  style: genericTextDecoration(colour: parseColor(TEXTCOLOUR), fontSize: 35),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: genericTextFieldDecoration(colour: Colors.transparent),
                  child: TextField(
                    controller: _weightController,
                    onChanged: (value) {},
                    textInputAction: TextInputAction.continueAction,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      new WhitelistingTextInputFormatter(RegExp("[0-9.]"))
                    ],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          "Assets/Images/weight.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                    style: TextStyle(color: parseColor(TEXTCOLOUR), fontSize: 25),
                  ),
                ),
              ),
            ),
            weight == null
              ? Container()
              : Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.5,
                        child: Text(
                          LASTUPDATEDON+": ",
                          style: genericTextDecoration(colour: Colors.white, fontSize: 16),
                        ),
                      ),
                      Opacity(
                        opacity: 0.75,
                        child: Text(
                          formattedDate,
                          style: genericTextDecoration(colour: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
            Container(
              height: 100,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (weight != null)
                          deleteChildFromDatabase(main.database, widget.user, weight);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 150,
                        decoration: weight == null
                          ? genericButtonDecoration(colour: parseColor(TEXTCOLOUR))
                          : genericButtonDecoration(colour: parseColor(DELETECOLOUR)),
                        child: Center(
                          child: Text(
                            leftButtonLabel,
                            style: genericTextDecoration(colour: Colors.white),
                          )
                        ),
                      )
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_weightController.text.trim() == "")
                          EdgeAlert.show(context,
                            backgroundColor: parseColor(DELETECOLOUR),
                            description: EMPTYWEIGHT,
                            icon: CustomIcons.erroralert
                          );
                        else {
                          if (weight == null)
                            addDataFromFirebase(main.database, widget.user, double.parse(_weightController.text));
                          else
                            updateDataInFirebase(main.database, widget.user, index);
                        }
                      },
                      child: Container(
                        width: 150,
                        decoration: weight == null
                          ? genericButtonDecoration()
                          : genericButtonDecoration(colour: parseColor(EDITCOLOUR)),
                        child: Center(
                          child: Text(
                            rightButtonLabel,
                            style: genericTextDecoration(colour: Colors.white),
                          )
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
        decoration: BoxDecoration(
          color: parseColor(FILLCOLOURLIGHT),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget getPopUpScreenForProfile() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          height: 175,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Opacity(
                  opacity: 0.75,
                  child: Text(
                    SIGNOUTCONFIRMATION,
                    style: genericTextDecoration(colour: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 33,
                      width: 100,
                      decoration: genericButtonDecoration(radius: 12),
                      child: Center(
                        child: Text(
                          NO,
                          style: genericTextDecoration(fontSize: 14, colour: Colors.white),
                        )
                      ),
                    )
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.isNewUser) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 33,
                      width: 100,
                      decoration: genericButtonDecoration(radius: 12),
                      child: Center(
                        child: Text(
                          YES,
                          style: genericTextDecoration(fontSize: 14, colour: Colors.white),
                        )
                      ),
                    )
                  ),
                ],
              )
            ],
          ),
          margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
          decoration: BoxDecoration(
            color: parseColor(FILLCOLOURLIGHT),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

Widget unitCellWidget(Weight weight) {
  String formattedTime = timeAgoFormat(weight.timestamp);
  return Container(
    height: 62,
    decoration: BoxDecoration(
      border: Border.all(width: 1, color: parseColor("535465")),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: parseColor("202038")
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                formattedTime,
                style: genericTextDecoration(colour: parseColor(TEXTCOLOUR), fontSize: 12),
              ),
              weight.change == 0.01 || weight.change == 0.0
                ? Text(
                    "",
                    style: genericTextDecoration(
                      colour: parseColor(PRIMARYCOLOUR),
                      fontSize: 17,
                      fontWeight: FontWeight.w400
                    ),
                  )
                : weight.change > 0.01
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "+ " + weight.change.abs().toString(),
                        style: genericTextDecoration(
                          colour: parseColor(DELETECOLOUR),
                          fontSize: 17,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      Text(
                        " Kg",
                        style: genericTextDecoration(
                          colour: parseColor(DELETECOLOUR),
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "- " + weight.change.abs().toString(),
                        style: genericTextDecoration(
                          colour: parseColor(EDITCOLOUR),
                          fontSize: 17,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      Text(
                        " Kg",
                        style: genericTextDecoration(
                          colour: parseColor(EDITCOLOUR),
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                weight.value.toString(),
                style: genericTextDecoration(colour: Colors.white, fontSize: 30),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 5),
                child: Text(
                  KILOGRAMS,
                  style: genericTextDecoration(colour: Colors.white, fontSize: 12),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
