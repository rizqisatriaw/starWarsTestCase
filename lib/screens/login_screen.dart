import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starwarsapp/assets/colors.dart' as color;
import 'package:starwarsapp/firebase/authentication.dart';
import 'package:starwarsapp/models/user_model.dart';
import 'package:starwarsapp/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  color.Colors newColor = new color.Colors();

  Future<void> saveUserData(User userData) async {
    final SharedPreferences prefs = await _prefs;
    NewUserModel newData = new NewUserModel();
    newData.displayName = userData.displayName;
    newData.email = userData.email;
    newData.photoUrl = userData.photoURL;

    prefs.setString("displayName", newData.displayName).then((bool success) {
      if (success) {
        print("Success");
      }
    });
    prefs.setString("email", newData.email);
    prefs.setString("photoUrl", newData.photoUrl);
    prefs.setBool("was_login", true);
  }

  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: newColor.blackBackground,
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        "assets/images/starw.png",
                        width: 345,
                        height: 336,
                      ),
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 50),
                            child: FlatButton(
                              onPressed: () async {
                                Authentication service = new Authentication();
                                print("clicked");
                                try {
                                  User user = await service.signInWithGoogle(
                                      context: context);
                                  if (user != null) {
                                    saveUserData(user);

                                    //  Navigator.pushNamedAndRemoveUntil(context, Constants.homeNavigate, (route) => false);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainScreen()));
                                  }
                                } catch (e) {
                                  if (e is FirebaseAuthException) {
                                    print(e);
                                  }
                                }
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 70,
                                height: MediaQuery.of(context).size.width / 7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: newColor.primaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    "LOG IN",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )));
  }
}
