// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger_console/logger_console.dart';
// Project imports:
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/models/my_quiz_model.dart';
import 'package:stna_lms_flutter/models/quiz_history_model.dart';
import 'package:stna_lms_flutter/models/quiz_leaderboard_model.dart';
import 'package:stna_lms_flutter/models/quiz_model.dart';
import 'package:stna_lms_flutter/models/quiz_question_model.dart';
import 'package:stna_lms_flutter/models/quiz_result_model.dart';
import 'package:stna_lms_flutter/models/quiz_review_model.dart';
import 'package:stna_lms_flutter/services/api_service.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';

import 'dashboard_controller.dart';

class QuizController extends GetxController {
  final DashboardController dashboardController =
      Get.put(DashboardController());
  final HomeController homeController = Get.put(HomeController());

  var isLoading = false.obs;
  var isQuizLoading = false.obs;
  RxList<MyQuizModel> myQuizzes = <MyQuizModel>[].obs;
  var courseID = ''.obs;
  var courseFiltered = false.obs;

  GetStorage storage = GetStorage();

  final TextEditingController txtReview = TextEditingController();
  Rx<QuizModel?> quizDetail = QuizModel().obs;
  RxInt quizID = 0.obs;
  RxBool isQuizTabLoading = false.obs;
  RxList<QuizReviewModel> quizReviews = <QuizReviewModel>[].obs;
  RxBool isSubmittingReview = false.obs;
  RxList<QuizHistoryModel> quizHistory = <QuizHistoryModel>[].obs;
  RxList<QuizQuestionModel> quizQuestions = <QuizQuestionModel>[].obs;
  Rx<QuizResultModel> quizStart = QuizResultModel().obs;
  Rx<QuizResultModel> quizResult = QuizResultModel().obs;
  Rx<QuizLeaderboardModel?> quizLeaderboard = QuizLeaderboardModel().obs;
  int quizResultId = 0;
  var isQuizStarting = false.obs;
  var isQuizResultLoading = false.obs;
  var isQuizLeaderboardLoading = false.obs;
  RxBool quizCompleted = false.obs;

  final TextEditingController reviewText = TextEditingController();

  int quizInCourseIndex = -1;

  Future fetchQuizLeaderboard() async {
    String? token = storage.read(jwtTokenKey);

    try {
      isQuizLeaderboardLoading(true);

      var model = await APIService.fetchQuizLeaderboard(token, quizID.value);
      if (model != null) {
        quizLeaderboard.value = model;
      } else {
        quizLeaderboard.value = null;
      }
    } finally {
      isQuizLeaderboardLoading(false);
    }
  }

  Future submitQuizReview(String comment, double rating) async {
    String? token = storage.read(jwtTokenKey);
    try {
      isSubmittingReview(true);

      var result = await APIService.submitQuizReview(
          token, quizID.value, rating, comment);
      if (result) {
        txtReview.text = '';
        await fetchQuizReview();
        Get.back();
        AlertUtils.success("Cảm ơn đánh giá của bạn !");
      } else {
        Get.back();
        AlertUtils.error();
      }
    } finally {
      isSubmittingReview(false);
    }
  }

  Future fetchMyQuiz() async {
    String? token = storage.read(jwtTokenKey);
    try {
      isLoading(true);
      var quizzes = await APIService.fetchMyQuiz(token);
      if (quizzes != null) {
        myQuizzes.value = quizzes;
      } else {
        myQuizzes.value = [];
      }
    } finally {
      isLoading(false);
    }
  }

  Future<bool> startQuiz() async {
    try {
      String? token = storage.read(jwtTokenKey);
      isQuizStarting(true);

      // get questions
      var questions = await APIService.fetchQuizQuestion(token, quizID.value);

      if (questions == null) {
        AlertUtils.error();
        return false;
      }

      if (questions.isEmpty) {
        AlertUtils.warn(
            'Bài kiểm tra đang trong quá trình xây dựng. Vui lòng thử lại lần sau !');
        return false;
      }

      // start quiz
      QuizResultModel? startQuiz =
          await APIService.postStartQuiz(token, quizID.value);

      if (startQuiz == null) {
        return false;
      }

      quizQuestions.value = questions;
      quizStart.value = startQuiz;
      quizResultId = startQuiz.quizResultId ?? 0;
      quizCompleted.value = false;

      return true;
    } finally {
      isQuizStarting(false);
    }
  }

  Future fetchQuizHistory() async {
    String? token = storage.read(jwtTokenKey);
    try {
      isQuizTabLoading(true);

      var result = await APIService.fetchQuizHistory(token, quizID.value);
      Console.log('fetchQuizHistory--->', result);
      if (result != null) {
        quizHistory.value = result;
      } else {
        quizHistory.value = [];
      }
    } finally {
      isQuizTabLoading(false);
    }
  }

  Future<List<QuizReviewModel>?> fetchQuizReview() async {
    String? token = storage.read(jwtTokenKey);
    try {
      isQuizTabLoading(true);

      var result = await APIService.fetchQuizReview(token, quizID.value);
      if (result != null) {
        quizReviews.value = result;
      } else {
        quizReviews.value = [];
      }
      return result;
    } finally {
      isQuizTabLoading(false);
    }
  }

  Future<QuizModel?> fetchQuizDetail() async {
    String? token = storage.read(jwtTokenKey);
    try {
      isQuizLoading(true);

      QuizModel? quiz = await APIService.fetchQuizDetail(token, quizID.value);

      if (quiz != null) {
        quizDetail.value = quiz;
      } else {
        quizDetail.value = null;
      }

      return quiz;
    } finally {
      isQuizLoading(false);
    }
  }

  complete() {
    quizCompleted.value = true;
  }
}
