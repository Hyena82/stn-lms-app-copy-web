import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

List<DictionaryModel> dictionaryListFromJson(String str) =>
    List<DictionaryModel>.from(
        json.decode(str).map((x) => DictionaryModel.fromJson(x))).toList();

DictionaryModel dictionaryFromJson(String str) =>
    DictionaryModel.fromJson(json.decode(str));

class DictionaryModel {
  int? id;
  String? description;
  String? name;
  String? cover;
  DateTime? updatedAt;

  DictionaryModel(
      {this.id, this.description, this.name, this.cover, this.updatedAt});

  factory DictionaryModel.fromJson(Map<String, dynamic> json) =>
      DictionaryModel(
          id: json['id'],
          name: json['name'],
          description: json['description'],
          updatedAt: dynamicToDateTime(json['updatedAt']),
          cover: json['cover']);
}

List<DictionaryWordModel> wordListFromJson(String str) =>
    List<DictionaryWordModel>.from(
        json.decode(str).map((x) => DictionaryWordModel.fromJson(x))).toList();

DictionaryWordModel wordFromJson(String str) =>
    DictionaryWordModel.fromJson(json.decode(str));

class DictionaryWordModel {
  int? id;
  String? word;
  String? pronunciation;
  String? meaning;
  bool isFavorite;
  DateTime? updatedAt;
  List<DictionaryWordExampleModel>? examples;
  int? orderNumber;
  String? image;
  String? pronunciationAudio;
  List<String>? wordTypes;

  DictionaryWordModel(
      {this.id,
      this.word,
      this.isFavorite = false,
      this.pronunciation,
      this.updatedAt,
      this.orderNumber,
      this.wordTypes,
      this.pronunciationAudio,
      this.image,
      this.meaning,
      this.examples});

  factory DictionaryWordModel.fromJson(Map<String, dynamic> jsonStr) =>
      DictionaryWordModel(
          id: jsonStr["id"],
          word: jsonStr['word'],
          meaning: jsonStr['meaning'],
          orderNumber: dynamicToInt(jsonStr['orderNumber']),
          pronunciation: jsonStr['pronunciation'],
          pronunciationAudio: jsonStr['pronunciationAudio'],
          wordTypes:
              List<String>.from((jsonStr["wordTypes"] ?? []).map((x) => x)),
          image: jsonStr['image'],
          isFavorite: dynamicToBoolean(jsonStr['isFavorite']),
          updatedAt: dynamicToDateTime(jsonStr['updatedAt']),
          examples: jsonStr["examples"] == null
              ? []
              : List<DictionaryWordExampleModel>.from(jsonStr["examples"]
                  .map((x) => DictionaryWordExampleModel.fromJson(x))));
}

class DictionaryWordExampleModel {
  int? id;
  String? example;
  String? hint;

  DictionaryWordExampleModel({this.id, this.example, this.hint});

  factory DictionaryWordExampleModel.fromJson(Map<String, dynamic> json) =>
      DictionaryWordExampleModel(
        id: json["id"],
        example: json["example"],
        hint: json["hint"],
      );
}
