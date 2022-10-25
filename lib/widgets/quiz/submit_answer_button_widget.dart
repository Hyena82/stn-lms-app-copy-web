import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/controllers/question_controller.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/widgets/quiz/quiz_result_alert_widget.dart';

class SubmitAnswerButtonWidget extends StatefulWidget {
  final QuizController quizController;
  final QuestionController questionController;
  final int index;
  final List<int> answerIds;
  final List<int> answerIndexes;
  final bool showAnswerOnSelect;

  const SubmitAnswerButtonWidget(
      {Key? key,
      required this.quizController,
      required this.questionController,
      this.index = 0,
      required this.showAnswerOnSelect,
      required this.answerIndexes,
      required this.answerIds})
      : super(key: key);

  @override
  State<SubmitAnswerButtonWidget> createState() =>
      _SubmitAnswerButtonWidgetState();
}

class _SubmitAnswerButtonWidgetState extends State<SubmitAnswerButtonWidget> {
  late double width;
  late double widthPercent;

  Color color = Get.theme.primaryColor;
  bool didCheckedResult = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    widthPercent = width / 100;

    return _buildControl();
  }

  Widget _buildControl() {
    return SizedBox(
        height: 65.sp,
        child:
            //  Obx(() {
            //   return
            Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: widthPercent * 15,
              child: LayoutUtils.buttonIcon(context,
                  icon: Icons.arrow_left_rounded,
                  onPressed: _onGoPrevious,
                  // readonly: widget.questionController.isLoading.value,
                  size: 30.sp,
                  gradient: LayoutUtils.gradientGreyLight,
                  margin: const EdgeInsets.only(
                    top: 0,
                    // bottom: 20,
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            !widget.showAnswerOnSelect
                ? SizedBox(
                    width: widthPercent * 75,
                    child: LayoutUtils.button(
                        text: "Tiếp Theo",
                        // readonly: widget.questionController.isLoading.value,
                        onPressed: _onGoNext,
                        margin: const EdgeInsets.only(
                          top: 0,
                          // bottom: 20,
                        )))
                : SizedBox(
                    width: widthPercent * 75,
                    child: LayoutUtils.button(
                        text: "Tiếp Theo",
                        onPressed: _onCheckAnswer,
                        margin: const EdgeInsets.only(
                          top: 0,
                          // bottom: 20,
                        )),
                  ),
          ],
        ));
  }

  void _onSubmit() async {
    print('oke');

    await widget.questionController.submitQuiz();
  }

  void _onContinue() async {
    await widget.questionController.goToNextQuestion();
  }

  void _onReset() async {
    return widget.questionController.resetQuestion();
  }

  void _onGoPrevious() async {
    // go back to previous question
    await widget.questionController.goToPreviousQuestion();
  }

  void _onGoNext() async {
    // go to next question
    List<int> answerIds = widget.answerIds;
    List<int> answerIndexes = widget.answerIndexes;
    int questionIndex = widget.index;
    // widget.questionController.isLoading.value = true;
    if (answerIndexes.isNotEmpty) {
      print('oke');
      widget.questionController
          .submitAnswer(questionIndex, answerIndexes, answerIds);
      if (widget.questionController.needCheckResult.value == -1) {
        if (widget.questionController.lastQuestion.value) {
          return _onSubmit();
        } else {
          return _onContinue();
        }
      }
    } else {
      // widget.questionController.isLoading.value = false;

      AlertUtils.warn('Vui lòng chọn đáp án');
    }
  }

  void _onCheckAnswer() async {
    List<int> answerIds = widget.answerIds;
    List<int> answerIndexes = widget.answerIndexes;
    int questionIndex = widget.index;

    if (answerIndexes.isNotEmpty) {
      var result = widget.questionController
          .checkAnswer(questionIndex, answerIndexes, answerIds);

      if (result) {
        if (widget.questionController.needCheckResult.value == -1) {
          if (widget.questionController.lastQuestion.value) {
            return _onSubmit();
          } else {
            return _onContinue();
          }
        }
      } else {
        Get.dialog(
            QuizResultAlertWidget(
                isCorrect: result,
                onClick: () {
                  return _onReset();
                }),
            barrierDismissible: false);
      }
    } else {
      AlertUtils.warn('Vui lòng chọn đáp án');
    }
  }
}
