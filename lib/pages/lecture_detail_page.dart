// Dart imports:

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/pages/course_detail_page.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/helpers/date_helper.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/lesson_viewer/lesson_viewer_audio_widget.dart';
import 'package:stna_lms_flutter/widgets/lesson_viewer/lesson_viewer_gallery_widget.dart';
import 'package:stna_lms_flutter/widgets/lesson_viewer/lesson_viewer_video_widget.dart';
import 'package:stna_lms_flutter/widgets/lesson_viewer/lesson_viewer_youtube_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

// ignore: must_be_immutable
class LectureDetailPage extends StatefulWidget {
  final bool isEnrolled;
  final String? lastPage;

  const LectureDetailPage({Key? key, this.isEnrolled = false, this.lastPage})
      : super(key: key);

  @override
  State<LectureDetailPage> createState() => _LectureDetailPageState();
}

class _LectureDetailPageState extends State<LectureDetailPage>
    with TickerProviderStateMixin {
  final double _wp = Get.width / 100;
  final double _hp = Get.height / 100;

  final HomeController controller = Get.put(HomeController());
  final DashboardController dashboardController =
      Get.put(DashboardController());

  final List<Tab> _tabs = [];
  final List<Widget> _tabContents = [];
  late TabController _tabController;

  @override
  void initState() {
    if (!isEmpty(controller.lectureDetail.value!.youtubeUrl)) {
      _tabs.add(Tab(
          icon: FaIcon(
        FontAwesomeIcons.youtube,
        size: 14.sp,
      )));
      _tabContents.add(youtubeWidget(controller, dashboardController));
    } else if (controller.lectureDetail.value!.audios != null &&
        controller.lectureDetail.value!.audios!.isNotEmpty) {
      _tabs.add(Tab(
          icon: FaIcon(
        FontAwesomeIcons.music,
        size: 14.sp,
      )));
      _tabContents.add(audioWidget(controller, dashboardController));
    } else if (!isEmpty(controller.lectureDetail.value!.video)) {
      _tabs.add(Tab(
          icon: FaIcon(
        FontAwesomeIcons.video,
        size: 14.sp,
      )));
      _tabContents.add(videoWidget(controller, dashboardController));
    }

    if (controller.lectureDetail.value!.images != null &&
        controller.lectureDetail.value!.images!.isNotEmpty) {
      _tabs.add(Tab(
          icon: FaIcon(
        FontAwesomeIcons.images,
        size: 14.sp,
      )));
      _tabContents.add(imageGalleryWidget(controller, dashboardController));
    }

    _tabController =
        TabController(vsync: this, length: _tabs.length, initialIndex: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          if (controller.isLectureLoading.value) {
            return Center(
              child: activityIndicator(),
            );
          }

          bool hasBrief = controller.lectureDetail.value!.brief != null &&
              controller.lectureDetail.value!.brief != '';
          bool hasNotes = controller.lectureDetail.value!.notes != null &&
              controller.lectureDetail.value!.notes != '';

          if (!hasBrief && !hasNotes) {
            return bodyLectureWithoutNotes();
          }

          return bodyLectureWithNotes(hasBrief: hasBrief, hasNotes: hasNotes);
        }),
      ),
    );
  }

  void _updateLectureProgressVideo(percentage, position) {
    if (!widget.isEnrolled) return;

    if (percentage % 2 == 0) {
      controller.postUpdateCourseLectureProgress(
          controller.lectureDetail.value!.id ?? 0,
          finished: percentage >= 90,
          percentage: percentage,
          checkpoint: position);

      if (percentage >= 90) {
        controller.fetchCourseChapter();
        controller.fetchProgressingCourse();
      }
    }
  }

  Widget videoWidget(
      HomeController controller, DashboardController dashboardController) {
    return LessonViewerVideoWidget(
        controller: controller,
        dashboardController: dashboardController,
        updateProgress: (percentage, position) {
          _updateLectureProgressVideo(percentage, position);
        });
  }

  Widget youtubeWidget(
      HomeController controller, DashboardController dashboardController) {
    return LessonViewerYoutubeWidget(
        controller: controller,
        dashboardController: dashboardController,
        updateProgress: (percentage, position) {
          _updateLectureProgressVideo(percentage, position);
        });
  }

  Widget audioWidget(
      HomeController controller, DashboardController dashboardController) {
    return LessonViewerAudioWidget(
        controller: controller,
        dashboardController: dashboardController,
        updateProgress: (percentage, position) {
          _updateLectureProgressVideo(percentage, position);
        });
  }

  Widget imageGalleryWidget(
      HomeController controller, DashboardController dashboardController) {
    return LessonViewerGalleryWidget(
      controller: controller,
      dashboardController: dashboardController,
    );
  }

  Widget bodyLectureWithNotes({bool hasBrief = false, bool hasNotes = false}) {
    double expandedHeight;
    if (_tabs.isEmpty) {
      expandedHeight = 250.sp;
    } else {
      if (controller.lectureDetail.value!.audios != null &&
          controller.lectureDetail.value!.audios!.isNotEmpty) {
        expandedHeight = _hp * 40 > 550.sp ? _hp * 30 : 550.sp;
      } else {
        expandedHeight = _hp * 70;
      }
    }

    return extend.ExtendedNestedScrollView(
        headerSliverBuilder: (BuildContext context, bool? innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: expandedHeight,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: _wp * 100,
                      padding: EdgeInsets.only(
                          top: _hp * 4, left: 20.sp, right: 20.sp),
                      child: GestureDetector(
                        onTap: () async {
                          if (widget.lastPage != null) {
                            context.loaderOverlay.show();
                            await controller.fetchCourseDetail();
                            context.loaderOverlay.hide();
                            Get.back();
                          } else {
                            Get.back();
                          }
                        },
                        child: Row(
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
                    ),
                    SizedBox(
                      height: 5.sp,
                    ),
                    _tabs.isNotEmpty
                        ? Expanded(
                            child: Container(
                                decoration: LayoutUtils.boxDecoration(),
                                margin: EdgeInsets.symmetric(
                                    vertical: 0.sp, horizontal: 10.sp),
                                padding: EdgeInsets.all(5.sp),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TabBar(
                                      tabs: _tabs,
                                      controller: _tabController,
                                      indicator:
                                          Get.theme.tabBarTheme.indicator,
                                      automaticIndicatorColorAdjustment: true,
                                      isScrollable: false,
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        controller: _tabController,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: _tabContents,
                                      ),
                                    )
                                  ],
                                )))
                        : Container(),
                    SizedBox(
                      height: 10.sp,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                controller.selectedChapterContent.value?.name ??
                                    'N/A',
                                maxLines: 3,
                                style: AppTextThemes.label2().copyWith(
                                    color: AppStyles.blueDark,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 5.sp,
                            ),
                            Text(
                                controller.selectedChapter.value?.name ?? 'N/A',
                                maxLines: 3,
                                style: AppTextThemes.label3().copyWith(
                                    color: AppStyles.blueLight,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 5.sp,
                            ),
                            controller.lectureDetail.value!.updateAt == null
                                ? Container()
                                : Row(
                                    children: [
                                      Text('Ngày cập nhật',
                                          style: AppTextThemes.label4()),
                                      SizedBox(
                                        width: 7.sp,
                                      ),
                                      Text(
                                          DateHelper.formatDateTime(controller
                                              .lectureDetail.value!.updateAt),
                                          style: AppTextThemes.label4()
                                              .copyWith(
                                                  fontWeight: FontWeight.bold))
                                    ],
                                  ),
                            SizedBox(
                              height: 10.sp,
                            ),
                            GestureDetector(
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
                                      Icons.arrow_right_alt_rounded,
                                      color: Get.theme.primaryColor,
                                      size: 22.sp,
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 10.sp,
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: (
                  // widget.isEnrolled
                  //   ?
                  Container(
            decoration: BoxDecoration(
                color: AppStyles.blueDark.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.sp),
                    topRight: Radius.circular(20.sp))),
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: GestureDetector(
                onTap: () async {
                  Get.back();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          controller.toPreviousLecture(
                              controller.courseDetail.value.isEnrolled,
                              controller.courseDetail.value.hasFlow);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_left_rounded,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                            SizedBox(
                              width: 5.sp,
                            ),
                            Text(
                              'Trước',
                              style: AppTextThemes.heading5()
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        )),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.list_alt_rounded,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          await controller.toNextLecture(
                              controller.courseDetail.value.isEnrolled,
                              controller.courseDetail.value.hasFlow);
                        },
                        child: Row(
                          children: [
                            Text(
                              'Tiếp',
                              style: AppTextThemes.heading5()
                                  .copyWith(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5.sp,
                            ),
                            Icon(
                              Icons.arrow_right_rounded,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ],
                        ))
                  ],
                )),
          )
              // : const Text("i'm missing")
              ),
          body: Container(
              decoration: BoxDecoration(
                  color: AppStyles.blueDark.withOpacity(0.8),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.sp),
                      topRight: Radius.circular(20.sp))),
              child: Container(
                  margin: EdgeInsets.only(top: 5.sp, right: 5.sp, left: 5.sp),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 0),
                    children: [
                      SizedBox(
                        height: 5.sp,
                      ),
                      !hasBrief
                          ? Container()
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.sp),
                              margin: EdgeInsets.only(bottom: 20.sp),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                      width: 7.sp,
                                      color: AppStyles.blueLight,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              child: HtmlWidget(
                                controller.lectureDetail.value!.brief ?? '',
                                customStylesBuilder: (element) {
                                  if (element.classes.contains('foo')) {
                                    return {'color': 'red'};
                                  }
                                  return null;
                                },
                                customWidgetBuilder: (element) {
                                  if (element.attributes['foo'] == 'bar') {
                                    // return FooBarWidget();
                                  }
                                  return null;
                                },
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.sp,
                                    height: (1.5).sp,
                                    letterSpacing: 1.0,
                                    wordSpacing: 1.0,
                                    color: Colors.white),
                              ),
                            ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        child: hasNotes
                            ? longTextSection(
                                null, controller.lectureDetail.value!.notes)
                            : Container(),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                    ],
                  ))),
        ));
  }

  Widget bodyLectureWithoutNotes() {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          // widget.isEnrolled
          //     ?
          Container(
        decoration: BoxDecoration(
            color: AppStyles.blueDark.withOpacity(0.8),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp),
                topRight: Radius.circular(20.sp))),
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: GestureDetector(
            onTap: () async {
              Get.back();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      controller.toPreviousLecture(
                          controller.courseDetail.value.isEnrolled,
                          controller.courseDetail.value.hasFlow);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_left_rounded,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                        SizedBox(
                          width: 5.sp,
                        ),
                        Text(
                          'Trước',
                          style: AppTextThemes.heading5()
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    )),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.list_alt_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      await controller.toNextLecture(
                          controller.courseDetail.value.isEnrolled,
                          controller.courseDetail.value.hasFlow);
                    },
                    child: Row(
                      children: [
                        Text(
                          'Tiếp',
                          style: AppTextThemes.heading5()
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(
                          width: 5.sp,
                        ),
                        Icon(
                          Icons.arrow_right_rounded,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ],
                    ))
              ],
            )),
      )
      // : Container()
      ,
      body: SizedBox(
        height: _hp * 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: _wp * 100,
              padding: EdgeInsets.only(top: _hp * 4, left: 20.sp, right: 20.sp),
              child: GestureDetector(
                onTap: () async {
                  if (widget.lastPage != null) {
                    context.loaderOverlay.show();
                    await controller.fetchCourseDetail();
                    context.loaderOverlay.hide();
                    Get.back();
                  } else {
                    Get.back();
                  }
                },
                child: Row(
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
            ),
            SizedBox(
              height: 5.sp,
            ),
            _tabs.isNotEmpty
                ? Expanded(
                    child: Container(
                        decoration: LayoutUtils.boxDecoration(),
                        margin: EdgeInsets.symmetric(
                            vertical: 0.sp, horizontal: 10.sp),
                        padding: EdgeInsets.all(5.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TabBar(
                              tabs: _tabs,
                              controller: _tabController,
                              indicator: Get.theme.tabBarTheme.indicator,
                              automaticIndicatorColorAdjustment: true,
                              isScrollable: false,
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: _tabContents,
                              ),
                            )
                          ],
                        )))
                : Container(),
            SizedBox(
              height: 10.sp,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.selectedChapterContent.value?.name ?? 'N/A',
                        maxLines: 3,
                        style: AppTextThemes.label2().copyWith(
                            color: AppStyles.blueDark,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5.sp,
                    ),
                    Text(controller.selectedChapter.value?.name ?? 'N/A',
                        maxLines: 3,
                        style: AppTextThemes.label3().copyWith(
                            color: AppStyles.blueLight,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5.sp,
                    ),
                    controller.lectureDetail.value!.updateAt == null
                        ? Container()
                        : Row(
                            children: [
                              Text('Ngày cập nhật',
                                  style: AppTextThemes.label4()),
                              SizedBox(
                                width: 7.sp,
                              ),
                              Text(
                                  DateHelper.formatDateTime(
                                      controller.lectureDetail.value!.updateAt),
                                  style: AppTextThemes.label4()
                                      .copyWith(fontWeight: FontWeight.bold))
                            ],
                          ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    GestureDetector(
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
                              Icons.arrow_right_alt_rounded,
                              color: Get.theme.primaryColor,
                              size: 22.sp,
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 10.sp,
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
