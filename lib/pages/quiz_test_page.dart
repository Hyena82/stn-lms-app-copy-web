import 'dart:async';

import 'package:day/day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/question_controller.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/widgets/quiz/question_card_widget.dart';
import 'package:stna_lms_flutter/widgets/quiz/submit_answer_button_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class QuizTestPage extends StatefulWidget {
  final bool mute;

  const QuizTestPage({Key? key, this.mute = false}) : super(key: key);

  @override
  _QuizTestPageState createState() => _QuizTestPageState();
}

class _QuizTestPageState extends State<QuizTestPage> {
  final QuestionController _questionController = Get.put(QuestionController());
  final QuizController _quizController = Get.put(QuizController());
  Function(bool mute)? _onMute;
  List<int> _answerIds = [];
  List<int>? _answerIndexes = [];
  int _questionIndex = 0;

  int hasCorrectAnswer = -1;
  String answerStatusTitle = '';
  String answerStatusMessage = '';

  late DateTime quizStartDate;
  bool _hasDuration = false;

  Timer? _quizTimer;

  @override
  void initState() {
    _questionController.startController(
        _quizController.quizDetail.value!, _quizController.quizQuestions);
    _questionController.updateQuestionNumber(0); // to first page

    // only show duration when quiz does not show answer on select and it has duration
    _hasDuration = !_quizController.quizDetail.value!.showAnswerOnSelect &&
        _quizController.quizDetail.value!.duration > 0;

    if (_hasDuration) {
      quizStartDate = DateTime.now();
      _startTimeoutTimer();
    }

    super.initState();
  }

  void _onAnswerQuestion(
      int questionIndex, List<int> answerIds, List<int>? answerIndexes) async {
    setState(() {
      _answerIds = answerIds;
      _answerIndexes = answerIndexes;
      _questionIndex = questionIndex;
    });

    if (_answerIndexes != null && _answerIndexes!.isNotEmpty) {
      _questionController
          .selectAnswer(_answerIndexes != null ? _answerIndexes! : []);
    }
  }

  void _startTimeoutTimer() {
    var timeout = _quizController.quizDetail.value!.duration + 1;

    _quizTimer = Timer(Duration(seconds: timeout), () {
      if (!_quizController.quizCompleted.value) {
        _quizController.complete();
        _showTimeoutDialog();
      }
    });
  }

  void _showTimeoutDialog() {
    Get.defaultDialog(
        title: "Hết Giờ",
        backgroundColor: Get.theme.cardColor,
        titleStyle: AppTextThemes.heading6(),
        barrierDismissible: true,
        radius: 5,
        content: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Column(
              children: [
                SizedBox(height: 10.sp),
                LayoutUtils.fadeInImage(
                    fit: BoxFit.cover,
                    height: 70.sp,
                    image: const AssetImage('images/quiz/quiz-timeout.png')),
                SizedBox(height: 30.sp),
                Text(
                  "Đã hết giờ làm bài",
                  style: AppTextThemes.heading5().copyWith(
                      color: AppStyles.primary, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.sp),
                Text(
                  'Vui lòng ấn "Nộp Bài" để xem kết quả',
                  style: AppTextThemes.heading6().copyWith(
                      color: AppStyles.secondary, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 100.sp,
                        child: ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              _questionController.submitAnswer(_questionIndex,
                                  _answerIndexes ?? [], _answerIds);
                              await _questionController.submitQuiz();
                            },
                            child: Text(
                              "Nộp Bài",
                              style: AppTextThemes.heading7()
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ))),
                  ],
                ),
              ],
            )));
  }

  void onMute(bool mute) {
    _onMute?.call(mute);
  }

  void _callbackMute(Function(bool mute) onMute) {
    _onMute = onMute;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(Get.width, 40.sp),
            child: AppBar(
                backgroundColor: Get.theme.scaffoldBackgroundColor,
                centerTitle: true,
                elevation: 0,
                automaticallyImplyLeading: false,
                actions: [
                  Obx(() {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 1.sp),
                      child: IconButton(
                        icon: Icon(
                          !_questionController.questionMute.value
                              ? Icons.volume_up_rounded
                              : Icons.volume_off_rounded,
                          color: AppStyles.blueDark,
                          size: 16.sp,
                        ),
                        onPressed: () async {
                          await _questionController.toggleQuizVolume();
                          onMute(!_questionController.questionMute.value);
                        },
                      ),
                    );
                  }),
                ],
                leading: Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.sp),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: AppStyles.blueDark,
                      size: 16.sp,
                    ),
                    onPressed: () {
                      _quizController.complete();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                title: !_hasDuration
                    ? Text(
                        _quizController.quizDetail.value!.name ?? 'Kiểm Tra',
                        style: AppTextThemes.heading7(),
                      )
                    : StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (_, snapshot) {
                          final executedTime = Day.fromDateTime(DateTime.now())
                              .diff(Day.fromDateTime(quizStartDate), 's');
                          final remainingTime =
                              _quizController.quizDetail.value!.duration -
                                  executedTime;
                          final percent = double.parse((executedTime /
                                      _quizController
                                          .quizDetail.value!.duration)
                                  .toStringAsFixed(7))
                              .abs();

                          return LinearPercentIndicator(
                              lineHeight: 21.sp,
                              percent: percent >= 1.0 ? 1.0 : percent,
                              center: Text(
                                executedTime >=
                                        _quizController
                                            .quizDetail.value!.duration
                                    ? durationString(_quizController
                                        .quizDetail.value!.duration)
                                    : durationString(remainingTime),
                                style: TextStyle(
                                  color: AppStyles.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              clipLinearGradient: true,
                              curve: Curves.slowMiddle,
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              backgroundColor: AppStyles.blueLight,
                              progressColor: AppStyles.blueDark);
                        },
                      )),
          ),
          body: Obx(() {
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _questionController.pageController,
                    onPageChanged: (int page) {
                      _questionController.updateQuestionNumber(page);
                      setState(() {
                        _answerIndexes =
                            _questionController.currentAnswerIndexes;
                        _answerIds = _questionController.currentAnswerIds;
                      });
                    },
                    itemCount: _questionController.questions.length,
                    itemBuilder: (context, index) {
                      // if (_quizController.quizCompleted.value) {
                      //   return Container();
                      // }

                      return QuestionCard(
                        mute: _questionController.questionMute.value,
                        autoplay: _questionController.questionMute.value,
                        question: _questionController.questions[index],
                        index: index,
                        showAnswerOnSelect: _quizController
                            .quizDetail.value!.showAnswerOnSelect,
                        onChooseAnswer: (answerIds, answerIndexes) =>
                            _onAnswerQuestion(index, answerIds, answerIndexes),
                        onMute: _callbackMute,
                      );
                    },
                  ),
                ),
                SubmitAnswerButtonWidget(
                    showAnswerOnSelect:
                        _quizController.quizDetail.value!.showAnswerOnSelect,
                    quizController: _quizController,
                    questionController: _questionController,
                    index: _questionIndex,
                    answerIndexes: _answerIndexes ?? [],
                    answerIds: _answerIds)
              ],
            );
          })),
    );
  }

  @override
  void dispose() {
    if (_quizTimer != null) {
      _quizTimer!.cancel();
    }

    super.dispose();
  }
}
