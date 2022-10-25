import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

List<QuizQuestionModel> quizQuestionListFromJson(String str) =>
    List<QuizQuestionModel>.from(
        json.decode(str).map((x) => QuizQuestionModel.fromJson(x))).toList();

QuizQuestionModel quizQuestionFromJson(String str) =>
    QuizQuestionModel.fromJson(json.decode(str));

class QuizQuestionModel {
  QuizQuestionModel(
      {this.questionId,
      this.quizId,
      this.question,
      this.image,
      this.videoUrl,
      this.audio,
      this.video,
      this.showGrid = false,
      this.answers});

  int? quizId;
  int? questionId;
  String? question;
  String? image;
  String? videoUrl;
  String? audio;
  String? video;
  List<QuizQuestionAnswerModel>? answers;
  bool showGrid;

  bool get isValidQuestion {
    return answers != null && answers!.isNotEmpty;
  }

  bool get isSingleChoice {
    if (answers == null) {
      return true;
    }

    var correctAnswers = answers!.where((element) => element.isCorrect);

    if (correctAnswers.length > 1) {
      return false;
    }

    return true;
  }

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) =>
      QuizQuestionModel(
        quizId: json["quizId"],
        questionId: json['questionId'],
        question: json["question"],
        image: json["image"],
        videoUrl: json["videoUrl"],
        audio: json["audio"],
        showGrid: dynamicToBoolean(json['showGrid']),
        video: json["video"],
        answers: List<QuizQuestionAnswerModel>.from(
            json["answers"].map((x) => QuizQuestionAnswerModel.fromJson(x))),
      );
}

class QuizQuestionAnswerModel {
  QuizQuestionAnswerModel(
      {this.answer, this.answerId, this.isCorrect = false, this.reason});

  int? answerId;
  String? answer;
  bool isCorrect;
  String? reason;

  factory QuizQuestionAnswerModel.fromJson(Map<String, dynamic> json) =>
      QuizQuestionAnswerModel(
          answerId: json['answerId'],
          answer: json['answer'],
          isCorrect: dynamicToBoolean(json['isCorrect']),
          reason: json['reason']);
}
