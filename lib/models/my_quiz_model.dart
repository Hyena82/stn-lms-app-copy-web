// To parse this JSON data, do
//
//     final myQuizResultsModel = myQuizResultsModelFromJson(jsonString);

import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

List<MyQuizModel> myQuizListFromJson(String str) =>
    List<MyQuizModel>.from(json.decode(str).map((x) => MyQuizModel.fromJson(x)))
        .toList();

MyQuizModel myQuizFromJson(String str) =>
    MyQuizModel.fromJson(json.decode(str));

class MyQuizModel {
  MyQuizModel(
      {this.quizId,
      this.name,
      this.description,
      this.duration = 0,
      this.cover,
      this.isCompleted = false,
      this.startDate,
      this.finishedDate,
      this.numOfCorrect = 0,
      this.totalQuestion = 0,
      this.isPass = false});

  int? quizId;
  String? name;
  String? description;
  int duration;
  String? cover;
  bool isCompleted;
  DateTime? startDate;
  DateTime? finishedDate;
  int numOfCorrect;
  int totalQuestion;
  bool isPass;

  factory MyQuizModel.fromJson(Map<String, dynamic> json) => MyQuizModel(
      quizId: json["quizId"],
      name: json["name"],
      description: json["description"],
      duration: dynamicToInt(json["duration"]),
      startDate: dynamicToDateTime(json["start_date"]),
      finishedDate: dynamicToDateTime(json["finished_date"]),
      isPass: dynamicToBoolean(json['is_pass']),
      numOfCorrect: dynamicToInt(json['num_of_correct']),
      totalQuestion: dynamicToInt(json['total_question']),
      cover: json["cover"]);
}
