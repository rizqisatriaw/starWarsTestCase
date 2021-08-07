import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starwarsapp/assets/colors.dart' as color;
import 'package:starwarsapp/db/db_provider.dart';
import 'package:starwarsapp/firebase/authentication.dart';
import 'package:starwarsapp/models/user_model.dart';
import 'package:starwarsapp/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Authentication auth = new Authentication();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  NewUserModel user = new NewUserModel();
  DBProvider dbProvider = DBProvider.db;
  color.Colors newColor = new color.Colors();

  void logout() async {
    int result = await dbProvider.deleteAllPeoples();
    if (result > 0) {}
  }

  Future getUserData() async {
    final SharedPreferences prefs = await _prefs;
    String displayName = prefs.getString("displayName");
    String email = prefs.getString("email");
    String photoUrl = prefs.getString("photoUrl");
    // print(userData);
    // user = jsonDecode(userData);
    setState(() {
      user.email = email;
      user.photoUrl = photoUrl;
      user.displayName = displayName;
    });
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: newColor.blackBackground,
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 50,
              ),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Text(
                "Profile",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 100),
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                image: DecorationImage(
                  image: NetworkImage(user.photoUrl != null
                      ? user.photoUrl
                      : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              width: MediaQuery.of(context).size.width - 70,
              height: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        user.displayName != null ? user.displayName : "",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: newColor.primaryColor,
                              fontSize: 22,
                            ),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user.email != null ? user.email : "",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: newColor.primaryColor,
                              fontSize: 18,
                            ),
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                try {
                  auth.signOutFromGoogle();

                  final SharedPreferences prefs = await _prefs;
                  prefs.clear();
                  logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                } catch (e) {}
              },
              child: Container(
                margin: EdgeInsets.only(top: 50),
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.width / 8,
                // width: 200,
                // height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.redAccent,
                ),
                child: Text(
                  "Logout",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        )));
  }
}
