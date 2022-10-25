// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:stna_lms_flutter/controllers/course_search_controller.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/pages/course_category_page.dart';
import 'package:stna_lms_flutter/pages/course_detail_page.dart';
// Project imports:
import 'package:stna_lms_flutter/pages/course_progress_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/helpers/loading_helper.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/course/course_full_card_widget.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:stna_lms_flutter/widgets/loading/loading_skeleton.dart';

class CourseSearchPage extends StatefulWidget {
  const CourseSearchPage({Key? key}) : super(key: key);

  @override
  _CourseSearchPageState createState() => _CourseSearchPageState();
}

class _CourseSearchPageState extends State<CourseSearchPage> {
  late int itemCount;

  final CourseSearchController _controller = Get.put(CourseSearchController());
  final HomeController _homeController = Get.put(HomeController());
  final DashboardController _dashboardController =
      Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    refresh();
  }

  onSearchTextChanged(String text) async {
    _controller.allCourseList.value = [];
    await _controller.fetchAllCourse(text);
    _controller.allCourseText.value =
        'Có ${_controller.allCourseList.length} khóa học với từ khóa "$text"';
  }

  Future<void> refresh() async {
    _controller.allCourseList.value = [];
    _homeController.fetchTopCategories();
    await _controller.fetchAllCourse(null);
    _controller.allCourseText.value =
        "Có ${_controller.allCourseList.length} khóa học";
  }

  Widget _buildTopCategoryList(
      BuildContext context, HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.only(
              left: 20.sp,
              bottom: 0.sp,
              right: 20.sp,
              top: 10.sp,
            ),
            child: textHeading("Tất cả danh mục")),
        Container(
            margin: EdgeInsets.fromLTRB(
              20.sp,
              0,
              0,
              0,
            ),
            child: Obx(() {
              var loading = controller.isLoading.value ||
                  (controller.topCategoryList.isEmpty);
              if (loading) {
                return SizedBox(
                  height: 50.sp,
                  child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 15.sp, left: 0),
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 10.sp,
                        );
                      },
                      itemBuilder: (BuildContext context, int indexCat) {
                        return LoadingSkeleton(
                          height: 30.sp,
                          width: 140.sp,
                          child: Container(
                            padding: EdgeInsets.all(5.sp),
                            decoration: LayoutUtils.boxDecoration()
                                .copyWith(color: Colors.grey.shade200),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LoadingSkeleton(
                                  height: 10.sp,
                                  width: 140.sp,
                                ),
                                LoadingSkeleton(
                                  height: 10.sp,
                                  width: 140.sp,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return SizedBox(
                  height: 50.sp,
                  child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 5.sp, top: 5.sp),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.topCategoryList.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 5.sp,
                        );
                      },
                      itemBuilder: (BuildContext context, int indexCat) {
                        var colorIndex =
                            indexCat < 10 ? indexCat : indexCat % 10;
                        return GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: LayoutUtils.radialGradient([
                                  AppStyles.colorWheels[colorIndex],
                                  AppStyles.colorWheels[colorIndex]
                                      .withOpacity(0.6)
                                ]),
                                borderRadius: BorderRadius.circular(5.sp)),
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child: Text(
                              controller.topCategoryList[indexCat].name ??
                                  'N/A',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: () {
                            Get.to(() => CourseCategoryPage(
                                  categoryName: controller
                                          .topCategoryList[indexCat].name ??
                                      'N/A',
                                  categoryId:
                                      controller.topCategoryList[indexCat].id ??
                                          0,
                                ));
                          },
                        );
                      }),
                );
              }
            })),
      ],
    );
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
            title: "Khóa Học",
            showSearch: true,
            searching: onSearchTextChanged,
          ),
          body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildTopCategoryList(context, _homeController),
                Obx(() {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 20.sp, bottom: 0.sp, right: 20.sp, top: 10.sp),
                      child: textHeading(_controller.allCourseText.value));
                }),
                Container(
                    margin: EdgeInsets.only(bottom: 45.sp),
                    child: Obx(() {
                      if (_controller.isLoading.value) {
                        return Center(
                          child: activityIndicator(),
                        );
                      } else {
                        return _controller.allCourseList.isNotEmpty
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
                                  mainAxisExtent: 365.sp,
                                ),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: _controller.allCourseList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return CourseFullCardWidget(
                                    image: getFullResourceUrl(_controller
                                            .allCourseList[index].thumbnail ??
                                        ''),
                                    expiredDate: _controller
                                        .allCourseList[index].courseExpiredDate,
                                    title:
                                        _controller.allCourseList[index].name ??
                                            'N/A',
                                    price: _dashboardController
                                            .systemInformation
                                            .value!
                                            .releaseMode
                                        ? _controller.allCourseList[index].price
                                        : 1.0,
                                    isEnrolled: _controller
                                        .allCourseList[index].isEnrolled,
                                    rating:
                                        _controller.allCourseList[index].rating,
                                    onTap: () async {
                                      context.loaderOverlay.show();

                                      _homeController.courseID.value =
                                          _controller.allCourseList[index].id ??
                                              0;

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
