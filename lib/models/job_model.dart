// To parse this JSON data, do
//
//     final job = jobFromJson(jsonString);

import 'dart:convert';

import 'dart:io';

List<Job> jobFromJson(String str) => List<Job>.from(json.decode(str).map((x) => Job.fromJson(x)));

String jobToJson(List<Job> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Job {
  Job({
    this.idAI,
    this.company,
    this.description,
    this.employmentType,
    this.id,
    this.location,
    this.position,
    this.skillsRequired,
  });
  int idAI;
  String company;
  String description;
  String employmentType;
  int id;
  String location;
  String position;
  List<String> skillsRequired;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    idAI: json["idAI"],
    company: json["company"],
    description: json["description"],
    employmentType: json["employmentType"],
    id: json["id"],
    location: json["location"],
    position: json["position"],
    skillsRequired: List<String>.from(json["skillsRequired"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "idAI": idAI,
    "company": company,
    "description": description,
    "employmentType": employmentType,
    "id": id,
    "location": location,
    "position": position,
    "skillsRequired": jsonEncode(skillsRequired),
  };
}
