import 'dart:convert';

class Result {
  Result({
    this.idAI,
    this.name,
    this.height,
    this.mass,
    this.hairColor,
    this.skinColor,
    this.eyeColor,
    this.birthYear,
    this.gender,
    this.homeworld,
    this.films,
    this.species,
    this.vehicles,
    this.starships,
    this.created,
    this.edited,
    this.url,
    this.saved
  });
  int idAI;
  String name;
  String height;
  String mass;
  String hairColor;
  String skinColor;
  String eyeColor;
  String birthYear;
  String gender;
  String homeworld;
  List<String> films;
  List<String> species;
  List<String> vehicles;
  List<String> starships;
  String created;
  String edited;
  String url;
  String saved;


  //
  factory Result.fromJson(Map<String, dynamic> json) => Result(
    idAI: json["idAI"],
    name: json["name"],
    height: json["height"],
    mass: json["mass"],
    hairColor: json["hair_color"],
    skinColor: json["skin_color"],
    eyeColor: json["eye_color"],
    birthYear: json["birth_year"],
    gender: json["gender"],
    homeworld: json["homeworld"],
    films: List<String>.from(jsonDecode(json["films"]).map((x) => x)),
    species: List<String>.from(jsonDecode(json["species"]).map((x) => x)),
    vehicles: List<String>.from(jsonDecode(json["vehicles"]).map((x) => x)),
    starships: List<String>.from(jsonDecode(json["starships"]).map((x) => x)),
    created: json["created"],
    edited: json["edited"],
    url: json["url"],
    saved: json["saved"]
  );

  Map<String, dynamic> toJson() => {
    "idAI": idAI,
    "name": name,
    "height": height,
    "mass": mass,
    "hair_color": hairColor,
    "skin_color": skinColor,
    "eye_color": eyeColor,
    "birth_year": birthYear,
    "gender": gender,
    "homeworld": homeworld,
    "films": jsonEncode(films),
    "species": jsonEncode(species),
    "vehicles": jsonEncode(vehicles),
    "starships": jsonEncode(starships),
    "created": created,
    "edited": edited,
    "url": url,
    "saved": saved
  };
}
