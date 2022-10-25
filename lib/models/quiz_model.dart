import 'dart:convert';

import 'package:stna_lms_flutter/models/tag_model.dart';
import 'package:stna_lms_flutter/utils/converter.dart';

List<QuizModel> quizModelListFromJson(String str) =>
    List<QuizModel>.from(json.decode(str).map((x) => QuizModel.fromJson(x)))
        .toList();

QuizModel quizModelFromJson(String str) => QuizModel.fromJson(json.decode(str));

class QuizModel {
  QuizModel(
      {this.id,
      this.name,
      this.passPercent = 0.0,
      this.description,
      this.duration = 0,
      this.totalQuestion = 0,
      this.level,
      this.outcome,
      this.requirement,
      this.createdBy,
      this.thumbnail,
      this.rating = 0.0,
      this.totalCompletePercentage = 0.0,
      this.totalReviews = 0,
      this.totalEnrolled = 0,
      this.lessonHistory,
      this.brief,
      this.updateAt,
      this.tags,
      this.cover,
      this.userProgress,
      this.showAnswerOnSelect = false,
      this.isSurvey = false,
      this.isEnrolled = false});

  int? id; // quizId
  String? name; // quizName
  int duration; // duration
  double passPercent; // passPercent
  String? description; // description
  int totalQuestion; // waiting
  String? level;
  String? outcome;
  String? requirement;
  String? createdBy;
  String? thumbnail;
  double rating;
  int totalReviews;
  int totalEnrolled;
  String? brief;
  DateTime? updateAt;
  List<TagModel>? tags;
  bool isEnrolled;
  double totalCompletePercentage;
  List<dynamic>? lessonHistory;
  List<dynamic>? userProgress;
  String? cover;
  bool isSurvey;
  bool showAnswerOnSelect;

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
      id: json["quizId"],
      name: json["quizName"],
      description: json["description"],
      duration: dynamicToInt(json["duration"]),
      passPercent: dynamicToDouble(json['passPercent']),
      totalQuestion: dynamicToInt(json["totalQuestion"]),
      isSurvey: dynamicToBoolean(json['isSurvey']),
      showAnswerOnSelect: dynamicToBoolean(json['showAnswerOnSelect']),
      level: json["level"],
      outcome: json["outcome"],
      requirement: json['requirement'],
      createdBy: json["createdBy"],
      thumbnail: json["thumbnail"],
      lessonHistory: [],
      userProgress: [],
      brief: json['brief'],
      cover: json['cover'],
      updateAt: dynamicToDateTime(json['updateAt']),
      totalCompletePercentage: dynamicToDouble(json['totalCompletePercentage']),
      isEnrolled: dynamicToInt(json['isEnrolled']) == 1,
      rating: dynamicToDouble(json["rating"]),
      tags: json["tags"] == null
          ? []
          : List<TagModel>.from(json["tags"].map((x) => TagModel.fromJson(x))),
      totalReviews: dynamicToInt(json["totalReviews"]),
      totalEnrolled: dynamicToInt(json["totalEnrolled"]));
}
