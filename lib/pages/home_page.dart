// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Package imports:

import 'package:get/get.dart';
import 'package:logger_console/logger_console.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/course_search_controller.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/my_course_controller.dart';
import 'package:stna_lms_flutter/controllers/notification_controller.dart';
import 'package:stna_lms_flutter/models/course_model.dart';
import 'package:stna_lms_flutter/pages/course_progress_page.dart';
import 'package:stna_lms_flutter/pages/course_detail_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/helpers/date_helper.dart';
import 'package:stna_lms_flutter/helpers/loading_helper.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/course/course_card_widget.dart';
import 'package:stna_lms_flutter/widgets/loading/loading_skeleton_item_widget.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

// Project imports:
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';

class HomePage extends GetView<HomeController> {
  final DashboardController dashboardController =
      Get.put(DashboardController());
  final CourseSearchController allCourseController =
      Get.put(CourseSearchController());
  final HomeController homeController = Get.put(HomeController());
  final MyCourseController myCourseController = Get.put(MyCourseController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  final _wp = Get.width / 100;

  HomePage({Key? key}) : super(key: key);

  Future<void> refresh() async {
    notificationController.getNotifications();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (controller.trialCourseList.length <= 1 ||
          controller.latestCourseList.length <= 1) {
        controller.onInit();
      }
    });

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: defaultLoadingWidget,
      child: SafeArea(
        child: Scaffold(
          appBar: const AppBarWidget(),
          body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Obx(() {
                  return _buildAdBanner(context, controller);
                }),
                Obx(() {
                  return _buildProgressingCourse(context, controller);
                }),
                _buildVerticalCourseList(context, controller,
                    title: 'Trải nghiệm và sự kiện',
                    courses: controller.trialCourseList),
                _buildVerticalCourseList(context, controller,
                    title: 'Khóa học mới nhất',
                    courses: controller.latestCourseList),
                SizedBox(
                  height: 40.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalCourseList(
      BuildContext context, HomeController controller,
      {required String title, required RxList<CourseModel> courses}) {
    Console.log('_buildVerticalCourseList', courses.length);

    return Column(
      children: [
        Obx(() {
          if (!controller.isLoading.value && courses.isEmpty) {
            return Container();
          }

          return Container(
              margin: EdgeInsets.only(
                left: 20.sp,
                bottom: 0,
                top: 0,
                right: 20.sp,
              ),
              width: 500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  textHeading(title),
                  Expanded(
                    child: Container(),
                  ),
                  GestureDetector(
                    child: seeAllText(),
                    onTap: () {
                      dashboardController.changeTabIndex(1,
                          courseSearchController: allCourseController);
                    },
                  )
                ],
              ));
        }),
        Obx(() {
          if (!controller.isLoading.value && courses.isEmpty) {
            return Container();
          }

          if ((controller.isLoading.value || courses.isEmpty)) {
            return const LoadingSkeletonItemWidget();
          }

          return SizedBox(
            height: 360.sp,
            child: ListView.separated(
                padding:
                    EdgeInsets.only(bottom: 15.sp, left: 20.sp, top: 10.sp),
                scrollDirection: Axis.horizontal,
                itemCount: courses.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 15.sp,
                  );
                },
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return CourseCardWidget(
                    image: getFullResourceUrl(courses[index].thumbnail ?? ''),
                    title: courses[index].name ?? 'N/A',
                    expiredDate: courses[index].userCourseExpiredDate,
                    isEnrolled: courses[index].isEnrolled,
                    rating: courses[index].rating,
                    price:
                        dashboardController.systemInformation.value!.releaseMode
                            ? courses[index].price
                            : 1.0,
                    onTap: () async {
                      context.loaderOverlay.show();

                      controller.courseID.value = courses[index].id ?? 0;

                      var course = await controller.fetchCourseDetail();

                      context.loaderOverlay.hide();

                      if (course == null) {
                        AlertUtils.warn(
                            'Khóa học đang được xây dựng. Vui lòng quay lại sau');
                        return;
                      }

                      if (course.isEnrolled == true) {
                        Get.to(() => const CourseProgressPage());
                      } else {
                        Get.to(() => const CourseDetailPage());
                      }
                    },
                  );
                }),
          );
        }),
      ],
    );
  }

  Widget _buildAdBanner(BuildContext context, HomeController controller) {
    var hasBanner =
        dashboardController.systemInformation.value?.adBanner == null;
    return hasBanner
        ? Container()
        : GestureDetector(
            onTap: () async {
              var linkStr = dashboardController.systemInformation.value?.adLink;
              if (linkStr == null) {
                return;
              }

              var link = convertLinkType(linkStr);
              var linkCourseId =
                  dashboardController.systemInformation.value?.adLinkCourseId;

              switch (link) {
                case 'all_course':
                  dashboardController.changeTabIndex(
                    1,
                    courseSearchController: allCourseController,
                  );
                  break;
                case 'utilities':
                  dashboardController.changeTabIndex(2);
                  break;
                case 'home':
                  dashboardController.changeTabIndex(0,
                      homeController: homeController);
                  break;
                case 'my_resources':
                  dashboardController.changeTabIndex(3,
                      myCourseController: myCourseController);
                  break;
                case 'account':
                  dashboardController.changeTabIndex(4);
                  break;
                case 'course':
                  homeController.courseID.value = linkCourseId ?? 0;

                  var course = await homeController.fetchCourseDetail();

                  if (course == null) {
                    AlertUtils.warn(
                        'Khóa học đang được xây dựng. Vui lòng quay lại sau');
                    return;
                  }

                  if (course.isEnrolled) {
                    Get.to(() => const CourseProgressPage());
                  } else {
                    Get.to(() => const CourseDetailPage());
                  }
                  break;
              }
            },
            child: Container(
                decoration: BoxDecoration(
                    gradient: LayoutUtils.gradientGreyLight,
                    borderRadius: BorderRadius.circular(5.sp)),
                margin:
                    EdgeInsets.symmetric(horizontal: 20.sp, vertical: 15.sp),
                padding: EdgeInsets.all(5.sp),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.sp),
                    child: LayoutUtils.fadeInImage(
                        fit: BoxFit.contain,
                        width: double.infinity,
                        placeholder:
                            'images/placeholders/image-loading-16x9.jpg',
                        image: NetworkImage(getFullResourceUrl(
                            dashboardController
                                    .systemInformation.value?.adBanner ??
                                ''))))));
  }

  Widget _buildProgressingCourse(
      BuildContext context, HomeController controller) {
    if (controller.progressingCourse.value.courseId == null) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textHeading("Tiếp tục học"),
              ],
            )),
        Container(
          margin: EdgeInsets.fromLTRB(20.sp, 10.sp, 20.sp, 15.sp),
          child: GestureDetector(
            onTap: () async {
              context.loaderOverlay.show();

              controller.courseID.value =
                  controller.progressingCourse.value.courseId ?? 0;
              var course = await controller.fetchCourseDetail();

              context.loaderOverlay.hide();

              if (course == null) {
                AlertUtils.warn(
                    'Khóa học đang được xây dựng. Vui lòng quay lại sau');
                return;
              }

              if (course.isEnrolled == true) {
                Get.to(() => const CourseProgressPage());
              } else {
                Get.to(() => const CourseDetailPage());
              }
            },
            child: Container(
              decoration: LayoutUtils.boxDecoration(
                hasColor: true,
              ).copyWith(color: Colors.grey.shade200),
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(5.sp),
                      height: 100.sp,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.sp),
                        child: thumbnailImage(
                            controller.progressingCourse.value.thumbnail ?? '',
                            fit: BoxFit.contain),
                      )),
                  Flexible(
                    child: Container(
                      width: _wp * 70,
                      margin: EdgeInsets.only(left: 5.sp, right: 5.sp),
                      padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              controller.progressingCourse.value.contentName ??
                                  'Chưa bắt đầu',
                              style: AppTextThemes.heading7()
                                  .copyWith(color: AppStyles.primary)),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Text(
                              controller.progressingCourse.value.courseName ??
                                  'N/A',
                              style: AppTextThemes.heading8()
                                  .copyWith(color: AppStyles.blueDark)),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Text(
                            DateHelper.formatDateTime(
                                controller.progressingCourse.value.date),
                            style: AppTextThemes.label5()
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppStyles.blueLighter),
                    padding: EdgeInsets.all(5.sp),
                    margin: EdgeInsets.only(right: 10.sp),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: AppStyles.blueLight,
                      size: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
