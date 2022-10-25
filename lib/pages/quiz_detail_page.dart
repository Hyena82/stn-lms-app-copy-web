// Dart imports:

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
import 'package:flutter/foundation.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/controllers/my_quiz_detail_tab_controller.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/quiz_detail/quiz_description_tab_widget.dart';
import 'package:stna_lms_flutter/widgets/quiz_detail/quiz_history_tab_widget.dart';
import 'package:stna_lms_flutter/widgets/quiz_detail/quiz_review_tab_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:stna_lms_flutter/utils/course_utils.dart';

class QuizDetailPage extends StatefulWidget {
  final String? lastPage;

  const QuizDetailPage({Key? key, this.lastPage}) : super(key: key);

  @override
  State<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  final _wp = Get.width / 100;
  final _hp = Get.height / 100;
  final double _ratio = (Get.width / Get.height) * 100;

  final QuizController controller = Get.put(QuizController());
  final DashboardController dashboardController =
      Get.put(DashboardController());
  final MyQuizDetailTabController _tabx = Get.put(MyQuizDetailTabController());
  final HomeController homeController = Get.put(HomeController());

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
            if (controller.isQuizLoading.value) {
              return Center(
                child: activityIndicator(),
              );
            }

            double expandedHeight = _ratio > 70 ? 380.sp : 520.sp;

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
                                  top: _hp * 5, left: 20.sp, right: 20.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (widget.lastPage != null) {
                                        context.loaderOverlay.show();
                                        await homeController
                                            .fetchCourseDetail();
                                        context.loaderOverlay.hide();
                                        Get.back();
                                      } else {
                                        Get.back();
                                      }
                                    },
                                    child: Row(
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
                                      margin: EdgeInsets.only(
                                          left: 15.sp, right: 15.sp),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.sp)),
                                          child: LayoutUtils.fadeInImage(
                                              width: kIsWeb ? 300 : null,
                                              image: NetworkImage(
                                                  getFullResourceUrl(controller
                                                          .quizDetail
                                                          .value!
                                                          .cover ??
                                                      '')),
                                              error:
                                                  'images/layout/sorry-16x9.jpg',
                                              placeholder:
                                                  'images/placeholders/image-loading-16x9.jpg',
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
                                          courseTitleText(controller
                                              .quizDetail.value?.name),
                                          SizedBox(
                                            height: 5.sp,
                                          ),
                                          courseAuthorNameText(controller
                                                  .quizDetail.value?.brief ??
                                              ''),
                                          // Container(
                                          //     child: Text('Thông tin thêm',
                                          //         maxLines: 1,
                                          //         style: AppTextThemes.label4()
                                          //             .copyWith(
                                          //                 fontWeight: FontWeight
                                          //                     .bold))),
                                          // _buildMetricInlineWidget(
                                          //   icon: Icons.person_outline_rounded,
                                          //   metric:
                                          //       'Người tạo ${controller.quizDetail.value?.createdBy}',
                                          // ),
                                          // _buildMetricInlineWidget(
                                          //   icon: Icons.date_range_rounded,
                                          //   metric:
                                          //       'Cập nhật ${controller.quizDetail.value?.updateAt == null ? 'N/A' : DateHelper.formatDateTime(controller.quizDetail.value?.updateAt)}',
                                          // ),
                                          // SizedBox(height: 20),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 15.sp,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      _buildMetricWidget(
                                          icon: Icons.star_rate_rounded,
                                          metric: controller
                                              .quizDetail.value!.rating
                                              .toStringAsFixed(1),
                                          color: AppStyles.yellow),
                                      _buildMetricWidget(
                                          icon: Icons.timer_rounded,
                                          metric: durationString(controller
                                              .quizDetail.value!.duration),
                                          color: AppStyles.red),
                                      _buildMetricWidget(
                                          icon: Icons.rate_review_rounded,
                                          metric: controller
                                              .quizDetail.value!.totalReviews
                                              .toString(),
                                          color: AppStyles.green)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        LayoutUtils.button(
                                            text: "Bắt Đầu",
                                            onPressed: () async {
                                              context.loaderOverlay.show();

                                              Get.defaultDialog(
                                                  title: controller.quizDetail
                                                          .value!.isSurvey
                                                      ? 'Khảo Sát'
                                                      : 'Kiểm Tra',
                                                  backgroundColor:
                                                      Get.theme.cardColor,
                                                  titleStyle:
                                                      AppTextThemes.heading6(),
                                                  barrierDismissible: true,
                                                  radius: 5.sp,
                                                  content: CourseUtils
                                                      .startTimingQuizDialogWidget(
                                                          controller));

                                              context.loaderOverlay.hide();
                                            })
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
                        historyWidget(controller, dashboardController),
                        reviewWidget(controller, dashboardController),
                      ],
                    ),
                  )
                ],
              ),
            );
          })),
    );
  }

  Widget descriptionWidget(
      QuizController controller, DashboardController dashboardController) {
    return QuizDescriptionTabWidget(
      controller: controller,
      dashboardController: dashboardController,
    );
  }

  Widget reviewWidget(
      QuizController controller, DashboardController dashboardController) {
    return QuizReviewTabWidget(
        controller: controller, dashboardController: dashboardController);
  }

  Widget historyWidget(
      QuizController controller, DashboardController dashboardController) {
    return QuizHistoryTabWidget(
        controller: controller, dashboardController: dashboardController);
  }
}
