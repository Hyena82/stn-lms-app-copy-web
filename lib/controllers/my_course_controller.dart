// Dart imports:

// Flutter imports:
import 'package:flutter/cupertino.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// Project imports:
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/controllers/course_enrolled_detail_tab_controller.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/models/course_model.dart';
import 'package:stna_lms_flutter/services/api_service.dart';

class MyCourseController extends GetxController {
  final DashboardController dashboardController =
      Get.put(DashboardController());
  final HomeController homeController = Get.put(HomeController());

  RxList<CourseModel> myCourses = <CourseModel>[].obs;

  var isLoading = false.obs;

  var isMyCourseLoading = false.obs;

  var lessons = [].obs;

  var youtubeID = "".obs;

  Rx<int> courseID = 0.obs;

  var totalCourseProgress = 0.0.obs;

  var selectedLessonID = "".obs;

  final TextEditingController commentController = TextEditingController();

  final CourseProgressTabController myCourseDetailsTabController =
      Get.put(CourseProgressTabController());

  GetStorage storage = GetStorage();

  @override
  void onInit() {
    fetchMyCourse();
    super.onInit();
  }

  Future<List<CourseModel>?> fetchMyCourse() async {
    String? token = storage.read(jwtTokenKey);

    try {
      isLoading(true);

      var courses = await APIService.fetchMyCourse(token);
      if (courses != null) {
        List<CourseModel> _courses = [];
        if (dashboardController.systemInformation.value!.releaseMode) {
          _courses = courses;
        } else {
          _courses = courses.where((element) => element.price == 0).toList();
        }

        _courses.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        myCourses.value = _courses;
      } else {
        myCourses.value = [];
      }
      return courses;
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    commentController.clear();
    super.onClose();
  }
}
