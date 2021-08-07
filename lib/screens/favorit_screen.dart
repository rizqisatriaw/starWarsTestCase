import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:starwarsapp/assets/colors.dart' as color;
import 'package:starwarsapp/db/db_provider.dart';
import 'package:starwarsapp/models/job_model.dart';
import 'package:starwarsapp/models/savedjob_model.dart';
import 'package:starwarsapp/models/savepeople_model.dart';

class FavoritScreen extends StatefulWidget {
  const FavoritScreen({Key key}) : super(key: key);

  @override
  _FavoritScreenState createState() => _FavoritScreenState();
}

class _FavoritScreenState extends State<FavoritScreen> {
  List<Result> data = new List<Result>();
  DBProvider dbProvider = DBProvider.db;
  color.Colors newColor = new color.Colors();

  void deleteJob(Result object) async {
    int result = await dbProvider.updateToUnSaved(object.idAI);
    if (result > 0) {
      getDataLocally();
    }
  }

  void getDataLocally() async {
    final Future<Database> dbFuture = dbProvider.initDB();
    dbFuture.then((database) {
      Future<List<Result>> contactListFuture = dbProvider.getSavedData();
      contactListFuture.then((contactList) {
        setState(() {
          this.data = contactList;
          // this.count = contactList.length;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataLocally();
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
                "Favorit",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                    fontWeight: FontWeight.bold),
              ),
            ),
            data != null
                ? ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                        width: MediaQuery.of(context).size.width / 10,
                        padding: EdgeInsets.only(left: 20),
                        height: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.elementAt(index).name,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: newColor.primaryColor,
                                        fontSize: 22,
                                      ),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data.elementAt(index).gender,
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
                            InkWell(
                              onTap: () {
                                _showMyDialog(data.elementAt(index));
                              },
                              child: Image.asset(
                                "assets/images/remove.png",
                                width: MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.width / 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(Result object) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Data?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Apakah anda yakin untuk menghapus data?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ya'),
              onPressed: () {
                deleteJob(object);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
