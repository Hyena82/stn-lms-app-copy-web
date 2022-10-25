import 'dart:convert';

List<TagModel> tagListFromJson(String str) =>
    List<TagModel>.from(json.decode(str).map((x) => TagModel.fromJson(x)))
        .toList();

TagModel tagFromJson(String str) => TagModel.fromJson(json.decode(str));

class TagModel {
  String slug;
  String name;

  TagModel({required this.slug, required this.name});

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
        slug: json["slug"],
        name: json["name"],
      );
}
