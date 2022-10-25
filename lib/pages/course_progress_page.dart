// Dart imports:

import 'package:avatar_glow/avatar_glow.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/course_enrolled_detail_tab_controller.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/pages/course_detail_page.dart';
import 'package:stna_lms_flutter/pages/lecture_detail_page.dart';
import 'package:stna_lms_flutter/pages/quiz_detail_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/course_utils.dart';
import 'package:stna_lms_flutter/utils/enum_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/widgets/course_detail/course_curriculum_tab_widget.dart';
import 'package:stna_lms_flutter/widgets/course_detail/course_description_tab_widget.dart';
import 'package:stna_lms_flutter/widgets/course_detail/course_review_tab_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CourseProgressPage extends StatefulWidget {
  final String? lastPage;

  const CourseProgressPage({Key? key, this.lastPage}) : super(key: key);

  @override
  State<CourseProgressPage> createState() => _CourseProgressPageState();
}

class _CourseProgressPageState extends State<CourseProgressPage> {
  final double _wp = Get.width / 100;
  final double _hp = Get.height / 100;
  final double _ratio = (Get.width / Get.height) * 100;

  final HomeController controller = Get.put(HomeController());
  final DashboardController dashboardController =
      Get.put(DashboardController());
  final CourseProgressTabController _tabx =
      Get.put(CourseProgressTabController());
  final QuizController quizController = Get.put(QuizController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pinnedHeaderHeight = 40.sp;

    return Scaffold(
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: SpinKitPulse(
            color: Get.theme.primaryColor,
            size: 30.sp,
          ),
        ),
        child: Obx(() {
          if (controller.isCourseLoading.value) {
            return Center(
              child: activityIndicator(),
            );
          }

          String coverImage = getYoutubeThumbnailUrl(
                  controller.selectedChapterContent.value?.videoUrl) ??
              getFullResourceUrl(controller.courseDetail.value.thumbnail ?? '');

          double expandedHeight = _ratio > 70 ? 400.sp : 560.sp;

          return extend.ExtendedNestedScrollView(
            headerSliverBuilder:
                (BuildContext headerContext, bool? innerBoxIsScrolled) {
              return <Widget>[
                _buildAppBar(expandedHeight, coverImage, context),
              ];
            },
            pinnedHeaderSliverHeightBuilder: () {
              return pinnedHeaderHeight;
            },
            body: Column(
              children: <Widget>[
                TabBar(
                  tabs: _tabx.myTabs,
                  controller: _tabx.controller,
                  indicator: Get.theme.tabBarTheme.indicator,
                  automaticIndicatorColorAdjustment: true,
                  isScrollable: false,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabx.controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      curriculumWidget(
                          context, controller, dashboardController),
                      reviewWidget(controller, dashboardController)
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  SliverAppBar _buildAppBar(
      double expandedHeight, String coverImage, BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Container(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Container(
                width: _wp * 100,
                padding:
                    EdgeInsets.only(top: _hp * 4, left: 20.sp, right: 20.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_ios_new_rounded,
                              color: AppStyles.primary, size: 16.sp),
                          SizedBox(
                            width: 5.sp,
                          ),
                          Text(
                            'Quay Lại',
                            style: AppTextThemes.heading6().copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppStyles.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.sp,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.sp),
                      width: Get.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            courseTitleText(controller.courseDetail.value.name),
                            SizedBox(
                              height: 5.sp,
                            ),
                            Text('Vui lòng ấn nút ở dưới để tiếp tục học',
                                style: AppTextThemes.label4()
                                    .copyWith(fontWeight: FontWeight.bold)),
                          ]),
                    ),
                    SizedBox(
                      height: 5.sp,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: _ratio > 70 ? 170.sp : 220.sp,
                          width: _ratio > 70 ? 170.sp : 220.sp,
                          padding: EdgeInsets.all(5.sp),
                          decoration: LayoutUtils.boxDecoration(),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(5.sp),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.2),
                                          BlendMode.dstATop),
                                      image: NetworkImage(coverImage),
                                    ),
                                  )),
                              Positioned(
                                  child: AvatarGlow(
                                glowColor: AppStyles.blueLight,
                                endRadius: 110.sp,
                                duration: const Duration(milliseconds: 2000),
                                repeat: true,
                                showTwoGlows: true,
                                repeatPauseDuration:
                                    const Duration(milliseconds: 100),
                                child: GestureDetector(
                                    onTap: () async {
                                      context.loaderOverlay.show();

                                      ChapterContentTypeEnum
                                          chapterContentType =
                                          CourseUtils.getChapterContentType(
                                              controller.selectedChapterContent
                                                  .value!,
                                              false);

                                      if (chapterContentType ==
                                          ChapterContentTypeEnum.QUIZ) {
                                        quizController.quizInCourseIndex =
                                            controller.getQuizInCourseIndex(
                                                    chapterId: controller
                                                        .selectedChapter
                                                        .value!
                                                        .id,
                                                    quizId: controller
                                                        .selectedChapterContent
                                                        .value!
                                                        .quizId) ??
                                                -1;
                                        quizController.quizID.value = controller
                                                .selectedChapterContent
                                                .value
                                                ?.quizId ??
                                            0;
                                        var result = await quizController
                                            .fetchQuizDetail();

                                        if (result != null) {
                                          Get.to(() => const QuizDetailPage(
                                                lastPage: 'course',
                                              ));
                                        } else {
                                          AlertUtils.error();
                                        }
                                      } else {
                                        var result = await controller
                                            .fetchLectureDetail(controller
                                                    .selectedChapterContent
                                                    .value
                                                    ?.lessonId ??
                                                0);

                                        if (result) {
                                          Get.to(() => const LectureDetailPage(
                                                lastPage: 'course',
                                                isEnrolled: true,
                                              ));
                                        } else {
                                          AlertUtils.error();
                                        }
                                      }

                                      context.loaderOverlay.hide();
                                    },
                                    child: Material(
                                      color: AppStyles.blueLighter,
                                      shape: const CircleBorder(),
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        size: 70.sp,
                                        color: AppStyles.blueDark,
                                      ),
                                    )),
                              ))
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 5.sp,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5.sp,
                            ),
                            Text(
                                controller.selectedChapter.value?.name ?? 'N/A',
                                maxLines: 3,
                                style: AppTextThemes.label2().copyWith(
                                    color: AppStyles.blueDark,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 5.sp,
                            ),
                            Text(
                                controller.selectedChapterContent.value?.name ??
                                    'N/A',
                                maxLines: 3,
                                style: AppTextThemes.label3().copyWith(
                                    color: AppStyles.blueLight,
                                    fontWeight: FontWeight.bold))
                          ]),
                    ),
                    SizedBox(
                      height: 5.sp,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20.sp),
                      child: GestureDetector(
                          onTap: () {
                            Get.off(() => const CourseDetailPage());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Xem thông tin khóa học',
                                style: AppTextThemes.heading7()
                                    .copyWith(color: AppStyles.secondary),
                              ),
                              SizedBox(
                                width: 5.sp,
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: AppStyles.secondary,
                                size: 24.sp,
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget descriptionWidget(
      HomeController controller, DashboardController dashboardController) {
    return CourseDescriptionTabWidget(
        controller: controller, dashboardController: dashboardController);
  }

  Widget curriculumWidget(BuildContext context, HomeController controller,
      DashboardController dashboardController) {
    return CourseCurriculumTabWidget(
        parentContext: context,
        controller: controller,
        dashboardController: dashboardController);
  }

  Widget reviewWidget(
      HomeController controller, DashboardController dashboardController) {
    return CourseReviewTabWidget(
      controller: controller,
      dashboardController: dashboardController,
    );
  }
}
