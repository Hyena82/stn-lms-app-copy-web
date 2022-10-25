import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

List<PromoCodeModel> promoCodeListFromJson(String str) =>
    List<PromoCodeModel>.from(
        json.decode(str).map((x) => PromoCodeModel.fromJson(x))).toList();

PromoCodeModel promoCodeFromJson(String str) =>
    PromoCodeModel.fromJson(json.decode(str));

class PromoCodeChildModel {
  int? id;
  String? name;

  PromoCodeChildModel({this.id, this.name});

  factory PromoCodeChildModel.fromJson(Map<String, dynamic> json) =>
      PromoCodeChildModel(id: json["id"], name: json['name']);
}

class PromoCodeModel {
  PromoCodeModel(
      {this.id,
      this.code,
      this.expiredDate,
      this.combos,
      this.type,
      this.duration = 0,
      this.userId,
      this.usage,
      this.description,
      this.courses});

  int? id;
  String? code;
  DateTime? expiredDate;
  int duration;
  String? description;
  String? type;
  int? userId;
  int? usage;
  List<PromoCodeChildModel>? combos;
  List<PromoCodeChildModel>? courses;

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) => PromoCodeModel(
      id: json["id"],
      code: json['code'],
      description: json['description'],
      type: json['type'],
      duration: dynamicToInt(json['duration']),
      userId: json['userId'],
      usage: dynamicToInt(json['usage']),
      expiredDate: dynamicToDateTime(json['expiredDate']),
      combos: List<PromoCodeChildModel>.from(
          json["combos"].map((x) => PromoCodeChildModel.fromJson(x))),
      courses: List<PromoCodeChildModel>.from(
          json["courses"].map((x) => PromoCodeChildModel.fromJson(x))));
}
