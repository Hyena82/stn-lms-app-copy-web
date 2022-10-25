// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
// Package imports:
// ignore: library_prefixes
import 'package:http/http.dart' as httpClient;
import 'package:http/http.dart';

import './base_api_service.dart';
import 'package:logger_console/logger_console.dart';
// Project imports:
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/models/course_chapter_model.dart';
import 'package:stna_lms_flutter/models/course_model.dart';
import 'package:stna_lms_flutter/models/course_review_model.dart';
import 'package:stna_lms_flutter/models/dictionary_model.dart';
import 'package:stna_lms_flutter/models/gift_model.dart';
import 'package:stna_lms_flutter/models/lecture_model.dart';
import 'package:stna_lms_flutter/models/my_quiz_model.dart';
import 'package:stna_lms_flutter/models/notification_model.dart';
import 'package:stna_lms_flutter/models/promo_code_model.dart';
import 'package:stna_lms_flutter/models/quiz_history_model.dart';
import 'package:stna_lms_flutter/models/quiz_leaderboard_model.dart';
import 'package:stna_lms_flutter/models/quiz_model.dart';
import 'package:stna_lms_flutter/models/quiz_question_model.dart';
import 'package:stna_lms_flutter/models/quiz_result_model.dart';
import 'package:stna_lms_flutter/models/quiz_result_user_model.dart';
import 'package:stna_lms_flutter/models/quiz_review_model.dart';
import 'package:stna_lms_flutter/models/system_information_model.dart';
import 'package:stna_lms_flutter/models/top_category_model.dart';
import 'package:stna_lms_flutter/models/user_model.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';

import 'package:jwt_decode/jwt_decode.dart' as jwt_decode;
import 'package:stna_lms_flutter/utils/converter.dart';

final LogHttpClient http = LogHttpClient(Client());

class APIService {
  static Future postLogActivity(String? token,
      {String? type,
      int? userId,
      int? relatedId,
      String? activity,
      String? keyword}) async {
    Uri url = Uri.parse('$baseUrl/activity-logs');

    int? userIdFromToken = _getUserIdFromToken(token);
    if (userIdFromToken != null) {
      Map data = {
        "type": type,
        "userId": userId ?? userIdFromToken,
        "relatedId": relatedId,
        "activity": activity,
        "keyword": keyword
      };

      var body = json.encode(data);
      http.post(url, headers: _getRequestHeaders(token), body: body);
    }
  }

  static Future<void> postMarkNotificationRead(String? token, int id) async {
    Uri url = Uri.parse('$baseUrl/notifications/$id/toggle-mark-as-read');
    http.post(url, headers: _getRequestHeaders(token));
  }

  static Future<void> postDeleteAllNotifications(String? token) async {
    Uri url = Uri.parse('$baseUrl/notifications/remove-notification');
    var response = await http.post(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      postLogActivity(token,
          type: 'delete_all_notifications',
          activity: 'người dùng xóa tất cả thông báo',
          relatedId: _getUserIdFromToken(token));
    }
  }

