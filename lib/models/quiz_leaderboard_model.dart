import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

QuizLeaderboardModel quizLeaderboardFromJson(String str) =>
    QuizLeaderboardModel.fromJson(json.decode(str));

class QuizLeaderboardModel {
  QuizLeaderboardModel({this.ranks, this.currentUser});

  List<QuizLeaderboardRankerModel>? ranks;
  QuizLeaderboardRankerModel? currentUser;

  factory QuizLeaderboardModel.fromJson(Map<String, dynamic> json) =>
      QuizLeaderboardModel(
        currentUser: QuizLeaderboardRankerModel.fromJson(json["currentUser"]),
        ranks: List<QuizLeaderboardRankerModel>.from(
            json["ranks"].map((x) => QuizLeaderboardRankerModel.fromJson(x))),
      );
}

class QuizLeaderboardRankerModel {
  QuizLeaderboardRankerModel(
      {this.userId,
      this.avatar,
      this.fullName,
      this.numOfCorrect = 0,
      this.startDate,
      this.finishedDate,
      this.totalQuestion = 0,
      this.isPass = false,
      this.duration = 0,
      this.score = 0,
      this.rankNo});

  int? userId;
  String? avatar;
  String? fullName;
  int numOfCorrect;
  DateTime? startDate;
  DateTime? finishedDate;
  int totalQuestion;
  bool isPass;
  int duration;
  int? rankNo;
  double score;

  factory QuizLeaderboardRankerModel.fromJson(Map<String, dynamic> json) =>
      QuizLeaderboardRankerModel(
          userId: json["userId"],
          avatar: json['avatar'],
          fullName: json["fullName"],
          numOfCorrect: dynamicToInt(json['numOfCorrect']),
          startDate: dynamicToDateTime(json['start_date']),
          finishedDate: dynamicToDateTime(json['finishedDate']),
          totalQuestion: dynamicToInt(json['totalQuestion']),
          isPass: dynamicToBoolean(json['isPass']),
          duration: dynamicToInt(json['duration']),
          score: (dynamicToInt(json['numOfCorrect']) /
                  dynamicToInt(json['totalQuestion'])) *
              100,
          rankNo: dynamicToInt(json['rankNo']));
}
