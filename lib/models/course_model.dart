import 'dart:convert';

import 'package:stna_lms_flutter/models/tag_model.dart';
import 'package:stna_lms_flutter/utils/converter.dart';

List<CourseModel> courseModelListFromJson(String str) =>
    List<CourseModel>.from(json.decode(str).map((x) => CourseModel.fromJson(x)))
        .toList();

CourseModel courseModelFromJson(String str) =>
    CourseModel.fromJson(json.decode(str));

class CourseModel {
  CourseModel(
      {this.id,
      this.name,
      this.level,
      this.brief,
      this.description,
      this.outcome,
      this.requirement,
      this.thumbnail,
      this.rating = 0.0,
      this.totalCompletePercentage = 0.0,
      this.totalCompletedLesson = 0,
      this.totalLesson = 0,
      this.totalDuration = 0.0,
      this.totalReviews = 0,
      this.totalEnrolled = 0,
      this.tags,
      this.lessonHistory,
      this.progress,
      this.price = 0.0,
      this.updateAt,
      this.userCourseExpiredDate,
      this.courseExpiredDate,
      this.isTrialCourse = false,
      this.hasFlow = false,
      this.enrolledDate,
      this.isEnrolled = false});

  int? id;
  String? name;
  String? level;
  String? description;
  String? outcome;
  String? requirement;
  String? brief;
  String? thumbnail;
  double rating;
  int totalReviews;
  int totalEnrolled;
  double totalDuration;
  bool isEnrolled;
  double totalCompletePercentage;
  int totalCompletedLesson;
  int totalLesson;
  List<LessonHistoryModel>? lessonHistory;
  List<LessonHistoryModel>? progress;
  List<TagModel>? tags;
  DateTime? enrolledDate;
  double price;
  DateTime? userCourseExpiredDate;
  DateTime? courseExpiredDate;
  bool hasFlow;
  bool isTrialCourse;
  DateTime? updateAt;

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
      id: json["id"],
      name: json["name"],
      brief: json["brief"],
      level: json["level"],
      description: json["description"],
      outcome: json["outcome"],
      requirement: json['requirement'],
      isTrialCourse: dynamicToBoolean(json['isTrialCourse']),
      hasFlow: dynamicToBoolean(json['hasFlow']),
      price: dynamicToDouble(json['price']),
      updateAt: dynamicToDateTime(json['updateAt']),
      thumbnail: json["thumbnail"],
      courseExpiredDate: dynamicToDateTime(json['courseExpiredDate']),
      userCourseExpiredDate: dynamicToDateTime(json['userCourseExpiredDate']),
      lessonHistory: json["lessonHistory"] == null
          ? []
          : List<LessonHistoryModel>.from(
              json["lessonHistory"].map((x) => LessonHistoryModel.fromJson(x))),
      progress: json["progress"] == null
          ? []
          : List<LessonHistoryModel>.from(
              json["progress"].map((x) => LessonHistoryModel.fromJson(x))),
      totalCompletePercentage: dynamicToDouble(json['totalCompletePercentage']),
      totalCompletedLesson: dynamicToInt(json['totalCompletedLesson']),
      totalLesson: dynamicToInt(json['totalLesson']),
      isEnrolled: dynamicToInt(json['isEnrolled']) == 1,
      rating: dynamicToDouble(json["rating"]),
      tags: json["tags"] == null
          ? []
          : List<TagModel>.from(json["tags"].map((x) => TagModel.fromJson(x))),
      enrolledDate: dynamicToDateTime(json['enrolledDate']),
      totalDuration: dynamicToDouble(json["totalDuration"]),
      totalReviews: dynamicToInt(json["totalReviews"]),
      totalEnrolled: dynamicToInt(json["totalEnrolled"]));
}

class LessonHistoryModel {
  LessonHistoryModel(
      {this.courseId,
      this.chapterContentName,
      this.chapterId,
      this.lessonId,
      this.lastCheckpoint,
      this.percent = 0,
      this.quizId,
      this.quizName,
      this.isCompleted = false,
      this.finishedDate,
      this.startDate,
      this.updatedAt});

  int? courseId;
  int? chapterId;
  int? lessonId;
  int? lastCheckpoint;
  DateTime? updatedAt;
  String? chapterContentName;
  int percent;

  // for quiz
  int? quizId;
  String? quizName;
  bool isCompleted;
  DateTime? finishedDate;
  DateTime? startDate;

  factory LessonHistoryModel.fromJson(Map<String, dynamic> json) =>
      LessonHistoryModel(
          // quiz
          quizId: dynamicToInt(json['quizId']),
          quizName: json['quizName'],
          isCompleted: dynamicToBoolean(json['isCompleted']),
          finishedDate: dynamicToDateTime(json['finishedDate']),
          startDate: dynamicToDateTime(json['startDate']),
          // course
          courseId: json["courseId"],
          chapterId: json["chapterId"],
          lessonId: json["lessonId"],
          lastCheckpoint: dynamicToInt(json["last_check_point"]),
          updatedAt: dynamicToDateTime(json["updated_at"]),
          chapterContentName: json["chapterContentName"],
          percent: dynamicToInt(json['percent']));
}

class CourseHistoryModel {
  final DateTime date;
  final LessonHistoryModel history;

  CourseHistoryModel({required this.date, required this.history});
}
