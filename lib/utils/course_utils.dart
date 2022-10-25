import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/models/course_chapter_model.dart';
import 'package:stna_lms_flutter/models/lecture_model.dart';
import 'package:stna_lms_flutter/pages/quiz_test_page.dart';
import 'package:stna_lms_flutter/pages/quiz_survey_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/enum_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';

class CourseUtils {
  static CourseActionTypeEnum getCourseActionType(
      {bool isEmpty = false,
      bool isEnrolled = false,
      bool isVip = false,
      double price = 0.0}) {
    if (isEnrolled) {
      return CourseActionTypeEnum.ENROLLED;
    }

    if (isEmpty) {
      return CourseActionTypeEnum.UNDER_CONSTRUCTION;
    }

    if (isVip || price == 0) {
      return CourseActionTypeEnum.ENROLL_NOW;
    }

    return CourseActionTypeEnum.BUY_NOW;
  }

  static ChapterContentTypeEnum getLectureType(LectureModel lecture) {
    if (lecture.youtubeUrl != null && lecture.youtubeUrl?.trim() != '') {
      return ChapterContentTypeEnum.LECTURE_VIDEO_YOUTUBE;
    } else if (lecture.video != null && lecture.video?.trim() != '') {
      return ChapterContentTypeEnum.LECTURE_VIDEO;
    } else if (lecture.audios != null) {
      return ChapterContentTypeEnum.LECTURE_AUDIO;
    }

    return ChapterContentTypeEnum.LECTURE_NOTE;
  }

  static bool isChapterContentLocked(CourseChapterContentModel chapterContent,
      bool isEnrolled, bool hasFlow, List<ContentListItem> allLectures) {
    if (isEnrolled) {
      if (hasFlow) {
        int recentCompleteLectureIndex =
            allLectures.lastIndexWhere((element) => element.contentIsCompleted);
        ContentListItem latestLecture;
        int currentIndex = 0;
        int latestIndex = 0;

        if (recentCompleteLectureIndex > -1) {
          if (recentCompleteLectureIndex == allLectures.length - 1) {
            latestLecture = allLectures.last;
          } else {
            latestLecture = allLectures[recentCompleteLectureIndex];
          }

          latestIndex = latestLecture.contentIndex ?? 0;
        } else {
          latestIndex = 0;
        }

        var currentLecture = allLectures.firstWhereOrNull(
            (element) => element.content!.uuid == chapterContent.uuid);
        if (currentLecture == null) {
          return true;
        }

        currentIndex = currentLecture.contentIndex ?? 0;

        return currentIndex > (latestIndex + 1);
      }

      return false;
    }

    return chapterContent.isLocked;
  }

  static ChapterContentTypeEnum getChapterContentType(
      CourseChapterContentModel chapterContent, bool isLocked) {
    if (!isLocked) {
      if (chapterContent.type == 'Quiz') {
        return ChapterContentTypeEnum.QUIZ;
      } else if (chapterContent.lessonVideoUrl != null) {
        return ChapterContentTypeEnum.LECTURE_VIDEO;
      } else if (chapterContent.videoUrl != null) {
        return ChapterContentTypeEnum.LECTURE_VIDEO_YOUTUBE;
      } else if (chapterContent.lessonAudioUrl != null &&
          chapterContent.lessonAudioUrl!.isNotEmpty) {
        return ChapterContentTypeEnum.LECTURE_AUDIO;
      } else {
        return ChapterContentTypeEnum.LECTURE_NOTE;
      }
    }

    return ChapterContentTypeEnum.LOCKED;
  }

  static Text getCourseDurationText(CourseChapterContentModel chapterContent) {
    ChapterContentTypeEnum chapterContentType =
        getChapterContentType(chapterContent, false);

    String? duration;

    switch (chapterContentType) {
      case ChapterContentTypeEnum.LECTURE_VIDEO:
      case ChapterContentTypeEnum.LECTURE_VIDEO_YOUTUBE:
      case ChapterContentTypeEnum.LECTURE_AUDIO:
        var hour = (chapterContent.duration / 3600).floor();
        var minute = ((chapterContent.duration - (hour * 3600)) / 60).floor();
        var second = chapterContent.duration - (hour * 3600) - (minute * 60);

        var durations = [];
        if (hour > 0) durations.add(hour);
        durations.add(minute < 10 ? '0$minute' : minute);
        durations.add(second < 10 ? '0$second' : second);

        duration = durations.join(':');
        break;
      default:
        duration = null;
        break;
    }

    return Text(
      duration ?? '',
      style: AppTextThemes.heading7(),
    );
  }

