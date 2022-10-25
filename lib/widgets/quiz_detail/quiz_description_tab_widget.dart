import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';

class QuizDescriptionTabWidget extends StatefulWidget {
  final QuizController controller;
  final DashboardController dashboardController;

  const QuizDescriptionTabWidget(
      {Key? key, required this.controller, required this.dashboardController})
      : super(key: key);

  @override
  State<QuizDescriptionTabWidget> createState() =>
      _QuizDescriptionTabWidgetState();
}

class _QuizDescriptionTabWidgetState extends State<QuizDescriptionTabWidget> {
  @override
  Widget build(BuildContext context) {
    bool hasDescription =
        widget.controller.quizDetail.value?.description != null &&
            widget.controller.quizDetail.value?.description != '';

    return Scaffold(
        body: ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 0),
      children: [
        !hasDescription
            ? Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 20.sp),
                child: textHeading("Nội dung đang được cập nhật"),
              )
            : longTextSection(
                null,
                widget.controller.quizDetail.value?.description,
              )
      ],
    ));
  }
}
