// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/my_course_controller.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';

class MyResourceController extends GetxController
    with GetTickerProviderStateMixin {
  final MyCourseController _myCourseController = Get.put(MyCourseController());
  final QuizController _quizController = Get.put(QuizController());

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Khóa Học'),
    const Tab(text: 'Bài Kiểm Tra'),
  ];

  late TabController tabController;

  Rx<String> searchText = "courses".obs;

  var isCourse = false.obs;
  var isClass = false.obs;
  var isQuiz = false.obs;

  var myCoursesSearch = [].obs;

  var allMyClassSearch = [].obs;

  var allMyQuizSearch = [].obs;

  var courseSearchStarted = false.obs;

  var classSearchStarted = false.obs;

  var quizSearchStarted = false.obs;

  onCourseSearchTextChanged(String text) async {
    if (tabController.index == 0) {
      courseSearchStarted.value = true;
      myCoursesSearch.clear();
      if (text.isEmpty) {
        courseSearchStarted.value = false;
        return;
      }

      for (var value in _myCourseController.myCourses) {
        if ((value.name ?? '').toUpperCase().contains(text.toUpperCase())) {
          myCoursesSearch.add(value);
        }
      }
      // searchStarted.value = false;
    } else if (tabController.index == 1) {
      classSearchStarted.value = true;
      allMyClassSearch.clear();
      if (text.isEmpty) {
        classSearchStarted.value = false;
        return;
      }
    } else if (tabController.index == 2) {
      quizSearchStarted.value = true;
      allMyQuizSearch.clear();
      if (text.isEmpty) {
        quizSearchStarted.value = false;
        return;
      }

      for (var quiz in _quizController.myQuizzes) {
        if ((quiz.name ?? '').toUpperCase().contains(text.toUpperCase())) {
          allMyQuizSearch.add(quiz);
        }
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: myTabs.length);
    tabController.addListener(() async {
      if (tabController.indexIsChanging && tabController.index == 0) {
        await _myCourseController.fetchMyCourse();
      } else if (tabController.indexIsChanging && tabController.index == 1) {
        await _quizController.fetchMyQuiz();
      }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
