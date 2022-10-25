// Flutter imports:
// Package imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/my_course_controller.dart';
import 'package:stna_lms_flutter/controllers/my_resource_controller.dart';
import 'package:stna_lms_flutter/models/course_model.dart';
import 'package:stna_lms_flutter/pages/course_detail_page.dart';
import 'package:stna_lms_flutter/pages/course_progress_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/course/course_full_card_progress_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MyCourseTabWidget extends StatefulWidget {
  const MyCourseTabWidget({Key? key}) : super(key: key);

  @override
  _MyCourseTabWidgetState createState() => _MyCourseTabWidgetState();
}

class _MyCourseTabWidgetState extends State<MyCourseTabWidget> {
  late int itemCount;

  final MyCourseController _myCourseController = Get.put(MyCourseController());
  final HomeController _homeController = Get.put(HomeController());
  final MyResourceController _controller = Get.put(MyResourceController());

  Future<void> refresh() async {
    _myCourseController.myCourses.value = [];
    _myCourseController.fetchMyCourse();
  }

  Widget _buildCourseItem(CourseModel course, int index) {
    var course = _myCourseController.myCourses[index];
    return CourseFullCardProgressWidget(
      image: getFullResourceUrl(course.thumbnail ?? ''),
      title: course.name ?? 'N/A',
      price: course.price,
      isEnrolled: course.isEnrolled,
      rating: course.rating,
      totalCompleted: course.totalCompletedLesson,
      totalLecture: course.totalLesson,
      onTap: () async {
        context.loaderOverlay.show();

        _myCourseController.selectedLessonID.value = "";
        _myCourseController.myCourseDetailsTabController.controller.index = 0;
        _myCourseController.totalCourseProgress.value =
            course.totalCompletePercentage;

        _homeController.courseID.value = course.id ?? 0;
        var result = await _homeController.fetchCourseDetail();

        context.loaderOverlay.hide();

        if (result == null) {
          AlertUtils.warn('Khóa học đang được xây dựng. Vui lòng quay lại sau');
          return;
        }

        if (result.isEnrolled) {
          Get.to(() => const CourseProgressPage());
        } else {
          Get.to(() => const CourseDetailPage());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    itemCount = 2;

    return SafeArea(
        child: Scaffold(
      key: const Key('my_course'),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
                margin:
                    EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 35.sp),
                child: Obx(() {
                  if (_myCourseController.isLoading.value) {
                    return Center(
                      child: activityIndicator(),
                    );
                  }

                  if (_myCourseController.myCourses.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 20.sp),
                      child: textHeading("Vui lòng đăng ký khóa học"),
                    );
                  }

                  if (!_controller.courseSearchStarted.value) {
                    return GridView.builder(
                        padding: EdgeInsets.only(
                            left: 10.sp,
                            right: 15.sp,
                            top: 10.sp,
                            bottom: 10.sp),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: itemCount < 2 ? 2 : itemCount,
                          crossAxisSpacing: 20.sp,
                          mainAxisSpacing: 20.sp,
                          mainAxisExtent: 350.sp,
                        ),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _myCourseController.myCourses.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return _buildCourseItem(
                              _myCourseController.myCourses[index], index);
                        });
                  }

                  return _controller.myCoursesSearch.isEmpty
                      ? Text(
                          "Không tìm được khóa học",
                          style: AppTextThemes.heading7(),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.only(
                              left: 10, right: 15, top: 15, bottom: 50),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: itemCount < 2 ? 2 : itemCount,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 20.0,
                            mainAxisExtent: 350,
                          ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _controller.myCoursesSearch.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return _buildCourseItem(
                                _controller.myCoursesSearch[index], index);
                          });
                })),
          ],
        ),
      ),
    ));
  }
}
