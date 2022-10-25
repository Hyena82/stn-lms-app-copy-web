// Dart imports:

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/course_search_controller.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/controllers/my_course_controller.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/notification_controller.dart';
import 'package:stna_lms_flutter/helpers/date_helper.dart';
import 'package:stna_lms_flutter/pages/course_detail_page.dart';
import 'package:stna_lms_flutter/pages/course_progress_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:loader_overlay/loader_overlay.dart';

// ignore: must_be_immutable
class NotificationDetailPage extends StatelessWidget {
  final _wp = Get.width / 100;

  final NotificationController _notificationController =
      Get.put(NotificationController());
  final DashboardController _dashboardController =
      Get.put(DashboardController());
  final HomeController _homeController = Get.put(HomeController());
  final CourseSearchController _allCourseController =
      Get.put(CourseSearchController());
  final MyCourseController _myCourseController = Get.put(MyCourseController());

  NotificationDetailPage({Key? key}) : super(key: key);

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
            if (_notificationController.isNotificationDetailLoading.value) {
              return Center(
                child: activityIndicator(),
              );
            }

            var notification = _notificationController.notificationDetail.value;
            var notificationLink = notification.link ?? 'none';
            var notificationDate = notification.createdAt;

            var buttonText = '';
            var color = AppStyles.grey;
            var icon = FontAwesomeIcons.ellipsisH;

            switch (notificationLink) {
              case 'all_course':
                icon = FontAwesomeIcons.bookReader;
                color = AppStyles.colorWheels[0];
                buttonText = 'Xem Tất Cả Khóa Học';
                break;
              case 'utilities':
                icon = FontAwesomeIcons.toolbox;
                color = AppStyles.colorWheels[1];
                buttonText = 'Tiện Ích';
                break;
              case 'home':
                icon = FontAwesomeIcons.home;
                color = AppStyles.colorWheels[2];
                buttonText = 'Trang Chủ';
                break;
              case 'my_resources':
                icon = FontAwesomeIcons.bookmark;
                color = AppStyles.colorWheels[3];
                buttonText = "Khóa Học Đã Mua";
                break;
              case 'account':
                icon = FontAwesomeIcons.user;
                color = AppStyles.colorWheels[4];
                buttonText = 'Tài Khoản';
                break;
              default:
                break;
            }

            double expandedHeight = 200.sp;

            return extend.ExtendedNestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool? innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: expandedHeight,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: Container(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  top: 30.sp, left: 15.sp, right: 15.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: AppStyles.primary,
                                          size: 16.sp,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.sp),
                                          child: Text(
                                            'Quay Lại',
                                            style: AppTextThemes.heading6()
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppStyles.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(15.sp),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: color.withOpacity(0.2)),
                                    child: FaIcon(
                                      icon,
                                      color: color,
                                      size: 28.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.sp,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: _wp * 5),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          courseNameText(_notificationController
                                              .notificationDetail.value.title),
                                          SizedBox(height: 5.sp),
                                        ]),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: _wp * 5),
                                    child: notificationDate == null
                                        ? SizedBox(height: 20.sp)
                                        : Text(
                                            DateHelper.formatDateTime(
                                                notificationDate),
                                            style: TextStyle(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    const Color(0xff8E99B7))),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              pinnedHeaderSliverHeightBuilder: () {
                return pinnedHeaderHeight;
              },
              body: Scaffold(
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniCenterFloat,
                  floatingActionButton: buttonText == ''
                      ? null
                      : LayoutUtils.floatingButton(context, text: buttonText,
                          onPressed: () async {
                          Get.back();
                          Get.back();

                          switch (notificationLink) {
                            case 'all_course':
                              _dashboardController.changeTabIndex(1,
                                  courseSearchController: _allCourseController);
                              break;
                            case 'utilities':
                              _dashboardController.changeTabIndex(2);
                              break;
                            case 'home':
                              _dashboardController.changeTabIndex(
                                0,
                                homeController: _homeController,
                              );
                              break;
                            case 'my_resources':
                              _dashboardController.changeTabIndex(3,
                                  myCourseController: _myCourseController);
                              break;
                            case 'account':
                              _dashboardController.changeTabIndex(4);
                              break;
                            case 'course':
                              int courseId =
                                  dynamicToInt(notification.linkParameter);

                              _homeController.courseID.value = courseId;

                              var course =
                                  await _homeController.fetchCourseDetail();

                              if (course == null) {
                                AlertUtils.warn(
                                    'Khóa học đang được xây dựng. Vui lòng quay lại sau');
                              } else if (course.isEnrolled) {
                                Get.to(() => const CourseProgressPage());
                              } else {
                                Get.to(() => const CourseDetailPage());
                              }
                              break;
                          }
                        }),
                  body: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: _wp * 5, vertical: 0),
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      _notificationController.notificationDetail.value.image ==
                              null
                          ? Container()
                          : Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: LayoutUtils.boxDecoration(),
                                padding: const EdgeInsets.all(5.0),
                                width: Get.width,
                                margin: EdgeInsets.only(
                                    left: _wp * 4, right: _wp * 4),
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    child: LayoutUtils.fadeInImage(
                                        image: NetworkImage(getFullResourceUrl(
                                            _notificationController
                                                    .notificationDetail
                                                    .value
                                                    .image ??
                                                '')),
                                        error: 'images/layout/sorry-16x9.jpg',
                                        placeholder:
                                            'images/placeholders/image-loading-16x9.jpg',
                                        fit: BoxFit.contain)),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      longTextSection(
                        null,
                        _notificationController
                            .notificationDetail.value.content,
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  )),
            );
          })),
    );
  }
}
