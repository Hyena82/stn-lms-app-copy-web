import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

GiftModel giftFromJson(String str) => GiftModel.fromJson(json.decode(str));

GiftModel giftFromJsonMap(Map<String, dynamic> map) => GiftModel.fromJson(map);

class GiftModel {
  final int id;
  final String? image;
  final String? title;
  final String? content;
  final String? redirectUrl;
  final String? redirectPage;
  final int? redirectPageParameter;
  final DateTime? updatedAt;

  GiftModel(
      {this.id = 0,
      this.image,
      this.title,
      this.content,
      this.updatedAt,
      this.redirectPage,
      this.redirectPageParameter,
      this.redirectUrl});

  factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      content: json['content'],
      updatedAt: dynamicToDateTime(json['updatedAt']),
      redirectPage: json['redirectPage'],
      redirectUrl: json['redirectUrl'],
      redirectPageParameter: dynamicToInt(json['redirectPageParameter']));
}
