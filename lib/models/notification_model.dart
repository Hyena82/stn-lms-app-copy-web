import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

List<NotificationModel> notificationModelListFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x))).toList();

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

class NotificationModel {
  int? id;
  String? title;
  String? message;
  String? link;
  int? linkParameter;
  int? userId;
  String? content;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool isRead;
  bool isDeleted;

  NotificationModel(
      {this.id,
      this.title,
      this.message,
      this.link,
      this.linkParameter,
      this.userId,
      this.isRead = false,
      this.isDeleted = false,
      this.content,
      this.image,
      this.updatedAt,
      this.createdAt});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
          id: json['id'],
          title: json['title'],
          message: json['message'],
          link: json['link'],
          content: json['content'],
          image: json['image'],
          linkParameter: dynamicToInt(json['linkParameter']),
          userId: dynamicToInt(json['userId']),
          isRead: dynamicToBoolean(json['isRead']),
          isDeleted: dynamicToBoolean(json['isDeleted']),
          updatedAt: dynamicToDateTime(json['updatedAt']),
          createdAt: dynamicToDateTime(json['createdAt']));
}
