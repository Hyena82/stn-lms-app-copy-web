// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger_console/logger_console.dart';
// Project imports:
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/models/course_inprogress_model.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/models/course_chapter_model.dart';
import 'package:stna_lms_flutter/models/course_model.dart';
import 'package:stna_lms_flutter/models/lecture_model.dart';
import 'package:stna_lms_flutter/models/top_category_model.dart';
import 'package:stna_lms_flutter/services/api_service.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/course_utils.dart';
import 'package:stna_lms_flutter/utils/enum_utils.dart';

import 'package:uuid/uuid.dart';

import '../models/course_model.dart';

class HomeController extends GetxController {
  Rx<CourseChapterContentModel?> selectedChapterContent =
      CourseChapterContentModel().obs;
  Rx<CourseChapterModel?> selectedChapter = CourseChapterModel().obs;
  var allContentList = <ContentListItem>[];
  var allQuizList = <ContentListItem>[];

  Rx<int> selectedChapterContentIndex = 0.obs;
  Rx<int> selectedChapterIndex = 0.obs;

  var isLoading = false.obs;
  RxList<TopCategory> topCategoryList = <TopCategory>[].obs;
  RxList<CourseModel> latestCourseList = <CourseModel>[].obs;
  RxList<CourseModel> trialCourseList = <CourseModel>[].obs;
  RxList<CourseModel> popularCourseList = <CourseModel>[].obs;
  Rx<CourseInprogressModel> progressingCourse = CourseInprogressModel().obs;
  Rx<CourseModel> courseDetail = CourseModel().obs;
  bool courseDetailIsEnrolled = false;
  bool courseDetailHasFlow = false;
  Rx<LectureModel?> lectureDetail = LectureModel().obs;
  ChapterContentTypeEnum? lectureType;
  var courseReviews = [].obs;
  RxList<CourseChapterModel> courseChapters = <CourseChapterModel>[].obs;
  GetStorage storage = GetStorage();
  var isCourseLoading = false.obs;
  var isCourseReviewSyllabusLoading = false.obs;
  var isLectureLoading = false.obs;
  var isSubmittingCourseReview = false.obs;
  Rx<int> courseID = 0.obs;
  var courseFiltered = false.obs;
  var filterDrawer = GlobalKey<ScaffoldState>();
  List<CourseInprogressModel> inprogressCourses = [];
  Rx<LessonHistoryModel> currentProgress = LessonHistoryModel().obs;
  final TextEditingController txtReview = TextEditingController();
  var uuid = const Uuid();

  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  void onInit() async {
    super.onInit();

    fetchHomePageData();
  }

  Future fetchHomePageData() async {
    String? token = storage.read(jwtTokenKey);
    if (token == null) return;

    fetchProgressingCourse();
    fetchTopCategories();
    fetchTrialCourse();
    fetchLatestCourse();
    dashboardController.getSystemInformation();
  }

  Future<List<CourseModel>?> fetchProgressingCourse() async {
    String? token = storage.read(jwtTokenKey);
    try {
      isLoading(true);

      inprogressCourses = [];

      var inprogress = await APIService.fetchProgressingCourse(token);
      if (inprogress != null && inprogress.isNotEmpty) {
        for (var element in inprogress) {
          inprogressCourses.add(CourseInprogressModel(
              courseId: element.id,
              courseName: element.name,
              thumbnail: element.thumbnail,
              contentName: null,
              date: element.enrolledDate));

          if (element.lessonHistory != null &&
              element.lessonHistory!.isNotEmpty) {
            for (var history in element.lessonHistory!) {
              var courseInprogress = CourseInprogressModel(
                  courseId: element.id,
                  thumbnail: element.thumbnail,
                  courseName: element.name,
                  contentName: history.chapterContentName ?? history.quizName,
                  date: history.updatedAt ?? history.startDate);

              if (history.quizId != null) {
                courseInprogress.contentName =
                    history.quizName ?? history.chapterContentName;
                courseInprogress.date = history.updatedAt ?? history.startDate;
              }

              inprogressCourses.add(courseInprogress);
            }
          }
        }

        // sort by date
        inprogressCourses.sort((a, b) =>
            safeConvertDateTime(b.date).compareTo(safeConvertDateTime(a.date)));

        progressingCourse.value = inprogressCourses[0];
      } else {
        progressingCourse.value = CourseInprogressModel();
      }

      update();
      return inprogress;
    } finally {
      isLoading(false);
    }
  }

