import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

QuizResultUserModel quizResultUserFromJson(String str) =>
    QuizResultUserModel.fromJson(json.decode(str));

class QuizResultUserModel {
  QuizResultUserModel(
      {this.userQuizResultId = 0, this.quizId = 0, this.details});

  int userQuizResultId;
  int quizId;
  List<QuizResultUserDetailModel>? details;

  factory QuizResultUserModel.fromJson(Map<String, dynamic> json) =>
      QuizResultUserModel(
          details:
              quizResultUserDetailListFromJson(jsonEncode(json["details"])),
          userQuizResultId: dynamicToInt(json['user_quiz_result']),
          quizId: dynamicToInt(json['quiz_id']));

  Map<String, dynamic> toJson() => {
        "user_quiz_result": userQuizResultId,
        "quiz_id": quizId,
        "details": details
      };
}

List<QuizResultUserDetailModel> quizResultUserDetailListFromJson(String str) =>
    List<QuizResultUserDetailModel>.from(
            json.decode(str).map((x) => QuizResultUserDetailModel.fromJson(x)))
        .toList();

QuizResultUserDetailModel quizResultUserDetailFromJson(String str) =>
    QuizResultUserDetailModel.fromJson(json.decode(str));

class QuizResultUserDetailModel {
  QuizResultUserDetailModel({this.questionId = 0, required this.answerId});

  int questionId;
  List<int> answerId;

  factory QuizResultUserDetailModel.fromJson(Map<String, dynamic> json) =>
      QuizResultUserDetailModel(
          questionId: dynamicToInt(json['questionId']),
          answerId: json['answerId']);

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "answerId": answerId,
      };
}
