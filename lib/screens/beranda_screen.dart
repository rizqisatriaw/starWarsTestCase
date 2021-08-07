import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:starwarsapp/assets/colors.dart' as color;
import 'package:starwarsapp/db/db_provider.dart';
import 'package:starwarsapp/firebase/authentication.dart';
import 'package:starwarsapp/models/getpeople_model.dart' as get_people;
import 'package:starwarsapp/models/job_model.dart';
import 'package:starwarsapp/models/savedjob_model.dart';
import 'package:starwarsapp/models/savepeople_model.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({Key key}) : super(key: key);

  @override
  _BerandaScreenState createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  TextEditingController controller = new TextEditingController();
  DBProvider dbProvider = DBProvider.db;
  color.Colors newColor = new color.Colors();

  // };
  bool isGrid = false;
  bool sortAsc = false;

  void changeSort() {
    setState(() {
      isGrid = !isGrid;
    });
  }

  void addPeople(List<get_people.Result> job) async {
    List<Result> newListJob = new List<Result>();
    job.forEach((element) {
      Result newData = new Result(
        eyeColor: element.eyeColor,
        height: element.height,
        birthYear: element.birthYear,
        created: element.created,
        edited: element.edited,
        films: element.films,
        gender: element.gender,
        hairColor: element.hairColor,
        homeworld: element.hairColor,
        mass: element.mass,
        name: element.name,
        skinColor: element.skinColor,
        species: element.species,
        starships: element.starships,
        url: element.url,
        vehicles: element.vehicles,
        saved: "false",
      );
      newListJob.add(newData);
    });

    int result = await dbProvider.insertManyData(newListJob);
    print("wk");
    if (result > 0) {
      print("berhasil");
      getDataLocally();
      // customSnackBar(content: "Success Add Data");
    } else {
      getDataLocally();
      print("GAGAL");
    }
  }

  void addSaved(Result people) async {
    int result = await dbProvider.updateToSaved(people.idAI);
    if (result > 0) {
      print("berhasil");
      getDataLocally();
    } else {
      print("GAGAL");
    }
  }

  void deleteJob(Result object) async {
    int result = await dbProvider.updateToUnSaved(object.idAI);
    if (result > 0) {
      getDataLocally();
    }
  }

  static SnackBar customSnackBar({String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  void changeAscSort() {
    if (sortAsc) {
      listPeople.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else {
      listPeople.sort((a, b) {
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      });
    }
    setState(() {
      sortAsc = !sortAsc;
    });
  }

  List<Result> listPeople;

  Future<void> getDataLocally() async {
    List<Result> data = await dbProvider.getAllPeoples();
    setState(() {
      listPeople = data;
    });
    if (data.isEmpty || data.length == 0) {
      _fetchJobs();
    }
  }

  Future<void> _fetchJobs() async {
    final peopleListAPIUrl = 'https://swapi.dev/api/people/';
    final response = await http.get(Uri.parse(peopleListAPIUrl));
    print(response.toString());
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // get_people.GetPeople data = get_people.GetPeople();
      get_people.GetPeople data = get_people.GetPeople.fromJson(jsonResponse);
      // List<SavedJob> savedJob;
      // Result
      addPeople(data.results);
      return;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  List<Result> _searchResult = [];

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {
        // _searchResult = listPeople;
      });
      return;
    }

    listPeople.forEach((people) {
      if (people.name.toLowerCase().contains(text)) _searchResult.add(people);
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // getDataFromApi();
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
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50, left: 35),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: MediaQuery.of(context).size.width / 9,
                  decoration: BoxDecoration(
                      color: newColor.primaryColor,
                      borderRadius: BorderRadius.circular(18)),
                  child: TextField(
                    onChanged: onSearchTextChanged,
                    controller: controller,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        fontWeight: FontWeight.normal),
                    decoration: InputDecoration.collapsed(
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: "Search",
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    changeSort();
                  },
                  hoverColor: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Image.asset(
                      isGrid
                          ? "assets/images/kotak.png"
                          : "assets/images/list.png",
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 15,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    changeAscSort();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Image.asset(
                      !sortAsc
                          ? "assets/images/sort.png"
                          : "assets/images/sort1.png",
                      width: MediaQuery.of(context).size.width / 15,
                      height: MediaQuery.of(context).size.width / 15,
                    ),
                  ),
                ),
              ],
            ),
            listPeople != null
                ? isGrid
                    ? _searchResult.length != 0 || controller.text.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResult.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return cardLong(_searchResult.elementAt(index));
                            },
                          )
                        : ListView.builder(
                            itemCount: listPeople.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return cardLong(listPeople.elementAt(index));
                            },
                          )
                    : _searchResult.length != 0 || controller.text.isNotEmpty
                        ? GridView.count(
                            childAspectRatio: 1.25,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            children: List.generate(
                              _searchResult.length,
                              (index) {
                                return cardShort(
                                    _searchResult.elementAt(index));
                              },
                            ),
                          )
                        : GridView.count(
                            childAspectRatio: 1.25,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 30),
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            children: List.generate(
                              listPeople.length,
                              (index) {
                                return cardShort(listPeople.elementAt(index));
                              },
                            ),
                          )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget cardShort(Result object) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 2.3,
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  object.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: newColor.primaryColor,
                        fontSize: 20,
                      ),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  object.gender,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: newColor.primaryColor,
                        fontSize: 12,
                      ),
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                object.saved == "true"
                    ? _showMyDialog(object)
                    : addSaved(object);
              },
              child: Image.asset(
                object.saved == "true"
                    ? "assets/images/like1.png"
                    : "assets/images/unlike.png",
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.width / 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardLong(Result people) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      width: MediaQuery.of(context).size.width - 10,
      padding: EdgeInsets.symmetric(horizontal: 20),
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
                people.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: newColor.primaryColor,
                      fontSize: 22,
                    ),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                people.gender,
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
              people.saved == "true" ? _showMyDialog(people) : addSaved(people);
            },
            child: Image.asset(
              people.saved == "true"
                  ? "assets/images/like1.png"
                  : "assets/images/unlike.png",
              width: MediaQuery.of(context).size.width / 5,
              height: MediaQuery.of(context).size.width / 15,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(Result object) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Data Dari Favorit?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Apakah anda yakin untuk menghapus data dari favorit?'),
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

  void logg(String a) {
    print(a);
  }
}
