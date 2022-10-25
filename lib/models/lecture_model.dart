import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

LectureModel lectureFromJson(String str) =>
    LectureModel.fromJson(json.decode(str));

class LectureModel {
  LectureModel(
      {this.id,
      this.name,
      this.duration = 0,
      this.youtubeUrl,
      this.video,
      this.audios,
      this.updateAt,
      this.brief,
      this.notes,
      this.images,
      this.description});

  int? id;
  String? name;
  int duration;
  String? youtubeUrl;
  String? video;
  List<String>? audios;
  String? notes;
  String? description;
  List<String>? images;
  DateTime? updateAt;
  String? brief;

  factory LectureModel.fromJson(Map<String, dynamic> json) => LectureModel(
      id: json["id"],
      name: json["name"],
      duration: dynamicToInt(json["duration"]),
      youtubeUrl: json["videoUrl"],
      video: json["video"],
      audios: json["audio"] != null
          ? List<String>.from((json["audio"] ?? []).map((x) => x))
          : null,
      notes: json["notes"],
      updateAt: dynamicToDateTime(json["updateAt"]),
      brief: json["brief"],
      images: List<String>.from((json["images"] ?? []).map((x) => x)));
}
