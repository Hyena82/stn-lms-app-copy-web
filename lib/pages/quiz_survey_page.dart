import 'package:flutter/material.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:logger_console/logger_console.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/question_controller.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/quiz/question_card_widget.dart';
import 'package:stna_lms_flutter/widgets/quiz/submit_answer_button_widget.dart';

class QuizSurveyPage extends StatefulWidget {
  final bool mute;

  const QuizSurveyPage({Key? key, this.mute = false}) : super(key: key);

  @override
  _QuizSurveyPageState createState() => _QuizSurveyPageState();
}

class _QuizSurveyPageState extends State<QuizSurveyPage> {
  final QuestionController _questionController = Get.put(QuestionController());
  final QuizController _quizController = Get.put(QuizController());
  List<int> _answerIds = [];
  List<int>? _answerIndexes = [];
  int _questionIndex = 0;

  int hasCorrectAnswer = -1;
  String answerStatusTitle = '';
  String answerStatusMessage = '';

  @override
  void initState() {
    _questionController.startController(
        _quizController.quizDetail.value!, _quizController.quizQuestions);
    _questionController.updateQuestionNumber(0); // to first page
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(Get.width, 50),
            child: AppBar(
                backgroundColor: Get.theme.scaffoldBackgroundColor,
                centerTitle: true,
                elevation: 0,
                automaticallyImplyLeading: false,
                actions: [
                  Obx(() {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: IconButton(
                        icon: Icon(
                          !_questionController.questionMute.value
                              ? Icons.volume_up_rounded
                              : Icons.volume_off_rounded,
                          color: AppStyles.blueDark,
                        ),
                        onPressed: () async {
                          await _questionController.toggleQuizVolume();
                        },
                      ),
                    );
                  }),
                ],
                leading: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: AppStyles.blueDark,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                title: Text(
                  _quizController.quizDetail.value!.name ?? 'Kiểm Tra',
                  style: AppTextThemes.heading7(),
                ))),
        body: Obx(() {
          return Stack(
            children: [
              Column(
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
                        if (_quizController.quizCompleted.value) {
                          return Container();
                        }

                        return Obx(
                          () => QuestionCard(
                            mute: _questionController.questionMute.value,
                            autoplay: _questionController.questionMute.value,
                            question: _questionController.questions[index],
                            index: index,
                            showAnswerOnSelect: _quizController
                                .quizDetail.value!.showAnswerOnSelect,
                            onChooseAnswer: (answerIds, answerIndexes) =>
                                _onAnswerQuestion(
                                    index, answerIds, answerIndexes),
                          ),
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
              )
            ],
          );
        }),
      ),
    );
  }
}
