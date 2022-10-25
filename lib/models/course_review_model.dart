import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

List<CourseReviewModel> courseReviewListFromJson(String str) =>
    List<CourseReviewModel>.from(
        json.decode(str).map((x) => CourseReviewModel.fromJson(x))).toList();

CourseReviewModel courseReviewFromJson(String str) =>
    CourseReviewModel.fromJson(json.decode(str));

class CourseReviewModel {
  CourseReviewModel(
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

  factory CourseReviewModel.fromJson(Map<String, dynamic> json) =>
      CourseReviewModel(
          id: json["id"],
          comment: json["comment"],
          userId: dynamicToInt(json["userId"]),
          fullName: json["fullName"],
          userAvatar: json["userAvatar"],
          createdAt: dynamicToDateTime(json["createdAt"]),
          rating: dynamicToDouble(json["rating"]));
}