  Future fetchTopCategories() async {
    String? token = storage.read(jwtTokenKey);
    try {
      // isLoading(true);

      var topCategories = await APIService.fetchTopCategories(token);
      if (topCategories != null) {
        topCategoryList.value = topCategories;
      } else {
        topCategoryList.value = [];
      }
    } finally {
      isLoading(false);
    }
  }

  Future fetchTrialCourse() async {
    String? token = storage.read(jwtTokenKey);
    try {
      isLoading(true);

      var trialCourse = await APIService.fetchTrialCourse(token);
      if (trialCourse != null) {
        List<CourseModel> _trialCourse = [];
        if (dashboardController.systemInformation.value!.releaseMode) {
          _trialCourse = trialCourse;
        } else {
          _trialCourse =
              trialCourse.where((element) => element.price == 0).toList();
        }

        _trialCourse.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        trialCourseList.value = _trialCourse;
      } else {
        trialCourseList.value = [];
      }
    } finally {
      isLoading(false);
    }
  }

  Future fetchLatestCourse() async {
    String? token = storage.read(jwtTokenKey);
    try {
      isLoading(true);

      var latestCourse = await APIService.fetchLatestCourse(token);
      if (latestCourse != null) {
        List<CourseModel> _latestCourse = [];
        if (dashboardController.systemInformation.value!.releaseMode) {
          _latestCourse = latestCourse;
        } else {
          _latestCourse =
              latestCourse.where((element) => element.price == 0).toList();
        }

        _latestCourse.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        latestCourseList.value = _latestCourse;
      } else {
        latestCourseList.value = [];
      }
    } finally {
      isLoading(false);
    }
  }

  Future fetchPopularCourse() async {
    String? token = storage.read(jwtTokenKey);
    try {
      isLoading(true);

      var courses = await APIService.fetchPopularCourse(token);
      if (courses != null) {
        popularCourseList.value = courses;
      } else {
        popularCourseList.value = [];
      }
    } finally {
      isLoading(false);
    }
  }

  Future<bool> enrollCourse(int courseID) async {
    String? token = storage.read(jwtTokenKey);
    try {
      isLoading(true);

      bool result = await APIService.enrollCourse(token, courseID);
      return result;
    } finally {
      isLoading(false);
    }
  }

  Future handleAfterMoveToAnotherContent(
      int index, bool isEnrolled, bool hasFlow) async {
    var prevContent = allContentList[index];
    var isLocked = CourseUtils.isChapterContentLocked(
        prevContent.content!, isEnrolled, hasFlow, allContentList);

    if (isLocked) {
      if (isEnrolled) {
        AlertUtils.warn('Bạn phải hoàn thành khóa học trước');
      } else {
        AlertUtils.warn(prevContent.content!.type == 'Quiz'
            ? 'Vui lòng đăng ký khóa học để làm bài kiểm tra này'
            : 'Vui lòng đăng ký khóa học để xem nội dung này');
      }
      return;
    }

    if (prevContent.type == 'Lecture') {
      var result = await fetchLectureDetail(prevContent.content?.lessonId ?? 0);
      if (result) {
        selectedChapter.value = prevContent.chapter;
        selectedChapterContentIndex.value = prevContent.contentIndex ?? 0;
        selectedChapterIndex.value = prevContent.chapterIndex ?? 0;
        selectedChapterContent.value = prevContent.content;
        return;
      }
    } else {
      return;
    }
  }

