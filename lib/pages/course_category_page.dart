// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:stna_lms_flutter/controllers/course_category_controller.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/pages/course_detail_page.dart';
// Project imports:
import 'package:stna_lms_flutter/pages/course_progress_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/helpers/loading_helper.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/course/course_full_card_widget.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CourseCategoryPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CourseCategoryPage(
      {Key? key, required this.categoryId, required this.categoryName})
      : super(key: key);

  @override
  _CourseCategoryPageState createState() => _CourseCategoryPageState();
}

class _CourseCategoryPageState extends State<CourseCategoryPage> {
  late int itemCount;

  final CourseCategoryController _controller =
      Get.put(CourseCategoryController());
  final HomeController _homeController = Get.put(HomeController());
  final DashboardController _dashboardController =
      Get.put(DashboardController());

  onSearchTextChanged(String text) async {
    _controller.courseList.value = [];
    await _controller.fetchCourseByCategory(widget.categoryId, text);
    _controller.displayText.value =
        'Có ${_controller.courseList.length} khóa học với từ khóa "$text"';
  }

  Future<void> refresh() async {
    _controller.courseList.value = [];
    await _controller.fetchCourseByCategory(widget.categoryId, null);
    _controller.displayText.value =
        "Có ${_controller.courseList.length} khóa học";
  }

  @override
  void initState() {
    super.initState();

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    itemCount = 2;

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: defaultLoadingWidget,
      child: SafeArea(
        child: Scaffold(
          key: _controller.scaffoldKey,
          appBar: AppBarWidget(
            title: "Danh Mục: ${widget.categoryName}",
            showBack: true,
            showSearch: true,
            searching: onSearchTextChanged,
          ),
          body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Obx(() {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 20.sp, bottom: 0.sp, right: 20.sp, top: 10.sp),
                      child: textHeading(_controller.displayText.value));
                }),
                Container(
                    margin: EdgeInsets.only(bottom: 5.sp),
                    child: Obx(() {
                      if (_controller.isLoading.value) {
                        return Center(
                          child: activityIndicator(),
                        );
                      } else {
                        return _controller.courseList.isNotEmpty
                            ? GridView.builder(
                                padding: EdgeInsets.only(
                                    left: 20.sp,
                                    right: 20.sp,
                                    top: 10.sp,
                                    bottom: 10.sp),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: itemCount < 2 ? 2 : itemCount,
                                  crossAxisSpacing: 20.sp,
                                  mainAxisSpacing: 20.sp,
                                  mainAxisExtent: 355.sp,
                                ),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: _controller.courseList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return CourseFullCardWidget(
                                    image: getFullResourceUrl(_controller
                                            .courseList[index].thumbnail ??
                                        ''),
                                    expiredDate: _controller
                                        .courseList[index].courseExpiredDate,
                                    title: _controller.courseList[index].name ??
                                        'N/A',
                                    price: _dashboardController
                                            .systemInformation
                                            .value!
                                            .releaseMode
                                        ? _controller.courseList[index].price
                                        : 1.0,
                                    isEnrolled: _controller
                                        .courseList[index].isEnrolled,
                                    rating:
                                        _controller.courseList[index].rating,
                                    onTap: () async {
                                      context.loaderOverlay.show();

                                      _homeController.courseID.value =
                                          _controller.courseList[index].id ?? 0;

                                      var course = await _homeController
                                          .fetchCourseDetail();

                                      context.loaderOverlay.hide();

                                      if (course == null) {
                                        AlertUtils.warn(
                                            'Khóa học đang được xây dựng. Vui lòng quay lại sau');
                                        return;
                                      }

                                      if (course.isEnrolled) {
                                        Get.to(
                                            () => const CourseProgressPage());
                                      } else {
                                        Get.to(() => const CourseDetailPage());
                                      }
                                    },
                                  );
                                })
                            : Container();
                      }
                    })),
                // _buildTopCategoryList(context, _homeController)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
