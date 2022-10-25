import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

List<CourseChapterModel> courseChapterListFromJson(String str) =>
    List<CourseChapterModel>.from(
        json.decode(str).map((x) => CourseChapterModel.fromJson(x))).toList();

CourseChapterModel courseChapterFromJson(String str) =>
    CourseChapterModel.fromJson(json.decode(str));

class CourseChapterModel {
  CourseChapterModel(
      {this.id, this.name, this.description, this.chapterContents});

  int? id;
  String? name;
  String? description;
  List<CourseChapterContentModel>? chapterContents;

  factory CourseChapterModel.fromJson(Map<String, dynamic> json) =>
      CourseChapterModel(
          id: json["id"],
          name: json["name"],
          description: json["description"],
          chapterContents: courseChapterContentListFromJson(
              jsonEncode(json["chapterContents"])));
}

List<CourseChapterContentModel> courseChapterContentListFromJson(String str) =>
    List<CourseChapterContentModel>.from(
            json.decode(str).map((x) => CourseChapterContentModel.fromJson(x)))
        .toList();

CourseChapterContentModel courseChapterContentFromJson(String str) =>
    CourseChapterContentModel.fromJson(json.decode(str));

class CourseChapterContentModel {
  CourseChapterContentModel(
      {this.id,
      this.name,
      this.type,
      this.quizId,
      this.lessonId,
      this.duration = 0,
      this.videoUrl,
      this.lessonVideoUrl,
      this.lessonAudioUrl,
      this.notes,
      this.updateAt,
      this.isLocked = true,
      this.isCompleted = false,
      this.description});

  int? id;
  String? name;
  String? type;
  int? quizId;
  int? lessonId;
  int duration;
  String? videoUrl;
  String? lessonVideoUrl;
  List<String>? lessonAudioUrl;
  String? notes;
  String? description;
  bool isLocked;
  bool isCompleted;
  DateTime? updateAt;
  String? uuid;

  factory CourseChapterContentModel.fromJson(Map<String, dynamic> json) =>
      CourseChapterContentModel(
          id: json["id"],
          name: json["name"],
          lessonId: json["lessonId"],
          quizId: json["quizId"],
          videoUrl: json['videoUrl'],
          lessonAudioUrl:
              List<String>.from((json["lessonAudioUrl"] ?? []).map((x) => x)),
          lessonVideoUrl: json["lessonVideoUrl"],
          notes: json["notes"],
          description: json["description"],
          type: json["type"],
          updateAt: dynamicToDateTime(json['updateAt']),
          isLocked: dynamicToBoolean(json["isLocked"]),
          isCompleted: dynamicToBoolean(json["isCompleted"]),
          duration: dynamicToInt(json["duration"]));
}

class ContentListItem {
  ContentListItem(
      {this.content,
      this.chapter,
      this.type,
      this.contentIsCompleted = false,
      this.contentIsLocked = false,
      this.contentIndex,
      this.chapterIndex});

  CourseChapterContentModel? content;
  CourseChapterModel? chapter;
  String? type;
  int? contentIndex;
  int? chapterIndex;
  bool contentIsLocked;
  bool contentIsCompleted;
}
