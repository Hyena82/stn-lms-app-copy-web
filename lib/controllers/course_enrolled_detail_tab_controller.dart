// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';

class CourseProgressTabController extends GetxController
    with GetTickerProviderStateMixin {
  late List<Tab> myTabs;

  late TabController controller;

  final HomeController homeController = Get.put(HomeController());

  @override
  void onInit() {
    super.onInit();

    homeController.fetchCourseChapter();

    myTabs = <Tab>[
      const Tab(text: 'Nội Dung'),
      const Tab(text: 'Đánh Giá'),
    ];

    controller =
        TabController(vsync: this, length: myTabs.length, initialIndex: 0);
    controller.addListener(() async {
      if (controller.indexIsChanging && controller.index == 0) {
        await homeController.fetchCourseChapter();
      } else if (controller.indexIsChanging && controller.index == 1) {
        await homeController.fetchCourseReview();
      }
    });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
