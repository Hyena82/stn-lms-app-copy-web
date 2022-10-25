// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:get/get.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/models/my_quiz_model.dart';
import 'package:stna_lms_flutter/pages/quiz_detail_page.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/my_resource_page/my_quiz_list_item_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MyQuizTabWidget extends StatefulWidget {
  const MyQuizTabWidget({Key? key}) : super(key: key);

  @override
  _MyQuizTabWidgetState createState() => _MyQuizTabWidgetState();
}

class _MyQuizTabWidgetState extends State<MyQuizTabWidget> {
  final QuizController _quizController = Get.put(QuizController());

  Future<void> refresh() async {
    _quizController.myQuizzes.value = [];
    _quizController.courseFiltered.value = false;
    _quizController.fetchMyQuiz();
  }

  Widget _buildQuizItem(MyQuizModel quiz, int index) {
    return MyQuizListItemWidget(
      image: quiz.cover,
      title: quiz.name,
      isPass: quiz.isPass,
      numOfCorrect: quiz.numOfCorrect,
      totalQuestion: quiz.totalQuestion,
      finishedDate: quiz.finishedDate,
      onTap: () async {
        context.loaderOverlay.show();

        _quizController.quizInCourseIndex = -1;
        _quizController.quizID.value = quiz.quizId ?? 0;

        await _quizController.fetchQuizDetail();
        Get.to(() => const QuizDetailPage());

        context.loaderOverlay.hide();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('my_quiz'),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
                margin: EdgeInsets.only(
                    right: 20.sp, left: 20.sp, top: 15.sp, bottom: 75.sp),
                child: Obx(() {
                  if (_quizController.isLoading.value) {
                    return Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 20),
                      child: activityIndicator(),
                    );
                  }

                  if (_quizController.myQuizzes.isEmpty) {
                    return Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 20),
                      child: textHeading("Vui lòng tham gia làm kiểm tra"),
                    );
                  }

                  return Container(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _quizController.myQuizzes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildQuizItem(
                              _quizController.myQuizzes[index], index);
                        }),
                  );
                }))
          ],
        ),
      ),
    );
  }
}
