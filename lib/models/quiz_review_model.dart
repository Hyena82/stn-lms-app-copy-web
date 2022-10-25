import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

List<QuizReviewModel> quizReviewListFromJson(String str) =>
    List<QuizReviewModel>.from(
        json.decode(str).map((x) => QuizReviewModel.fromJson(x))).toList();

QuizReviewModel quizReviewFromJson(String str) =>
    QuizReviewModel.fromJson(json.decode(str));

class QuizReviewModel {
  QuizReviewModel(
      {this.id,
      this.comment,
      this.rating = 0.0,
      this.userId,
      this.fullName,
      this.userAvatar,
      this.createdAt});

  int? id;
  String? comment;
  double rating;
  int? userId;
  String? fullName;
  String? userAvatar;
  DateTime? createdAt;

  factory QuizReviewModel.fromJson(Map<String, dynamic> json) =>
      QuizReviewModel(
          id: json["id"],
          comment: json["comment"],
          userId: dynamicToInt(json["userId"]),
          fullName: json["fullName"],
          userAvatar: json["userAvatar"],
          createdAt: dynamicToDateTime(json["createdAt"]),
          rating: dynamicToDouble(json["rating"]));
}
