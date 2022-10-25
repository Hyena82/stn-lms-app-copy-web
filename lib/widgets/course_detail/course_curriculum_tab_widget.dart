import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/pages/lecture_detail_page.dart';
import 'package:stna_lms_flutter/pages/quiz_detail_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/course_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CourseCurriculumTabWidget extends StatelessWidget {
  final BuildContext parentContext;
  final HomeController controller;
  final DashboardController dashboardController;

  final _wp = Get.width / 100;
  final _hp = Get.height / 100;

  CourseCurriculumTabWidget(
      {Key? key,
      required this.parentContext,
      required this.controller,
      required this.dashboardController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.put(QuizController());

    return Scaffold(
      body: Obx(() {
        if (controller.isCourseReviewSyllabusLoading.value) {
          return Center(
            child: activityIndicator(),
          );
        }

        if (controller.courseChapters.isEmpty) {
          return Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: _hp * 2),
            child: textHeading("Nội dung đang được xây dựng"),
          );
        }

        return ListView.separated(
          itemCount: controller.courseChapters.length,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: _hp * 3, horizontal: _wp * 5),
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10.sp,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            var chapter = controller.courseChapters[index];
            var chapterContents = chapter.chapterContents;
            var initiallyExpanded =
                chapter.id == controller.selectedChapter.value?.id;

            final GlobalKey expansionTileKey = GlobalKey();

            return ExpansionTileCard(
              key: expansionTileKey,
              initiallyExpanded: initiallyExpanded,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              expandedColor: Colors.white,
              expandedTextColor: AppStyles.primary,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    (index + 1).toString() + ". ",
                    style: AppTextThemes.heading6(),
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  Expanded(
                    child: Text(
                      chapter.name ?? 'N/A',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextThemes.heading6(),
                    ),
                  )
                ],
              ),
              children: <Widget>[
                ListView.builder(
                    itemCount: chapterContents?.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 5.sp),
                    itemBuilder: (BuildContext context, int contentIndex) {
                      var chapterContent = chapterContents![contentIndex];
                      var isEnrolled = controller.courseDetail.value.isEnrolled;
                      var isSelected = false;
                      var hasFlow = controller.courseDetail.value.hasFlow;

                      if (isEnrolled) {
                        isSelected = (contentIndex ==
                                controller.selectedChapterContentIndex.value -
                                    1) &&
                            (index ==
                                controller.selectedChapterIndex.value - 1);
                      }

                      var isLocked = CourseUtils.isChapterContentLocked(
                          chapterContent,
                          isEnrolled,
                          hasFlow,
                          controller.allContentList);

                      var lecture =
                          controller.allContentList.firstWhereOrNull((element) {
                        return element.content!.uuid == chapterContent.uuid;
                      });

                      return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5.sp, horizontal: 10.sp),
                          padding: EdgeInsets.all(7.sp),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppStyles.blueLighter.withOpacity(0.7)
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: InkWell(
                            onTap: () async {
                              if (isLocked) {
                                if (isEnrolled) {
                                  AlertUtils.warn(
                                      'Bạn phải hoàn thành khóa học trước');
                                } else {
                                  AlertUtils.warn(chapterContent.type == 'Quiz'
                                      ? 'Vui lòng đăng ký khóa học để làm bài kiểm tra này'
                                      : 'Vui lòng đăng ký khóa học để xem nội dung này');
                                }
                              } else {
                                controller.handleAfterMoveToAnotherContent(
                                    (lecture!.contentIndex ?? 0) - 1,
                                    isEnrolled,
                                    hasFlow);

                                // if user has enrolled this course
                                if (chapterContent.type != 'Quiz') {
                                  parentContext.loaderOverlay.show();

                                  var result =
                                      await controller.fetchLectureDetail(
                                          chapterContent.lessonId ?? 0);

                                  if (result) {
                                    Get.to(() => LectureDetailPage(
                                        lastPage: 'course',
                                        isEnrolled: isEnrolled));
                                  } else {
                                    AlertUtils.error();
                                  }

                                  parentContext.loaderOverlay.hide();
                                } else {
                                  parentContext.loaderOverlay.show();

                                  // should pass the next quiz id to this
                                  quizController.quizInCourseIndex =
                                      controller.getQuizInCourseIndex(
                                              chapterId: chapter.id,
                                              quizId: chapterContent.quizId) ??
                                          -1;
                                  quizController.quizID.value =
                                      chapterContent.quizId ?? 0;

                                  var result =
                                      await quizController.fetchQuizDetail();

                                  parentContext.loaderOverlay.hide();

                                  if (result != null) {
                                    Get.to(() => const QuizDetailPage(
                                          lastPage: 'course',
                                        ));
                                  } else {
                                    AlertUtils.error();
                                  }
                                }
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: _wp * 2,
                                    ),
                                    CourseUtils.getChapterContentTypeIcon(
                                        chapterContent, isLocked),
                                    SizedBox(
                                      width: _wp * 3,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: _wp * 70,
                                        child: Text(
                                          chapterContent.name ?? 'N/A',
                                          style: AppTextThemes.label4()
                                              .copyWith(
                                                  color: AppStyles.primary),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: _wp * 2,
                                    ),
                                    CourseUtils.getCourseDurationText(
                                        chapterContent),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    }),
              ],
            );
          },
        );
      }),
    );
  }
}
