// To parse this JSON data, do
//
//     final topCategory = topCategoryFromJson(jsonString);

// Dart imports:
import 'dart:convert';

List<TopCategory> topCategoryFromJson(String str) =>
    List<TopCategory>.from(json.decode(str).map((x) => TopCategory.fromJson(x)))
        .where((element) => element.totalCourse != 0)
        .toList();

String topCategoryToJson(List<TopCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopCategory {
  TopCategory({this.id, this.name, this.totalCourse = 0});

  int? id;
  String? name;
  int totalCourse;

  factory TopCategory.fromJson(dynamic json) => TopCategory(
        id: json["id"],
        name: json["name"],
        totalCourse: int.parse(json["totalCourse"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "totalCourse": totalCourse,
      };
}