  static Future<GiftModel?> fetchGift(String? token, int id) async {
    Uri url = Uri.parse('$baseUrl/gifts/$id');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString);
      return giftFromJson(data);
    } else {
      return null;
    }
  }

  static Future<NotificationModel?> fetchNotification(
      String? token, int id) async {
    Uri url = Uri.parse('$baseUrl/notifications/$id');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString);
      return notificationModelFromJson(data);
    } else {
      return null;
    }
  }

  static Future<List<NotificationModel>?> fetchNotifications(
      String? token) async {
    Uri url = Uri.parse('$baseUrl/notifications');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString['data']);
      return notificationModelListFromJson(data);
    } else {
      return null;
    }
  }

  static Future<bool> postUploadAvatar(String? token, String filePath) async {
    Uri url = Uri.parse('$baseUrl/users/upload-avatar');
    var request = httpClient.MultipartRequest('POST', url);
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers[authHeader] = '$isBearer $token';

    request.files.add(httpClient.MultipartFile('files',
        File(filePath).readAsBytes().asStream(), File(filePath).lengthSync(),
        filename: filePath.split("/").last));
    var response = await request.send();

    if (response.statusCode == 200) {
      postLogActivity(token,
          type: 'upload_avatar',
          activity: 'người dùng thay đổi ảnh đại diện',
          relatedId: _getUserIdFromToken(token));
      return true;
    } else {
      return false;
    }
  }

  static Future<List<CourseModel>?> fetchProgressingCourse(
      String? token) async {
    Uri url = Uri.parse('$baseUrl/courses/inprogress');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString);
      return courseModelListFromJson(courseData);
    } else {
      return null;
    }
  }

  static Future<bool?> postVerifyDeviceToken(
      String userToken, String fcmToken, int userId) async {
    Uri url = Uri.parse('$baseUrl/user-devices');
    Map data = {"deviceToken": fcmToken, 'user_id': userId};

    var body = json.encode(data);
    var response = await http.post(url,
        headers: _getRequestHeaders(userToken), body: body);
    try {
      if (response.statusCode == 200) {
        var jsonString = jsonDecode(response.body);
        return jsonString['activity'] as bool;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> postToggleFavoriteWord(
      String? token, int wordId, int orderNumber) async {
    Uri url = Uri.parse('$baseUrl/words/favorite');
    Map data = {"word": wordId, "orderNumber": orderNumber};
    var body = json.encode(data);
    var response =
        await http.post(url, headers: _getRequestHeaders(token), body: body);

    if (response.statusCode == 200) {
      postLogActivity(token,
          type: 'toggle_favorite_word',
          activity: 'lưu/không lưu từ yêu thích',
          relatedId: wordId);

      return true;
    } else {
      return false;
    }
  }

  static Future<List<DictionaryWordModel>> fetchFavoriteWords(
    String? token, {
    String search = '',
    int page = 1,
    int pageSize = 25,
  }) async {
    Uri url = Uri.parse(
        '$baseUrl/words/favorite?search=$search&page=$page&pageSize=$pageSize');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString['data']);

      postLogActivity(token,
          activity: 'người dùng xem từ yêu thích', type: 'view_favorite_words');

      return wordListFromJson(data);
    } else {
      return [];
    }
  }

  static Future<List<DictionaryModel>?> fetchDictionary(String? token) async {
    Uri url = Uri.parse('$baseUrl/dictionaries');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString['data']);
      return dictionaryListFromJson(data);
    } else {
      return null;
    }
  }

  static Future<List<UserModel>> fetchReferrerList(
    String? token, {
    String? search,
    int page = 1,
    int pageSize = 25,
  }) async {
    Uri url = Uri.parse(
        '$baseUrl/users/profile/referred-users?search=${search ?? ''}&page=$page&pageSize=$pageSize');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString['data']);

      postLogActivity(token,
          type: 'search_referrer',
          activity: 'người dùng tìm kiếm người giới thiệu "$search"',
          keyword: search);

      return userListFromJson(data);
    } else {
      return [];
    }
  }