  Future toPreviousLecture(bool isEnrolled, bool hasFlow) async {
    var contentIndex = allContentList.indexWhere(
        (element) => element.contentIndex == selectedChapterContentIndex.value);

    if (contentIndex < 0) {
      AlertUtils.error('Bài học không tồn tại');
      return false;
    }

    if (contentIndex == 0) {
      AlertUtils.warn('Đây là bài đầu tiên trong khóa học');
      return false;
    }
    var index = contentIndex - 1;

    if (allContentList[index].type == 'Lecture') {
      return handleAfterMoveToAnotherContent(index, isEnrolled, hasFlow);
    } else {
      return handleAfterMoveToAnotherContent(index - 1, isEnrolled, hasFlow);
    }
  }

  Future toNextLecture(bool isEnrolled, bool hasFlow) async {
    var contentIndex = allContentList.indexWhere(
        (element) => element.contentIndex == selectedChapterContentIndex.value);

    if (contentIndex < 0) {
      AlertUtils.error('Bài học không tồn tại');
      return;
    }
    if (contentIndex == allContentList.length - 1) {
      AlertUtils.warn('Đây là bài cuối cùng trong khóa học');
      return;
    }

    var index = contentIndex + 1;

    if (allContentList[index].type == 'Lecture') {
      return handleAfterMoveToAnotherContent(index, isEnrolled, hasFlow);
    } else {
      return handleAfterMoveToAnotherContent(index + 1, isEnrolled, hasFlow);
    }
  }

  // get course details
  Future<CourseModel?> fetchCourseDetail() async {
    String? token = storage.read(jwtTokenKey);
    try {
      isCourseLoading(true);

      allContentList = [];
      allQuizList = [];
      ContentListItem? currentContent;

      var result = await APIService.fetchCourseDetail(token, courseID.value);
      if (result != null) {
        await fetchCourseChapter();

        // check if its enrolled
        if (result.isEnrolled) {
          if (result.progress == null || result.progress!.isEmpty) {
            // must display the first lesson
            currentContent =
                allContentList.isNotEmpty ? allContentList.first : null;
          } else {
            List<CourseHistoryModel> userCourseHistory = [];

            for (var element in result.progress!) {
              if (element.updatedAt != null) {
                userCourseHistory.add(CourseHistoryModel(
                    date: element.updatedAt!, history: element));
              } else {
                userCourseHistory.add(CourseHistoryModel(
                    date: element.startDate!, history: element));
              }
            }

            // display the inprogress lesson
            userCourseHistory.sort((a, b) => safeConvertDateTime(b.date)
                .compareTo(safeConvertDateTime(a.date)));

            var userLatestHistory = userCourseHistory.first;
            var userProgress = userLatestHistory.history;

            if (userProgress.lessonId != null) {
              currentContent = allContentList.firstWhereOrNull((element) =>
                  element.content!.lessonId == userProgress.lessonId);
            } else {
              currentContent = allContentList.firstWhereOrNull(
                  (element) => element.content!.quizId == userProgress.quizId);
            }

            currentProgress.value = userProgress;
          }

          if (currentContent == null) {
            return null;
          }

          // update current content
          selectedChapterContent.value = currentContent.content;
          selectedChapter.value = currentContent.chapter;
          selectedChapterContentIndex.value = currentContent.contentIndex ?? 0;
          selectedChapterIndex.value = currentContent.chapterIndex ?? 0;
        }

        // fetch system information again
        await dashboardController.getSystemInformation();

        courseDetailHasFlow = result.hasFlow;
        courseDetailIsEnrolled = result.isEnrolled;
        courseDetail.value = result;
      } else {
        courseDetail.value = CourseModel();
      }

      update();
      return result;
    } finally {
      isCourseLoading(false);
    }
  }

