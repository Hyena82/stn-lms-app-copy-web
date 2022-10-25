import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:stna_lms_flutter/utils/converter.dart';

SystemInformationModel systemInformationFromJson(String str) =>
    SystemInformationModel.fromJson(json.decode(str));

class SystemInformationModel {
  String? email;
  String? address;
  String? facebookID;
  String? phoneNumber;
  String? zaloID;
  String? paymentInstruction;
  String? adBanner;
  String? adLink;
  String? introduce;
  String? website;
  int? adLinkCourseId;
  String? paymentBanner;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool releaseMode;
  String? releaseVersionIos;
  String? releaseVersionAndroid;

  get isAndroid {
    return !kIsWeb && Platform.isAndroid;
  }

  get isIos {
    return !kIsWeb && Platform.isIOS;
  }

  get releaseVersion {
    return isAndroid ? releaseVersionAndroid : releaseVersionIos;
  }

  SystemInformationModel(
      {this.email,
      this.address,
      this.facebookID,
      this.phoneNumber,
      this.zaloID,
      this.releaseMode = false,
      this.releaseVersionIos,
      this.releaseVersionAndroid,
      this.paymentInstruction,
      this.paymentBanner,
      this.adBanner,
      this.adLink,
      this.website,
      this.adLinkCourseId,
      this.createdAt,
      this.updatedAt,
      this.introduce});

  factory SystemInformationModel.fromJson(Map<String, dynamic> json) =>
      SystemInformationModel(
          email: json['email'],
          address: json['address'],
          facebookID: json['facebook'],
          phoneNumber: json['phonenumber'],
          zaloID: json['zalo'],
          paymentInstruction: json['payment_instruction'],
          adBanner: json['ad_banner'],
          adLink: json['ad_link'],
          website: json['website'],
          introduce: json['Introduce'],
          adLinkCourseId: json['ad_link_course_id'],
          paymentBanner: json['payment_banner'],
          releaseVersionIos: json['releaseVersion'],
          releaseVersionAndroid: json['releaseVersionAndroid'],
          createdAt: dynamicToDateTime(json['createdAt']),
          updatedAt: dynamicToDateTime(json['updatedAt']));
}
