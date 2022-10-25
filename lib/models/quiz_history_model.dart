// To parse this JSON data, do
//
//     final myQuizResultsModel = myQuizResultsModelFromJson(jsonString);

import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

List<QuizHistoryModel> quizHistoryListFromJson(String str) =>
    List<QuizHistoryModel>.from(
        json.decode(str).map((x) => QuizHistoryModel.fromJson(x))).toList();

QuizHistoryModel quizHistoryFromJson(String str) =>
    QuizHistoryModel.fromJson(json.decode(str));

class QuizHistoryModel {
  QuizHistoryModel(
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

  factory QuizHistoryModel.fromJson(Map<String, dynamic> json) =>
      QuizHistoryModel(
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
