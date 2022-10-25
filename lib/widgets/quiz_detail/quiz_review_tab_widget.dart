import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/star_counter_widget.dart';

class QuizReviewTabWidget extends StatelessWidget {
  final QuizController controller;
  final DashboardController dashboardController;

  final _wp = Get.width / 100;
  final _hp = Get.height / 100;

  QuizReviewTabWidget(
      {Key? key, required this.controller, required this.dashboardController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() {
          if (controller.isQuizTabLoading.value) {
            // is loading
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
              child: Center(
                child: activityIndicator(),
              ),
            );
          }

          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 0.sp, horizontal: 10.sp),
            children: [
              controller.quizReviews.isEmpty
                  ? Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 20.sp),
                      child: textHeading("Chưa có đánh giá"),
                    )
                  : Container(
                      width: _wp * 100,
                      height: _hp * 6,
                      padding: EdgeInsets.fromLTRB(15.sp, 0, 30.sp, 0),
                      margin: const EdgeInsets.only(bottom: 0),
                      child: Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${controller.quizReviews.length} ${"lượt đánh giá"}',
                              style: AppTextThemes.heading6()
                                  .copyWith(color: AppStyles.blueDark),
                            ),
                          ],
                        );
                      }),
                    ),
              controller.quizReviews.isEmpty
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.quizReviews.length,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          vertical: 5.sp, horizontal: 5.sp),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(
                              20.sp, (5.8).sp, 20.sp, (5.8).sp),
                          decoration: LayoutUtils.boxDecoration(),
                          child: IntrinsicHeight(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                width: _wp * 20,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.sp),
                                  child: thumbnailImage(
                                      controller.quizReviews[index].userAvatar,
                                      fit: BoxFit.fitWidth),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: _wp * 80,
                                  margin: EdgeInsets.only(
                                      left: 16.sp, right: 16.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                      StarCounterWidget(
                                        value: controller
                                            .quizReviews[index].rating
                                            .toDouble(),
                                        color: AppStyles.yellow,
                                        size: 10.sp,
                                      ),
                                      SizedBox(
                                        height: 5.sp,
                                      ),
                                      userNameTitleText(controller
                                          .quizReviews[index].fullName),
                                      SizedBox(
                                        height: 5.sp,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 0),
                                        child: courseStructure(controller
                                            .quizReviews[index].comment),
                                      ),
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                        );
                      }),
              SizedBox(
                height: 30.sp,
              )
            ],
          );
        }),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: LayoutUtils.floatingButton(context,
            text: 'Đánh Giá', onPressed: () {
          var myRating = 3.0;
          controller.txtReview.clear();
          dashboardController.loggedIn.value
              ? Get.bottomSheet(
                  SingleChildScrollView(
                    child: SizedBox(
                      width: _wp * 80,
                      height: _hp * 35,
                      child: Container(
                          padding:
                              EdgeInsets.fromLTRB(20.sp, 15.sp, 20.sp, 20.sp),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    width: _wp * 15,
                                    height: 7.sp,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffE5E5E5),
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(5.sp)),
                                  ),
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                                SizedBox(
                                  height: 5.sp,
                                ),
                                Center(
                                  child: Text(
                                    "Bình luận",
                                    style: AppTextThemes.heading6(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 5.sp),
                                RatingBar.builder(
                                  itemSize: 20.sp,
                                  initialRating: myRating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 1.sp),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: AppStyles.yellow,
                                  ),
                                  onRatingUpdate: (rating) {
                                    myRating = rating;
                                  },
                                ),
                                SizedBox(
                                  height: 5.sp,
                                ),
                                Container(
                                  width: _wp * 100,
                                  height: _hp * 13,
                                  decoration: BoxDecoration(
                                    color: Get.theme.cardColor,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: _hp * 12.19,
                                          width: double.infinity,
                                          child: TextField(
                                            maxLines: 6,
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                height: 1,
                                                color: AppStyles.primary),
                                            controller: controller.txtReview,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 20.sp,
                                                  top: 15.sp,
                                                  bottom: 15.sp,
                                                  right: 20.sp),
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.sp),
                                                borderSide: BorderSide(
                                                    color: const Color.fromRGBO(
                                                        142, 153, 183, 0.4),
                                                    width: 1.sp),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.sp),
                                                  borderSide: BorderSide(
                                                      color:
                                                          const Color.fromRGBO(
                                                              142,
                                                              153,
                                                              183,
                                                              0.4),
                                                      width: 1.sp)),
                                              hintText: 'Đánh giá của bạn',
                                              hintStyle: AppTextThemes.label4()
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppStyles.secondary),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                LayoutUtils.button(
                                    text: 'Gửi Đánh Giá',
                                    onPressed: () async {
                                      await controller.submitQuizReview(
                                          controller.txtReview.value.text,
                                          myRating);
                                    }),
                              ])),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15.sp),
                  )),
                  backgroundColor: Get.theme.scaffoldBackgroundColor,
                )
              : Container();
          Container();
        }));
  }
}