  Future fetchCourseChapter() async {
    String? token = storage.read(jwtTokenKey);
    var uuid = const Uuid();

    try {
      isCourseReviewSyllabusLoading(true);

      var result = await APIService.fetchCourseChapter(token, courseID.value);
      if (result != null) {
        List<CourseChapterModel> chapters = [];

        for (var chapter in result) {
          List<CourseChapterContentModel> contents = [];

          // validate chapter contents
          if (chapter.chapterContents != null &&
              chapter.chapterContents!.isNotEmpty) {
            for (var content in chapter.chapterContents!) {
              content.uuid = uuid.v4();

              if (content.type == 'Lecture' && content.lessonId != null) {
                contents.add(content);
              }

              if (content.type == 'Quiz' && content.quizId != null) {
                contents.add(content);
              }
            }
          }

          if (contents.isNotEmpty) {
            chapter.chapterContents = contents;
            chapters.add(chapter);
          }
        }

        var chapterIndex = 0;
        var lectureIndex = 0;

        for (var chapter in chapters) {
          chapterIndex++;

          for (var content in chapter.chapterContents!) {
            lectureIndex++;

            var contentListItem = ContentListItem(
                type: content.type,
                chapter: chapter,
                content: content,
                contentIsLocked: content.isLocked,
                contentIsCompleted: content.isCompleted,
                contentIndex: lectureIndex,
                chapterIndex: chapterIndex);

            allContentList.add(contentListItem); // save to use later

            if (content.type == 'Quiz') {
              allQuizList.add(contentListItem);
            }
          }
        }

        courseChapters.value = chapters;
      } else {
        courseChapters.value = [];
      }
    } finally {
      isCourseReviewSyllabusLoading(false);
    }
  }

  Future<bool> fetchLectureDetail(int lectureId) async {
    String? token = storage.read(jwtTokenKey);
    try {
      isLectureLoading(true);

      var result = await APIService.fetchLectureDetail(token, lectureId);

      if (result != null) {
        lectureDetail.value = result;
        lectureType = CourseUtils.getLectureType(result);
      } else {
        lectureDetail.value = null;
        lectureType = null;
      }

      return result != null;
    } finally {
      isLectureLoading(false);
    }
  }

  Future postUpdateCourseLectureProgress(int lectureId,
      {bool finished = false,
      required int checkpoint,
      required int percentage}) async {
    String? token = storage.read(jwtTokenKey);
    try {
      APIService.postCourseLectureProgress(token,
          lectureId: lectureId,
          checkpoint: checkpoint,
          percentage: percentage,
          finished: finished);
    } catch (err) {
      printError(info: 'Unable to update course lecture progress');
    }
  }

  Future fetchCourseReview() async {
    String? token = storage.read(jwtTokenKey);
    try {
      isCourseReviewSyllabusLoading(true);

      var result = await APIService.fetchCourseReview(token, courseID.value);
      if (result != null) {
        courseReviews.value = result;
      } else {
        courseReviews.value = [];
      }
    } finally {
      isCourseReviewSyllabusLoading(false);
    }
  }

  Future submitCourseReview(String comment, double rating) async {
    String? token = storage.read(jwtTokenKey);
    try {
      isSubmittingCourseReview(true);

      var result = await APIService.submitCourseReview(
          token, courseID.value, rating, comment);
      if (result) {
        txtReview.text = '';
        await fetchCourseReview();
        Get.back();
        AlertUtils.success("Cảm ơn đánh giá của bạn !");
      } else {
        Get.back();
        AlertUtils.error();
      }
    } finally {
      isSubmittingCourseReview(false);
    }
  }

  int? getQuizInCourseIndex({int? chapterId, int? quizId}) {
    int quizIndex = 0;
    int currentQuizIndex = 0;

    for (var element in allQuizList) {
      if (chapterId == element.chapter!.id) {
        // found chapter
        if (quizId == element.content!.quizId) {
          // found quiz
          currentQuizIndex = quizIndex;
        }
      }

      quizIndex++;
    }

    return currentQuizIndex;
  }

  CourseChapterContentModel? getQuizFromIndex(int index) {
    if (index >= allQuizList.length) {
      return null;
    }

    var content = allQuizList[index].content;
    return content;
  }

  int getQuizIdFromIndex(int index) {
    var course = getQuizFromIndex(index);
    if (course != null) {
      return course.quizId ?? -1;
    }

    return -1;
  }
}
