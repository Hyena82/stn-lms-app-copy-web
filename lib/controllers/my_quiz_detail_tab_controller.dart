// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';

class MyQuizDetailTabController extends GetxController
    with GetTickerProviderStateMixin {
  late List<Tab> myTabs;

  late TabController controller;
  final QuizController quizController = Get.put(QuizController());

  @override
  void onInit() {
    super.onInit();

    myTabs = <Tab>[
      const Tab(text: 'Hướng Dẫn'),
      const Tab(text: 'Lịch Sử'),
      const Tab(text: 'Đánh Giá'),
    ];

    controller =
        TabController(vsync: this, length: myTabs.length, initialIndex: 0);

    controller.addListener(() async {
      if (controller.indexIsChanging && controller.index == 1) {
        await quizController.fetchQuizHistory();
      } else if (controller.indexIsChanging && controller.index == 2) {
        await quizController.fetchQuizReview();
      }
    });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
