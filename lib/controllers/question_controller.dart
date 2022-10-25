// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stna_lms_flutter/configs/app_config.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/models/quiz_model.dart';
import 'package:stna_lms_flutter/models/quiz_question_model.dart';
import 'package:stna_lms_flutter/models/quiz_result_user_model.dart';
import 'package:stna_lms_flutter/pages/quiz_result_announcement_page.dart';
import 'package:stna_lms_flutter/pages/quiz_result_summary_page.dart';
import 'package:stna_lms_flutter/pages/quiz_survey_result_summary_page.dart';
import 'package:stna_lms_flutter/services/api_service.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:video_player/video_player.dart';

class QuestionController extends GetxController
    with GetTickerProviderStateMixin {
  RxList<bool> answered = <bool>[].obs;
  VideoPlayerController? _videoPlayerController;
  var checkSelectedIndex = 0.obs;
  var color = Colors.white.obs;

  Rx<QuizQuestionModel> currentQuestion = QuizQuestionModel().obs;
  RxInt currentQuestionIndex = 1.obs;
  var isSelected = false.obs;
  var lastQuestion = false.obs;
  RxInt needCheckResult = 0.obs;
  var questionDuration = 1.obs;
  RxBool questionMute = true.obs;
  RxList<QuizQuestionModel> questions = <QuizQuestionModel>[].obs;
  Rx<QuizModel> quiz = QuizModel().obs;
  var isLoading = false.obs;

  final QuizController quizController = Get.put(QuizController());
  GetStorage storage = GetStorage();
  var types = [].obs;

  RxList<int> currentAnswerIndexes = <int>[].obs;
  RxList<int> currentAnswerIds = <int>[].obs;

  Map<int, List<int>> userChoiceIndexMap = <int, List<int>>{};
  Map<int, List<int>> userChoiceIdMap = <int, List<int>>{};

  late Animation _animation;
  late AnimationController _animationController;
  final int _numOfCorrectAns = 0;
  late PageController _pageController;
  final RxInt _questionNumber = 1.obs;

  @override
  void onClose() {
    super.onClose();
    _animationController.dispose();
    _pageController.dispose();
  }

  @override
  void onInit() {
    _animationController = AnimationController(
        duration: Duration(seconds: questionDuration.value), vsync: this);
    super.onInit();
  }

  Animation get animation => _animation;
  PageController get pageController => _pageController;
  RxInt get questionNumber => _questionNumber;
  int get numOfCorrectAns => _numOfCorrectAns;

  void setVideoPlayController(VideoPlayerController controller) {
    _videoPlayerController = controller;
  }

  void startController(
      QuizModel quizParam, List<QuizQuestionModel> quizQuestionParam,
      [bool mute = false]) {
    questionMute.value = mute;
    questionNumber.value = 1;
    answered.clear();
    types.clear();
    quiz.value = quizParam;
    questionDuration.value = quizParam.duration;
    questions.value = quizQuestionParam;
    currentQuestion.value = quizQuestionParam.first;

    currentAnswerIndexes.clear();
    currentAnswerIds.clear();
    userChoiceIndexMap.clear();
    userChoiceIdMap.clear();

    currentQuestion.value.answers?.forEach((element) {
      answered.add(false);
    });

    _pageController = PageController();
  }

  Future toggleQuizVolume() async {
    questionMute.value = !questionMute.value;
    if (_videoPlayerController != null) {
      if (questionMute.value) {
        _videoPlayerController?.setVolume(0.0);
      } else {
        _videoPlayerController?.setVolume(1.0);
      }
    }
  }

  bool checkSelected(index) {
    return currentQuestion.value == questions[index] ? true : false;
  }

  void updateQuestionNumber(int index) {
    currentQuestion.value = questions[index];
    checkSelected(index);
    _questionNumber.value = index;

    if ((_questionNumber.value + 1) == questions.length) {
      lastQuestion.value = true;
    } else {
      lastQuestion.value = false;
    }
  }

  Future goToPreviousQuestion() async {
    if (_questionNumber.value > 0) {
      currentQuestionIndex.value = _questionNumber.value - 1;
      currentQuestion.value = questions[currentQuestionIndex.value];
      currentAnswerIndexes.value =
          userChoiceIndexMap[currentQuestion.value.questionId] ?? [];
      currentAnswerIds.value =
          userChoiceIdMap[currentQuestion.value.questionId] ?? [];
      needCheckResult.value = currentAnswerIndexes.isNotEmpty ? 1 : 0;

      _pageController.previousPage(
          duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
    }
  }

  Future goToNextQuestion() async {
    if (_questionNumber.value < questions.length) {
      currentQuestionIndex.value = _questionNumber.value + 1;
      currentQuestion.value = questions[currentQuestionIndex.value];
      currentAnswerIndexes.value =
          userChoiceIndexMap[currentQuestion.value.questionId] ?? [];
      currentAnswerIds.value =
          userChoiceIdMap[currentQuestion.value.questionId] ?? [];
      needCheckResult.value = currentAnswerIndexes.isNotEmpty ? 1 : 0;

      _pageController.nextPage(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    } else {
      submitQuiz();
    }
  }

  bool _checkSingleAnswerResult(QuizQuestionModel question) {
    var userSelectionIndexes = userChoiceIndexMap[question.questionId] ?? [];
    var correctChoiceCount = 0;
    var choiceCount = userSelectionIndexes.length;
    var correctAnswerCount = 0;
    var answerIndex = 1;

    for (var answer in (question.answers ?? [])) {
      if (answer.isCorrect) {
        correctAnswerCount++;

        if (userSelectionIndexes.contains(answerIndex)) {
          correctChoiceCount++;
        }
      }

      answerIndex++;
    }

    return correctAnswerCount == correctChoiceCount &&
        correctAnswerCount == choiceCount;
  }

  QuizResultUserDetailModel? _getUserQuizResultDetail(
      QuizQuestionModel question) {
    if (question.questionId == null) {
      return null;
    }

    var userSelectionIndexes = userChoiceIndexMap[question.questionId] ?? [];
    List<int> answerIds = [];
    var answerIndex = 1;

    for (var answer in (question.answers ?? [])) {
      if (answer.answerId != null &&
          userSelectionIndexes.contains(answerIndex)) {
        answerIds.add(answer.answerId ?? 0);
      }
      answerIndex++;
    }

    return QuizResultUserDetailModel(
        questionId: question.questionId!, answerId: answerIds);
  }

  Future _submitQuiz(String? token, int id) async {
    try {
      bool showAnswerOnSelect =
          quizController.quizDetail.value!.showAnswerOnSelect;
      quizController.complete();
      // _animationController.stop();

      if (showAnswerOnSelect) {
        // when users choose show answer on select, it means that they don't want to submit result
        // skip it
        Get.to(() => const QuizResultAnnouncementPage());
      } else {
        // check answers, prepare save model, save quiz result
        // show result
        int numOfCorrect = 0;
        int totalQuestion = quizController.quizQuestions.length;
        List<QuizResultUserDetailModel> userResultDetails = [];

        // check result
        bool isCorrect = false;

        for (var question in quizController.quizQuestions) {
          var userQuizResultDetail = _getUserQuizResultDetail(question);
          if (userQuizResultDetail != null) {
            userResultDetails.add(userQuizResultDetail);
          }

          isCorrect = _checkSingleAnswerResult(question);
          if (isCorrect) {
            numOfCorrect++;
          }
        }

        double resultInPercentage = (numOfCorrect / totalQuestion) * 100;
        bool isPass =
            resultInPercentage >= quizController.quizDetail.value!.passPercent;

        quizController.isQuizResultLoading(true);

        var result = await APIService.postSubmitQuiz(
            token, id, numOfCorrect, totalQuestion, isPass);

        if (result != null) {
          await saveQuizResult(result.quizResultId ?? 0, userResultDetails);

          quizController.quizResult.value = result;
          Get.to(() => const QuizResultSummaryPage());
        } else {
          AlertUtils.error();
        }
      }
    } finally {
      quizController.isQuizResultLoading(false);
    }
  }

  Future saveQuizResult(
      int quizResultId, List<QuizResultUserDetailModel> details) async {
    String? token = storage.read(jwtTokenKey);

    try {
      QuizResultUserModel payload = QuizResultUserModel(
          userQuizResultId: quizResultId,
          quizId: quizController.quizDetail.value!.id ?? 0,
          details: details);
      var result =
          await APIService.postSaveUserQuizResultDetail(token, payload);

      if (!result) {
        AlertUtils.error();
      }
    } finally {}
  }

  Future _submitSurvey(String? token, int id) async {
    try {
      int totalQuestion = quizController.quizQuestions.length;
      int numOfCorrect = totalQuestion;
      List<QuizResultUserDetailModel> userResultDetails = [];

      for (var question in quizController.quizQuestions) {
        var userQuizResultDetail = _getUserQuizResultDetail(question);
        if (userQuizResultDetail != null) {
          userResultDetails.add(userQuizResultDetail);
        }
      }

      quizController.isQuizResultLoading(true);
      quizController.complete();

      var result = await APIService.postSubmitQuiz(
          token, id, numOfCorrect, totalQuestion, true);
      if (result != null) {
        await saveQuizResult(result.quizResultId ?? 0, userResultDetails);

        quizController.quizResult.value = result;
        // _animationController.stop();
        _videoPlayerController!.pause();
        Get.to(() => const QuizSurveyResultSummaryPage());
      } else {
        AlertUtils.error();
      }
    } finally {
      quizController.isQuizResultLoading(false);
    }
  }

  Future submitQuiz() async {
    var id = quizController.quizStart.value.quizResultId;

    if (id == null) {
      return AlertUtils.error();
    }

    String? token = storage.read(jwtTokenKey);

    if (quizController.quizDetail.value!.isSurvey) {
      _submitSurvey(token, id);
    } else {
      _submitQuiz(token, id);
    }
  }

  void selectAnswer(List<int> answerIndexes) {
    currentAnswerIndexes.value = answerIndexes;
    needCheckResult.value = 1;
  }

  void resetQuestion() {
    needCheckResult.value = 1;
  }

  void submitAnswer(int index, List<int> answerIndexes, List<int> answerIds) {
    needCheckResult.value = -1;
    userChoiceIndexMap[questions[index].questionId ?? 0] = answerIndexes;
    userChoiceIdMap[questions[index].questionId ?? 0] = answerIds;
  }

  bool checkAnswer(int index, List<int> answerIndexes, List<int> answerIds) {
    needCheckResult.value = -1;
    userChoiceIndexMap[questions[index].questionId ?? 0] = answerIndexes;
    userChoiceIdMap[questions[index].questionId ?? 0] = answerIndexes;

    if (answerIds.isEmpty) {
      return false;
    }

    return _checkSingleAnswerResult(questions[index]);
  }

  String getTimeStringFromDouble(double value) {
    if (value < 0) return 'Invalid Value';
    int flooredValue = value.floor();
    double decimalValue = value - flooredValue;
    String hourValue = getHourString(flooredValue);
    String minuteString = getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String getMinuteString(double decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }
}

class CheckboxModal {
  CheckboxModal(
      {this.title,
      this.value = false,
      this.id,
      this.isCorrect = false,
      this.index});

  int? id;
  int? index;
  bool isCorrect;
  String? title;
  bool value;
}