// TODO:
  static Future<List<DictionaryWordModel>> fetchDictionaryWords(
    String? token,
    int dictionaryID, {
    String? search,
    int page = 1,
    int pageSize = 25,
  }) async {
    Uri url = Uri.parse(
        '$baseUrl/dictionaries/$dictionaryID/words?search=$search&page=$page&pageSize=$pageSize');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString['data']);
      print('tu vung $jsonString');

      postLogActivity(token,
          type: 'search_word',
          activity: 'người dùng tìm kiếm từ "$search"',
          relatedId: dictionaryID,
          keyword: search);

      return wordListFromJson(data);
    } else {
      return [];
    }
  }

  static Future<bool> postApplyPromoCode(
      String? token, String promoCode) async {
    Uri url = Uri.parse('$baseUrl/promo-codes/applyPromoCode');
    Map data = {"code": promoCode};

    var body = json.encode(data);
    var response =
        await http.post(url, headers: _getRequestHeaders(token), body: body);

    postLogActivity(
      token,
      type: 'apply_promo_code',
      activity: 'người dùng kích hoạt mã "$promoCode"',
      keyword: promoCode,
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  static Future<PromoCodeModel?> postValidatePromoCode(
      String? token, String promoCode) async {
    Uri url = Uri.parse('$baseUrl/promo-codes/checkPromoCode');
    Map data = {"code": promoCode};

    var body = json.encode(data);
    var response =
        await http.post(url, headers: _getRequestHeaders(token), body: body);

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString);

      postLogActivity(token,
          type: 'validate_promo_code',
          activity: 'người dùng kiểm tra mã "$promoCode"',
          keyword: promoCode);

      return promoCodeFromJson(data);
    }

    return null;
  }

  static Future<List<TopCategory>?> fetchTopCategories(String? token) async {
    Uri url = Uri.parse('$baseUrl/categories/top');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString);
      return topCategoryFromJson(courseData);
    } else {
      return null;
    }
  }

  static Future<List<CourseModel>?> fetchPopularCourse(String? token) async {
    Uri url = Uri.parse('$baseUrl/courses/popular');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString);
      return courseModelListFromJson(courseData);
    } else {
      return null;
    }
  }

  static Future<List<CourseModel>?> fetchTrialCourse(String? token) async {
    Uri url = Uri.parse('$baseUrl/courses/trial');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString);
      return courseModelListFromJson(courseData);
    } else {
      return null;
    }
  }

  static Future<List<CourseModel>?> fetchLatestCourse(String? token) async {
    Uri url = Uri.parse('$baseUrl/courses/latest');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString);
      return courseModelListFromJson(courseData);
    } else {
      return null;
    }
  }

  // network call for All course list
  static Future<List<CourseModel>?> fetchAllCourse(
      String? token, String? search) async {
    Uri url;

    if (search != null) {
      url = Uri.parse('$baseUrl/courses?text=$search');
    } else {
      url = Uri.parse('$baseUrl/courses');
    }

    var response = await http.get(url, headers: _getRequestHeaders(token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString);

      postLogActivity(token,
          type: 'search_course',
          activity: 'người dùng tìm kiếm khóa học "$search"',
          keyword: search ?? '');

      return courseModelListFromJson(courseData);
    } else {
      return null;
    }
  }

  static Future<List<CourseModel>?> fetchCourseByCategory(
      String? token, int categoryId,
      {String? search}) async {
    var url = '$baseUrl/courses?category=$categoryId';
    if (search != null) {
      url = url + '&text=$search';
    }

    Uri uri = Uri.parse(url);

    var response = await http.get(uri, headers: _getRequestHeaders(token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString);

      postLogActivity(token,
          type: 'search_course_with_category',
          activity:
              'người dùng xem khóa học trong danh mục với từ khóa "$search"',
          keyword: search);

      return courseModelListFromJson(courseData);
    } else {
      return null;
    }
  }

  static Future<QuizLeaderboardModel?> fetchQuizLeaderboard(
      String? token, int quizId) async {
    Uri url = Uri.parse('$baseUrl/quizzes/detail/$quizId/rank');
    var response = await http.get(url, headers: _getRequestHeaders(token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString);

      postLogActivity(token,
          type: 'quiz_leaderboard',
          activity: 'người dùng xem bảng xếp hạng',
          relatedId: quizId);

      return quizLeaderboardFromJson(data);
    } else {
      return null;
    }
  }

  // network call for All course list
  static Future<List<CourseModel>?> fetchMyCourse(String? token) async {
    Uri url = Uri.parse('$baseUrl/courses/user-course');

    var response = await http.get(
      url,
      headers: _getRequestHeaders(token),
    );

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString);

      if (json.decode(courseData) != null) {
        postLogActivity(token,
            type: 'view_my_courses',
            activity: 'người dùng xem khóa học đã đăng ký');

        return courseModelListFromJson(courseData);
      } else {
        return null;
      }
    } else {
      //show error message
      return null;
    }
  }

  static Future postUpdateProfile(String? token,
      {String? email,
      String? phoneNumber,
      String? fullName,
      String? referralAlias}) async {
    Uri url = Uri.parse('$baseUrl/users/profile');
    Map data = {
      "email": email,
      "phoneNumber": phoneNumber,
      "fullName": fullName,
      "referralAlias": referralAlias
    };

    var body = json.encode(data);
    var response =
        await http.post(url, headers: _getRequestHeaders(token), body: body);
    var jsonString = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonString['error'] == null) {
      postLogActivity(token,
          type: 'update_profile',
          activity: 'người dùng thay đổi thông tin cá nhân');

      return jsonString;
    } else {
      return null;
    }
  }

  static Future login(email, password) async {
    Uri loginUrl = Uri.parse('$baseUrl/users/login');
    Map data = {
      "identifier": email.toString(),
      "password": password.toString()
    };

    var body = json.encode(data);
    var response =
        await http.post(loginUrl, headers: _getRequestHeaders(), body: body);
    var jsonString = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonString['error'] == null) {
      return jsonString;
    } else {
      return null;
    }
  }

  static Future<bool> postDeleteAccount(String? token) async {
    var url = Uri.parse('$baseUrl/users/profile');
    var data = {"blocked": true};
    var body = json.encode(data);
    var response =
        await http.post(url, headers: _getRequestHeaders(token), body: body);

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

// user login
  static Future requestForgotPassword(email) async {
    Uri url = Uri.parse('$baseUrl/users/forgot-password');
    Map data = {"email": email.toString()};

    var body = json.encode(data);
    var response =
        await http.post(url, headers: _getRequestHeaders(), body: body);

    var jsonString = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonString['error'] == null) {
      return jsonString;
    } else {
      return null;
    }
  }

  static Future<dynamic> changePassword({
    required String oldPassword,
    required String newPassword,
    required String token,
  }) async {
    Uri signUpUrl = Uri.parse('$baseUrl/users/change-password');

    Map data = {
      "old_password": oldPassword,
      "new_password": newPassword,
      "user_id": token,
    };

    var body = json.encode(data);
    var response = await http.post(signUpUrl,
        headers: _getRequestHeaders(token), body: body);
    var jsonString = jsonDecode(response.body);
    Console.log("changePassword::jsonString", jsonString);

    return jsonString;
  }

  static Future<dynamic> forgotPassword({
    required String phone,
    required String newPassword,
    required String token,
  }) async {
    Uri signUpUrl = Uri.parse('$baseUrl/users/forgot-password');

    Map data = {
      "phone": phone,
      "new_password": newPassword,
      "token": token,
    };

    var body = json.encode(data);
    var response =
        await http.post(signUpUrl, headers: _getRequestHeaders(), body: body);
    var jsonString = jsonDecode(response.body);

    return jsonString;
  }

  static Future<dynamic> register(
      {required String name,
      required String email,
      required String phone,
      required String password}) async {
    Uri signUpUrl = Uri.parse('$baseUrl/users/register');

    // build username
    var arr = email.split('@');
    var username = arr.isNotEmpty ? arr.first : email;

    Map data = {
      "fullName": name,
      "username": username,
      "email": email,
      "phoneNumber": phone,
      "password": password,
    };

    var body = json.encode(data);
    var response =
        await http.post(signUpUrl, headers: _getRequestHeaders(), body: body);
    var jsonString = jsonDecode(response.body);
    Console.log("register::jsonString", jsonString);

    if (response.statusCode == 200 && jsonString['error'] == null) {
      return jsonString;
    }

    if (jsonString['error']['message'] == 'You have not confirmed') {
      return jsonString;
    }

    if (jsonString['error']['message'] == 'Email is already taken') {
      AlertUtils.warn('Địa chỉ email đã được đăng ký');
    }

    return null;
  }

  static Future<dynamic> sendOtp({
    required String phone,
  }) async {
    Uri url = Uri.parse('$baseUrl/users/sendOTP');

    var body = json.encode({'phone': phone});
    var response =
        await http.post(url, headers: _getRequestHeaders(), body: body);
    var jsonString = jsonDecode(response.body);
    Console.log("sendOtp::jsonString", jsonString);

    if (response.statusCode == 200 && jsonString['error'] == null) {
      return jsonString;
    }

    return null;
  }

  static Future<dynamic> confirmOtp({
    required String otp,
    required String session,
  }) async {
    Uri url = Uri.parse('$baseUrl/users/confirm');

    var body = json.encode({'otp': otp, 'session': session});
    var response =
        await http.post(url, headers: _getRequestHeaders(), body: body);
    try {
      var jsonString = jsonDecode(response.body);
      Console.log("confirmOtp::jsonString", jsonString);

      if (response.statusCode == 200 && jsonString['error'] == null) {
        return jsonString;
      }
    } catch (error) {
      return null;
    }

    return null;
  }

  static Future<dynamic> logout({
    required String deviceToken,
  }) async {
    Uri url = Uri.parse('$baseUrl/user-devices/logout');

    var body = json.encode({'deviceToken': deviceToken});
    var response =
        await http.post(url, headers: _getRequestHeaders(), body: body);
    try {
      var jsonString = jsonDecode(response.body);
      Console.log("logout::jsonString", jsonString);

      if (response.statusCode == 200 && jsonString['error'] == null) {
        return jsonString;
      }
    } catch (error) {
      return null;
    }

    return null;
  }

  static Future<bool> enrollCourse(String? token, int courseID) async {
    var url = Uri.parse('$baseUrl/courses/enroll/$courseID');
    Map data = {};

    var body = json.encode(data);
    var response =
        await http.post(url, headers: _getRequestHeaders(token), body: body);
    if (response.statusCode == 200) {
      postLogActivity(token,
          type: 'enroll_course',
          activity: 'người dùng VIP đăng ký khóa học',
          relatedId: courseID);
      return true;
    } else {
      return false;
    }
  }

  static Future<SystemInformationModel?> fetchSystemInformations(
      String? token) async {
    Uri url = Uri.parse('$baseUrl/system-informations');
    var response = await http.get(url, headers: _getRequestHeaders(token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var metas = jsonEncode(jsonString);

      return systemInformationFromJson(metas);
    } else {
      return null;
    }
  }

  static Future<bool> postCourseProgress(String? token, int courseID) async {
    var url = Uri.parse('$baseUrl/user-lectures');
    Map data = {};

    var body = json.encode(data);
    var response =
        await http.post(url, headers: _getRequestHeaders(token), body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<CourseModel?> fetchCourseDetail(String? token, int id) async {
    Uri url = Uri.parse('$baseUrl/courses/detail/$id');
    var response = await http.get(url, headers: _getRequestHeaders(token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString);

      postLogActivity(token,
          type: 'view_course',
          activity: 'người dùng xem khóa học',
          relatedId: id);

      return courseModelFromJson(courseData);
    } else {
      return null;
    }
  }

  static Future<List<QuizReviewModel>?> fetchQuizReview(
      String? token, int id) async {
    Uri url = Uri.parse('$baseUrl/quizzes/detail/$id/reviews');
    var response = await http.get(url, headers: _getRequestHeaders(token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString['reviews']);

      postLogActivity(token,
          type: 'view_quiz_reviews',
          activity: 'người dùng xem đánh giá bài kiểm tra',
          relatedId: id);

      return quizReviewListFromJson(data);
    } else {
      return null;
    }
  }

  static Future<List<CourseReviewModel>?> fetchCourseReview(
      String? token, int id) async {
    Uri url = Uri.parse('$baseUrl/courses/detail/$id/reviews');
    var response = await http.get(url, headers: _getRequestHeaders(token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString['reviews']);

      postLogActivity(token,
          type: 'view_course_reviews',
          activity: 'người dùng xem đánh giá khóa học',
          relatedId: id);

      return courseReviewListFromJson(data);
    } else {
      return null;
    }
  }

  static Future<LectureModel?> fetchLectureDetail(String? token, int id) async {
    Uri url = Uri.parse('$baseUrl/lectures/$id');
    var response = await http.get(url, headers: _getRequestHeaders(token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString);

      postLogActivity(token,
          type: 'view_lecture',
          activity: 'người dùng xem bài học',
          relatedId: id);

      return lectureFromJson(data);
    } else {
      return null;
    }
  }

  static Future<List<CourseChapterModel>?> fetchCourseChapter(
      String? token, int id) async {
    Uri url = Uri.parse('$baseUrl/courses/detail/$id/syllabus');
    var response = await http.get(url, headers: _getRequestHeaders(token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString['chapters']);

      postLogActivity(token,
          type: 'view_course_content',
          activity: 'người dùng xem nội dung khóa học',
          relatedId: id);

      return courseChapterListFromJson(data);
    } else {
      return null;
    }
  }

  static Future<bool> submitReview(String? token, int relatedId, String type,
      double rating, String comment) async {
    var url = Uri.parse('$baseUrl/reviews');
    var data = {
      "rating": rating,
      "comment": comment,
      "type": type,
      "relatedId": relatedId
    };

    var body = json.encode(data);
    var response =
        await http.post(url, headers: _getRequestHeaders(token), body: body);

    if (response.statusCode == 200) {
      postLogActivity(token,
          type: 'submit_review',
          activity: 'người dùng đánh giá $type',
          relatedId: relatedId);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> submitCourseReview(
      String? token, int courseId, double rating, String comment) async {
    return submitReview(token, courseId, "course", rating, comment);
  }

  static Future<bool> submitQuizReview(
      String? token, int quizId, double rating, String comment) async {
    return submitReview(token, quizId, "quiz", rating, comment);
  }

  static Future<List<QuizQuestionModel>?> fetchQuizQuestion(
      String? token, int id) async {
    var url = Uri.parse('$baseUrl/quizzes/$id/questions');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString);

      postLogActivity(token,
          type: 'start_quiz',
          activity: 'người dùng bắt đầu làm bài kiểm tra',
          relatedId: id);

      return quizQuestionListFromJson(data);
    } else {
      return null;
    }
  }

  static Future<bool> postResendRegisterConfirmEmail(String email) async {
    var url = Uri.parse('$baseUrl/users/send-email-confirmation');
    Map data = {"email": email};
    var body = json.encode(data);

    var response =
        await http.post(url, headers: _getRequestHeaders(), body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // user profile data
  static Future<UserModel?> fetchUserProfile(String? token) async {
    Uri url = Uri.parse('$baseUrl/users/profile');

    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        authHeader: '$isBearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString);

      postLogActivity(token,
          type: 'view_user_profile',
          activity: 'người dùng xem thông tin cá nhân');

      return userFromJson(data);
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<QuizHistoryModel>?> fetchQuizHistory(
      String? token, int id) async {
    Uri url = Uri.parse('$baseUrl/quizzes/quiz-result?quizId=$id');
    var response = await http.get(url, headers: _getRequestHeaders(token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString);

      postLogActivity(token,
          type: 'view_quiz_history',
          activity: 'người dùng xem kết quả bài kiểm tra',
          relatedId: id);

      return quizHistoryListFromJson(data);
    } else {
      return null;
    }
  }

  static Future<List<MyQuizModel>?> fetchMyQuiz(String? token) async {
    Uri url = Uri.parse('$baseUrl/quizzes/user-quiz');

    var response = await http.get(
      url,
      headers: _getRequestHeaders(token),
    );

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString);

      postLogActivity(token,
          type: 'view_my_quizzes',
          activity: 'người dùng xem bài kiểm tra đã làm');

      return myQuizListFromJson(data);
    } else {
      //show error message
      return null;
    }
  }

  static Future<QuizModel?> fetchQuizDetail(String? token, int id) async {
    Uri url = Uri.parse('$baseUrl/quizzes/$id');
    var response = await http.get(url, headers: _getRequestHeaders(token));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var data = jsonEncode(jsonString);

      postLogActivity(token,
          type: 'view_quiz',
          activity: 'người dùng xem bài kiểm tra',
          relatedId: id);

      return quizModelFromJson(data);
    } else {
      //show error message
      return null;
    }
  }

  static Future<QuizResultModel?> postStartQuiz(String? token, int id) async {
    Uri url = Uri.parse('$baseUrl/quizzes/$id/start');
    var response = await http.post(
      url,
      headers: _getRequestHeaders(token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var encodedString = jsonEncode(jsonString['data']);

      postLogActivity(token,
          type: 'start_quiz',
          activity: 'người dùng bắt đầu làm bài kiểm tra',
          relatedId: id);

      var result = quizResultFromJson(encodedString);

      var jsonStringGift = jsonString['data']['gift'];
      if (jsonStringGift != null) {
        var encodedStringGift = jsonEncode(jsonString['data']['gift']);
        result.gift = giftFromJson(encodedStringGift);
      }

      return result;
    } else {
      return null;
    }
  }

  static Future<bool> postUpdateUserReferral(
      String? token, int? referById) async {
    var url = Uri.parse('$baseUrl/users/profile/update-user-referral');
    var data = {
      "referralId": referById,
    };

    var body = json.encode(data);

    var response =
        await http.post(url, headers: _getRequestHeaders(token), body: body);
    if (response.statusCode == 200) {
      postLogActivity(token,
          type: 'update_user_referral',
          activity: 'người dùng thay đổi người giới thiệu',
          relatedId: referById);
      return true;
    } else {
      return false;
    }
  }

  static Future<UserModel?> fetchUserByReferralCode(
      String? token, String code) async {
    var url =
        Uri.parse('$baseUrl/users/profile/check-user-referral?code=$code');
    var response = await http.get(url, headers: _getRequestHeaders(token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var encodedString = jsonEncode(jsonString);

      postLogActivity(token,
          type: 'check_user_referral',
          activity: 'người dùng kiểm tra người giới thiệu "$code"',
          keyword: code);

      return userFromJson(encodedString);
    } else {
      return null;
    }
  }

  static Future<QuizResultModel?> postSubmitQuiz(
      String? token,
      int quizResultId,
      int numOfCorrect,
      int totalQuestion,
      bool isPass) async {
    var url = Uri.parse('$baseUrl/quizzes/$quizResultId/submit-result');
    var data = {
      "numOfCorrect": numOfCorrect,
      "totalQuestion": totalQuestion,
      "isPass": isPass
    };

    var body = json.encode(data);
    var response =
        await http.post(url, headers: _getRequestHeaders(token), body: body);

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var encodedString = jsonEncode(jsonString['data']);

      postLogActivity(token,
          type: 'submit_quiz',
          activity: 'người dùng hoàn thành bài kiểm tra',
          relatedId: quizResultId);

      return quizResultFromJson(encodedString);
    } else {
      return null;
    }
  }

  static Future postCourseLectureProgress(String? token,
      {required int lectureId,
      bool finished = false,
      required int checkpoint,
      required int percentage}) async {
    var url = Uri.parse('$baseUrl/courses/progress');
    var data = {
      "isFinished": finished ? 1 : 0,
      "lastCheckPoint": checkpoint,
      "lessonId": lectureId,
      "percent": percentage
    };

    var body = json.encode(data);

    await http.post(url, headers: _getRequestHeaders(token), body: body);
  }

  static Future<bool> postSaveUserQuizResultDetail(
      String? token, QuizResultUserModel payload) async {
    var url = Uri.parse('$baseUrl/quiz-result-details');
    var data = {"data": payload};
    var body = json.encode(data);

    var response =
        await http.post(url, headers: _getRequestHeaders(token), body: body);

    return response.statusCode == 200;
  }

  static Map<String, String> _getRequestHeaders([String? token]) {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers[authHeader] = '$isBearer $token';
    }

    return headers;
  }

  static int? _getUserIdFromToken(String? token) {
    Map<String, dynamic> payload = jwt_decode.Jwt.parseJwt(token ?? '');
    return dynamicToInt(payload['id']);
  }
}
