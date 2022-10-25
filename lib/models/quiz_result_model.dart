import 'dart:convert';

import 'package:stna_lms_flutter/models/gift_model.dart';
import 'package:stna_lms_flutter/utils/converter.dart';

QuizResultModel quizResultFromJson(String str) =>
    QuizResultModel.fromJson(json.decode(str));

class QuizResultModel {
  QuizResultModel(
      {this.quizResultId,
      this.isPass = false,
      this.totalQuestion = 0,
      this.numOfCorrect = 0,
      this.startDate,
      this.finishedDate,
      this.gift,
      this.isCompleted = false});

  int? quizResultId;
  bool isPass;
  int totalQuestion;
  int numOfCorrect;
  DateTime? startDate;
  DateTime? finishedDate;
  bool isCompleted;
  GiftModel? gift;

  factory QuizResultModel.fromJson(Map<String, dynamic> json) =>
      QuizResultModel(
          quizResultId: json['id'],
          isPass: dynamicToBoolean(json['attributes']['isPass']),
          totalQuestion: dynamicToInt(json['attributes']['totalQuestion']),
          numOfCorrect: dynamicToInt(json['attributes']['numOfCorrect']),
          startDate: dynamicToDateTime(json['attributes']['startDate']),
          finishedDate: dynamicToDateTime(json['attributes']['finishedDate']),
          isCompleted: dynamicToBoolean(json['attributes']['isCompleted']),
          gift: json['gift'] == null ? null : giftFromJsonMap(json['gift']));
}

class QuizResultViewModel {
  int? quizId;
  List<QuizQuestionResultModel>? questions;
  int numOfCorrect;
  int totalQuestion;
  bool isPass;

  QuizResultViewModel(
      {this.quizId,
      this.questions,
      this.numOfCorrect = 0,
      this.totalQuestion = 0,
      this.isPass = false});
}

class QuizQuestionResultModel {
  int? questionId;
  String? question;
  String? image;
  String? videoUrl;
  String? audio;
  String? video;
  bool isCorrect;
  List<QuizAnswerResultModel>? answers;

  QuizQuestionResultModel(
      {this.questionId,
      this.question,
      this.image,
      this.video,
      this.videoUrl,
      this.audio,
      this.isCorrect = false,
      this.answers});
}

class QuizAnswerResultModel {
  int? answerId;
  String? answer;
  String? reason;
  bool isSelected;
  bool isCorrect;

  QuizAnswerResultModel(
      {this.answer,
      this.answerId,
      this.reason,
      this.isSelected = false,
      this.isCorrect = false});
}
