import 'dart:convert';

QuizStartModel quizStartModelFromJson(String str) =>
    QuizStartModel.fromJson(json.decode(str));

String quizStartModelToJson(QuizStartModel data) => json.encode(data.toJson());

class QuizStartModel {
  QuizStartModel(
      {this.userId,
      this.courseId,
      this.quizId,
      this.quizType,
      this.startAt,
      this.endAt,
      this.duration = 0,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.mute = false});

  int? userId;
  String? courseId;
  int? quizId;
  String? quizType;
  DateTime? startAt;
  DateTime? endAt;
  int duration;
  DateTime? updatedAt;
  DateTime? createdAt;
  String? id;
  bool mute;

  factory QuizStartModel.fromJson(Map<String, dynamic> json) => QuizStartModel(
        userId: json["user_id"],
        courseId: json["course_id"],
        quizId: json["quiz_id"],
        quizType: json["quiz_type"],
        startAt: DateTime.parse(json["start_at"]),
        endAt: json["end_at"],
        duration: json["duration"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "course_id": courseId,
        "quiz_id": quizId,
        "quiz_type": quizType,
        "start_at": startAt?.toIso8601String(),
        "end_at": endAt,
        "duration": duration,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
