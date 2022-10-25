// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/models/course_model.dart';
import 'package:stna_lms_flutter/services/api_service.dart';

class CourseCategoryController extends GetxController {
  var isLoading = false.obs;
  var courseID = 0.obs;
  RxList<CourseModel> courseList = <CourseModel>[].obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var displayText = "Khóa học".obs;
  var courseFiltered = false.obs;

  final TextEditingController reviewText = TextEditingController();

  GetStorage storage = GetStorage();

  final DashboardController dashboardController =
      Get.put(DashboardController());

  Future fetchCourseByCategory(int categoryId, String? search) async {
    String? token = storage.read(jwtTokenKey);
    try {
      isLoading(true);

      var courses = await APIService.fetchCourseByCategory(token, categoryId,
          search: search);

      if (courses != null) {
        List<CourseModel> _courses = [];
        if (dashboardController.systemInformation.value!.releaseMode) {
          _courses = courses;
        } else {
          _courses = courses.where((element) => element.price == 0).toList();
        }

        _courses.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        courseList.value = _courses;
      } else {
        courseList.value = [];
      }
    } finally {
      isLoading(false);
    }
  }
}