  static Widget getChapterContentTypeIcon(
      CourseChapterContentModel chapterContent, bool isLocked) {
    ChapterContentTypeEnum chapterContentType =
        getChapterContentType(chapterContent, isLocked);
    IconData iconData;
    var gradient = LayoutUtils.gradientBlueLight;

    switch (chapterContentType) {
      case ChapterContentTypeEnum.LECTURE_VIDEO:
      case ChapterContentTypeEnum.LECTURE_VIDEO_YOUTUBE:
        iconData = FontAwesomeIcons.film;
        break;
      case ChapterContentTypeEnum.LECTURE_NOTE:
        iconData = FontAwesomeIcons.readme;
        break;
      case ChapterContentTypeEnum.LECTURE_AUDIO:
        iconData = FontAwesomeIcons.headphonesAlt;
        break;
      case ChapterContentTypeEnum.LOCKED:
        iconData = FontAwesomeIcons.lock;
        gradient = LayoutUtils.gradientGrey;
        break;
      default:
        iconData = FontAwesomeIcons.question;
        break;
    }

    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            gradient: gradient, borderRadius: BorderRadius.circular(5.0)),
        child: FaIcon(
          iconData,
          color: Colors.white,
          size: 18.sp,
        ));
  }

  static Widget startTimingQuizDialogWidget(QuizController controller) {
    var isSurvey = controller.quizDetail.value!.isSurvey;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.sp),
        child: Column(
          children: [
            SizedBox(height: 10.sp),
            LayoutUtils.fadeInImage(
                fit: BoxFit.cover,
                height: 70.sp,
                image: isSurvey
                    ? const AssetImage('images/quiz/start-survey.png')
                    : const AssetImage('images/quiz/start-quiz.png')),
            SizedBox(height: 30.sp),
            Text(
              "Bạn đã sẵn sàng chưa ?",
              style: AppTextThemes.heading5().copyWith(
                  color: AppStyles.primary, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.sp),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text(
                'Số câu hỏi',
                style: AppTextThemes.label3().copyWith(
                  color: AppStyles.primary,
                ),
              ),
              Text(
                '${controller.quizDetail.value?.totalQuestion}',
                style: AppTextThemes.heading5()
                    .copyWith(fontWeight: FontWeight.bold),
              )
            ]),
            SizedBox(height: 10.sp),
            !isSurvey
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        Text(
                          'Thời lượng',
                          style: AppTextThemes.label3().copyWith(
                            color: AppStyles.primary,
                          ),
                        ),
                        Text(
                          durationString(
                              controller.quizDetail.value?.duration ?? 0),
                          style: AppTextThemes.heading5()
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ])
                : Container(),
            SizedBox(
              height: 30.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 100.sp,
                    child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "Hủy",
                          style: AppTextThemes.heading7(),
                          textAlign: TextAlign.center,
                        ))),
                Obx(() {
                  return controller.isQuizStarting.value
                      ? Container(
                          width: 100.sp,
                          height: 30.sp,
                          alignment: Alignment.center,
                          child: activityIndicator())
                      : SizedBox(
                          width: 100.sp,
                          child: ElevatedButton(
                            onPressed: () async {
                              controller.quizID.value =
                                  controller.quizDetail.value!.id ?? 0;
                              bool value = await controller.startQuiz();

                              if (value) {
                                Get.back();

                                isSurvey
                                    ? Get.to(() => const QuizSurveyPage())
                                    : Get.to(() => const QuizTestPage());
                              } else {
                                AlertUtils.error();
                              }
                            },
                            child: Text(
                              "Bắt Đầu",
                              style: AppTextThemes.heading7()
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ));
                })
              ],
            ),
          ],
        ));
  }
}
