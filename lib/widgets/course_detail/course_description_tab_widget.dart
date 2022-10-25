import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';

class CourseDescriptionTabWidget extends StatelessWidget {
  final HomeController controller;
  final DashboardController dashboardController;

  const CourseDescriptionTabWidget(
      {Key? key, required this.controller, required this.dashboardController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 0),
        children: [
          longTextSection(
            'Mô Tả',
            controller.courseDetail.value.description,
          ),
          longTextSection(
            'Kết quả',
            controller.courseDetail.value.outcome,
          ),
          longTextSection(
            'Yêu cầu',
            controller.courseDetail.value.requirement,
          ),
        ],
      ),
    );
  }
}
