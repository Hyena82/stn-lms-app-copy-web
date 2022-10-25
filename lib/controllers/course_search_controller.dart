// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
// Project imports:
import 'package:stna_lms_flutter/models/course_model.dart';
import 'package:stna_lms_flutter/services/api_service.dart';

class CourseSearchController extends GetxController {
  var isLoading = false.obs;
  var courseID = 0.obs;
  var allCourseList = <CourseModel>[].obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var allCourseText = "Khóa học".obs;
  var courseFiltered = false.obs;

  GetStorage storage = GetStorage();

  final TextEditingController reviewText = TextEditingController();

  final DashboardController dashboardController =
      Get.put(DashboardController());

  Future fetchAllCourse(String? search) async {
    // ignore: await_only_futures
    String? token = await storage.read(jwtTokenKey);
    try {
      isLoading(true);

      String? value = search?.replaceAll(RegExp('#'), '%');
      var courses = await APIService.fetchAllCourse(token, value);

      if (courses != null) {
        List<CourseModel> _courses = [];
        if (dashboardController.systemInformation.value!.releaseMode) {
          _courses = courses;
        } else {
          _courses = courses.where((element) => element.price == 0).toList();
        }

        _courses.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        var courseObject = <String>{};
        List<CourseModel> _allCourseList = _courses
            .where((student) => courseObject.add(student.name!))
            .toList();

        allCourseList.value = _allCourseList;
      } else {
        allCourseList.value = [];
      }
    } finally {
      isLoading(false);
    }
  }
}
