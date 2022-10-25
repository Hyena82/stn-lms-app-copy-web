// Dart imports:

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/gift_controller.dart';
// Project imports:
import 'package:stna_lms_flutter/helpers/date_helper.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/launcher_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:loader_overlay/loader_overlay.dart';

class GiftDetailPage extends StatefulWidget {
  const GiftDetailPage({Key? key}) : super(key: key);

  @override
  State<GiftDetailPage> createState() => _GiftDetailPageState();
}

class _GiftDetailPageState extends State<GiftDetailPage> {
  final _hp = Get.height / 100;
  final _wp = Get.width / 100;

  final GiftController _giftController = Get.put(GiftController());

  @override
  Widget build(BuildContext context) {
    var pinnedHeaderHeight = 40.0;

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
            if (_giftController.isGiftDetailLoading.value) {
              return Center(
                child: activityIndicator(),
              );
            }

            var gift = _giftController.giftDetail.value;
            var giftDate = gift.updatedAt;
            var giftUrl = gift.redirectUrl;

            var buttonText = '';
            var color = AppStyles.grey;

            // switch (giftLink) {
            //   case 'all_course':
            //     color = AppStyles.colorWheels[0];
            //     buttonText = 'Xem Tất Cả Khóa Học';
            //     break;
            //   case 'utilities':
            //     color = AppStyles.colorWheels[1];
            //     buttonText = 'Tiện Ích';
            //     break;
            //   case 'home':
            //     color = AppStyles.colorWheels[2];
            //     buttonText = 'Trang Chủ';
            //     break;
            //   case 'my_resources':
            //     color = AppStyles.colorWheels[3];
            //     buttonText = "Khóa Học Đã Mua";
            //     break;
            //   case 'account':
            //     color = AppStyles.colorWheels[4];
            //     buttonText = 'Tài Khoản';
            //     break;
            //   default:
            //     break;
            // }

            if (!isEmpty(giftUrl)) {
              buttonText = 'Xem Thêm';
            }

            double expandedHeight = _hp * 20;

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
                                  top: _hp * 5, left: _wp * 5, right: _wp * 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: AppStyles.primary,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
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
                                  const SizedBox(
                                    height: 5,
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
                                          courseNameText(gift.title),
                                          const SizedBox(height: 5),
                                        ]),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: _wp * 5),
                                    child: giftDate == null
                                        ? const SizedBox(height: 20)
                                        : Text(
                                            DateHelper.formatDateTime(giftDate),
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
                      : LayoutUtils.floatingButton(context,
                          text: buttonText, color: color, onPressed: () async {
                          LauncherUtils.launchBrowserUrl(giftUrl);

                          // switch (giftLink) {
                          //   case 'all_course':
                          //     _dashboardController.changeTabIndex(1,
                          //         courseSearchController: _allCourseController);
                          //     break;
                          //   case 'utilities':
                          //     _dashboardController.changeTabIndex(2);
                          //     break;
                          //   case 'home':
                          //     _dashboardController.changeTabIndex(
                          //       0,
                          //       homeController: _homeController,
                          //     );
                          //     break;
                          //   case 'my_resources':
                          //     _dashboardController.changeTabIndex(3,
                          //         myCourseController: _myCourseController);
                          //     break;
                          //   case 'account':
                          //     _dashboardController.changeTabIndex(4);
                          //     break;
                          //   case 'course':
                          //     int courseId =
                          //         dynamicToInt(gift.redirectPageParameter);

                          //     _homeController.courseID.value = courseId;

                          //     var course =
                          //         await _homeController.fetchCourseDetail();

                          //     if (course == null) {
                          //       AlertUtils.warn(
                          //           'Khóa học đang được xây dựng. Vui lòng quay lại sau');
                          //     } else if (course.isEnrolled) {
                          //       Get.to(() => CourseProgressPage());
                          //     } else {
                          //       Get.to(() => CourseDetailPage());
                          //     }
                          //     break;
                          // }
                        }),
                  body: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: _wp * 5, vertical: 0),
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      _giftController.giftDetail.value.image == null
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
                                            _giftController
                                                    .giftDetail.value.image ??
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
                        _giftController.giftDetail.value.content,
                      )
                    ],
                  )),
            );
          })),
    );
  }
}
