// To parse this JSON data, do
//
//     final job = jobFromJson(jsonString);

import 'dart:convert';

import 'dart:io';

List<SavedJob> savedjobFromJson(String str) =>
    List<SavedJob>.from(json.decode(str).map((x) => SavedJob.fromJson(x)));

String savedjobToJson(List<SavedJob> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SavedJob {
  SavedJob(
      {this.idAI,
      this.company,
      this.description,
      this.employmentType,
      this.id,
      this.location,
      this.position,
      this.skillsRequired,
      this.saved});
  int idAI;
  String company;
  String description;
  String employmentType;
  int id;
  String location;
  String position;
  List<String> skillsRequired;
  String saved;

  factory SavedJob.fromJson(Map<String, dynamic> json) => SavedJob(
      idAI: json["idAI"],
      company: json["company"],
      description: json["description"],
      employmentType: json["employmentType"],
      id: json["id"],
      location: json["location"],
      position: json["position"],
      skillsRequired:
          List<String>.from(jsonDecode(json["skillsRequired"]).map((x) => x)),
      saved: json["saved"]);

  Map<String, dynamic> toJson() => {
        "idAI": idAI,
        "company": company,
        "description": description,
        "employmentType": employmentType,
        "id": id,
        "location": location,
        "position": position,
        "skillsRequired": jsonEncode(skillsRequired),
        "saved": saved
      };
}
