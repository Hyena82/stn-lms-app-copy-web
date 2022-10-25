// Dart imports:

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/course_detail_tab_controller.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/controllers/payment_controller.dart';
import 'package:stna_lms_flutter/helpers/currency_helper.dart';
import 'package:stna_lms_flutter/pages/course_progress_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/course_utils.dart';
import 'package:stna_lms_flutter/utils/enum_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/course_detail/course_curriculum_tab_widget.dart';
import 'package:stna_lms_flutter/widgets/course_detail/course_description_tab_widget.dart';
import 'package:stna_lms_flutter/widgets/course_detail/course_review_tab_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CourseDetailPage extends StatefulWidget {
  final String? lastPage;

  const CourseDetailPage({Key? key, this.lastPage}) : super(key: key);

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final double _wp = Get.width / 100;
  final double _hp = Get.height / 100;
  final double _ratio = (Get.width / Get.height) * 100;
  final HomeController controller = Get.put(HomeController());
  final DashboardController dashboardController =
      Get.put(DashboardController());
  final CourseDetailTabController _tabx = Get.put(CourseDetailTabController());
  final PaymentController _paymentController = Get.put(PaymentController());

  Widget _buildMetricWidget(
      {required IconData icon, required String metric, Color? color}) {
    return Container(
      width: _wp * 25,
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
      decoration: LayoutUtils.boxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color ?? AppStyles.blueDark,
                size: 14.sp,
              ),
              SizedBox(
                width: 5.sp,
              ),
              Text(
                metric,
                style: AppTextThemes.heading6()
                    .copyWith(color: color ?? AppStyles.blueDark),
              )
            ],
          ),
        ],
      ),
    );
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

          var releaseMode =
              dashboardController.systemInformation.value!.releaseMode;
          var price = releaseMode ? controller.courseDetail.value.price : 0.0;
          CourseActionTypeEnum courseActionType =
              CourseUtils.getCourseActionType(
                  isEmpty: controller.courseChapters.isEmpty,
                  isEnrolled: controller.courseDetail.value.isEnrolled,
                  isVip: dashboardController.profileData.value.isVip,
                  price: price);

          double expandedHeight = 580.sp;

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
                            width: _wp * 100,
                            padding: EdgeInsets.only(
                                top: _hp * 4, left: 10.sp, right: 10.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.arrow_back_ios_new_rounded,
                                          color: AppStyles.primary,
                                          size: 16.sp),
                                      SizedBox(
                                        width: 10.sp,
                                      ),
                                      Text(
                                        'Quay Lại',
                                        style:
                                            AppTextThemes.heading6().copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppStyles.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.sp,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: LayoutUtils.boxDecoration(),
                                    padding: EdgeInsets.all(5.sp),
                                    height: _ratio > 70 ? 100.sp : 220.sp,
                                    margin: EdgeInsets.only(
                                        left: 10.sp, right: 10.sp),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.sp)),
                                        child: thumbnailImage(
                                            controller
                                                .courseDetail.value.thumbnail,
                                            fit: BoxFit.contain)),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.sp,
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.sp),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        courseTitleText(
                                            controller.courseDetail.value.name),
                                        SizedBox(
                                          height: 5.sp,
                                        ),
                                        courseAuthorNameText(controller
                                                .courseDetail.value.brief ??
                                            controller.courseDetail.value
                                                .description ??
                                            '')
                                      ]),
                                ),
                                SizedBox(
                                  height: 10.sp,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _buildMetricWidget(
                                        icon: Icons.star_rate_rounded,
                                        metric: controller
                                            .courseDetail.value.rating
                                            .toStringAsFixed(1),
                                        color: AppStyles.yellow),
                                    _buildMetricWidget(
                                        icon: Icons.person_pin_sharp,
                                        metric: controller
                                            .courseDetail.value.totalEnrolled
                                            .toString(),
                                        color: AppStyles.red),
                                    _buildMetricWidget(
                                        icon: Icons.rate_review_rounded,
                                        metric: controller
                                            .courseDetail.value.totalReviews
                                            .toString(),
                                        color: AppStyles.green)
                                  ],
                                ),
                                SizedBox(
                                  height: 15.sp,
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20.sp),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        (price == 0)
                                            ? Text(
                                                releaseMode
                                                    ? 'Khóa học đang được miễn phí'
                                                    : '',
                                                textAlign: TextAlign.center,
                                                style: AppTextThemes.heading4()
                                                    .copyWith(
                                                        color:
                                                            AppStyles.secondary,
                                                        fontWeight:
                                                            FontWeight.bold))
                                            : Text(CurrencyHelper.format(price),
                                                textAlign: TextAlign.center,
                                                style: AppTextThemes.heading3()
                                                    .copyWith(
                                                        color:
                                                            AppStyles.blueDark,
                                                        fontWeight:
                                                            FontWeight.bold))
                                      ],
                                    )),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildCourseAction(
                                          context, courseActionType)
                                    ])
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
                      descriptionWidget(controller, dashboardController),
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

  Widget _buildCourseAction(
      BuildContext parentContext, CourseActionTypeEnum type) {
    switch (type) {
      case CourseActionTypeEnum.UNDER_CONSTRUCTION:
        return Container(
          margin: EdgeInsets.only(top: 5.sp),
          padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.sp),
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5.sp)),
          child: Text('Khóa học đang được xây dựng',
              style: AppTextThemes.heading6()
                  .copyWith(color: AppStyles.secondary)),
        );
      case CourseActionTypeEnum.BUY_NOW:
        return LayoutUtils.button(
            text: 'Mua Ngay',
            onPressed: () async {
              await dashboardController.getSystemInformation();
              _paymentController.showPaymentInstructionDialog();
            });
      case CourseActionTypeEnum.ENROLL_NOW:
        return LayoutUtils.button(
            text: 'Đăng Ký Ngay',
            onPressed: () async {
              parentContext.loaderOverlay.show();

              if (dashboardController.loggedIn.value) {
                bool result = await controller
                    .enrollCourse(controller.courseDetail.value.id ?? 0);
                if (result == true) {
                  var courseDetail = await controller.fetchCourseDetail();

                  if (courseDetail == null) {
                    AlertUtils.warn(
                        'Khóa học đang được xây dựng. Vui lòng quay lại sau');
                    return;
                  }

                  Get.off(() => const CourseProgressPage());
                  return;
                } else {
                  AlertUtils.error();
                }
              }

              parentContext.loaderOverlay.hide();
            });
      default:
        return Container();
    }
  }

  Widget descriptionWidget(
      HomeController controller, DashboardController dashboardController) {
    return CourseDescriptionTabWidget(
        controller: controller, dashboardController: dashboardController);
  }

  Widget curriculumWidget(BuildContext buildContext, HomeController controller,
      DashboardController dashboardController) {
    return CourseCurriculumTabWidget(
        parentContext: buildContext,
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
