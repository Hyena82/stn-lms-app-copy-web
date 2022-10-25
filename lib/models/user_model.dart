import 'dart:convert';

import 'package:stna_lms_flutter/utils/converter.dart';

List<UserModel> userListFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)))
        .toList();

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  UserModel(
      {this.id = 0,
      this.username,
      this.email,
      this.provider,
      this.confirmed = false,
      this.blocked = false,
      this.referralAlias,
      this.referBy,
      this.referralCode,
      this.phoneNumber,
      this.fullName,
      this.imageUrl,
      this.avatar,
      this.isPremium = false,
      this.membershipExpiredDate,
      this.createdAt,
      this.createAt,
      this.updatedAt});

  int id;
  String? username;
  String? email;
  String? provider;
  bool confirmed;
  bool blocked;
  String? referralCode;
  String? referBy;
  String? referralAlias;
  String? phoneNumber;
  DateTime? createdAt;
  DateTime? createAt;
  DateTime? updatedAt;
  DateTime? membershipExpiredDate;
  String? fullName;
  String? imageUrl;
  String? avatar;
  bool isPremium;

  bool get isVip {
    if (membershipExpiredDate == null) {
      return false;
    }

    return isPremium && DateTime.now().isBefore(membershipExpiredDate!);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: dynamicToInt(json["id"]),
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        blocked: dynamicToBoolean(json['blocked']),
        confirmed: dynamicToBoolean(json['confirmed']),
        referralCode: json['referralCode'],
        referBy: json['referBy'],
        referralAlias: json['referralAlias'],
        phoneNumber: json['phoneNumber'],
        fullName: json['fullName'],
        imageUrl: json['imageUrl'],
        avatar: json['avatar'],
        membershipExpiredDate: dynamicToDateTime(json['membershipExpiredDate']),
        isPremium: dynamicToBoolean(json['isPremium']),
        createdAt: dynamicToDateTime(json['createdAt']),
        createAt: dynamicToDateTime(json['createAt']),
        updatedAt: dynamicToDateTime(json['updatedAt']),
      );
}
