import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/gift_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/models/gift_model.dart';
import 'package:stna_lms_flutter/pages/gift_detail_page.dart';
import 'package:stna_lms_flutter/pages/quiz_detail_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/course_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';

class QuizResultSummaryPage extends StatefulWidget {
  const QuizResultSummaryPage({Key? key}) : super(key: key);

  @override
  _QuizResultSummaryPageState createState() => _QuizResultSummaryPageState();
}

class _QuizResultSummaryPageState extends State<QuizResultSummaryPage> {
  final QuizController _quizController = Get.put(QuizController());
  final GiftController _giftController = Get.put(GiftController());
  final HomeController _homeController = Get.put(HomeController());

  final _wp = Get.width / 100;
  final _hp = Get.height / 100;

  bool _didShowGiftDialog = false;
  bool _shouldShowNextButton = false;

  @override
  void initState() {
    super.initState();

    var isPass = _quizController.quizResult.value.isPass;

    if (_quizController.quizInCourseIndex > -1) {
      var quiz = _homeController
          .getQuizFromIndex(_quizController.quizInCourseIndex + 1);
      var isLocked = quiz == null
          ? true
          : CourseUtils.isChapterContentLocked(
              quiz,
              _homeController.courseDetailIsEnrolled,
              _homeController.courseDetailHasFlow,
              _homeController.allContentList);
      if (isLocked) {
        if (_homeController.courseDetailHasFlow && isPass) {
          _shouldShowNextButton = true;
        } else {
          _shouldShowNextButton = false;
        }
      } else {
        _shouldShowNextButton = true;
      }
    }

    if (isPass) {
      Future.delayed(const Duration(seconds: 1), () {
        if (!_didShowGiftDialog) {
          _showGiftDialog(_quizController.quizStart.value.gift);
        }
      });
    }
  }

  void _showGiftDialog(GiftModel? gift) {
    if (gift == null) return;

    Get.defaultDialog(
        title: 'Bạn được nhận quà tặng',
        backgroundColor: Get.theme.cardColor,
        titleStyle: AppTextThemes.heading6(),
        barrierDismissible: true,
        radius: 5.sp,
        content: _buildGiftDialog(gift));
  }

  Widget _buildGiftDialog(GiftModel gift) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 20.sp),
      child: SingleChildScrollView(
          child: Column(
        children: [
          gift.image == null
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                      gradient: LayoutUtils.gradientGreyLight,
                      borderRadius: BorderRadius.circular(5.sp)),
                  margin:
                      EdgeInsets.only(right: 5.sp, left: 5.sp, bottom: 5.sp),
                  padding: EdgeInsets.all(5.sp),
                  child: LayoutUtils.fadeInImage(
                    fit: BoxFit.contain,
                    width: _wp * 90,
                    image: NetworkImage(getFullResourceUrl(gift.image ?? '')),
                  )),
          SizedBox(
            height: _hp * 2,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Text(
                gift.title ?? '',
                style: AppTextThemes.heading7(),
              )),
          SizedBox(
            height: _hp * 2,
          ),
          Container(
            margin: EdgeInsets.all(5.sp),
            width: Get.width,
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Nhận Quà Ngay",
                    style: AppTextThemes.heading6()
                        .copyWith(color: AppStyles.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(primary: AppStyles.blueDark),
              onPressed: () async {
                _didShowGiftDialog = true;
                Get.back();

                _giftController.giftDetailId.value = gift.id;
                await _giftController.getGiftDetail();
                Get.to(() => const GiftDetailPage());
              },
            ),
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rnd = Random();

    return SafeArea(
      child: Obx(() {
        if (_quizController.isQuizResultLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppStyles.secondary),
          );
        }

        var duration = _quizController.quizResult.value.startDate!
            .difference(_quizController.quizResult.value.finishedDate!)
            .inSeconds;
        var correctAns = _quizController.quizResult.value.numOfCorrect;
        var resultPercentage =
            (correctAns / _quizController.quizResult.value.totalQuestion * 100)
                .toStringAsFixed(0);
        var isPass = _quizController.quizResult.value.isPass;
        var color = isPass ? AppStyles.green : AppStyles.redLight;

        return Scaffold(
          backgroundColor: color,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.only(
                    left: 20.sp, right: 20.sp, top: 10.sp, bottom: 10.sp),
                margin: EdgeInsets.symmetric(horizontal: 10.sp),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  children: [
                    Text(isPass ? "Thành Công" : "Chưa Đạt",
                        textAlign: TextAlign.center,
                        style: AppTextThemes.heading2().copyWith(color: color)),
                    SizedBox(height: 20.sp),
                    Image.asset(
                      isPass
                          ? "images/quiz/quiz-success-${rnd.nextInt(5) + 1}.png"
                          : "images/quiz/quiz-fail-${rnd.nextInt(5) + 1}.png",
                      width: _wp * 30,
                      height: _wp * 30,
                    ),
                    SizedBox(height: 20.sp),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.all(5.sp),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.sp, horizontal: 20.sp),
                            decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                                borderRadius: BorderRadius.circular(5.sp),
                                boxShadow: [
                                  BoxShadow(
                                      color: Get.theme.shadowColor,
                                      blurRadius: 10.sp,
                                      offset: const Offset(2, 3))
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Thời gian",
                                  style: AppTextThemes.heading6(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      durationString(duration),
                                      style: AppTextThemes.label3().copyWith(
                                          color: AppStyles.blueLight,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10.sp,
                                    ),
                                    Icon(
                                      Icons.timer_rounded,
                                      size: 22.sp,
                                      color: AppStyles.blueDark,
                                    )
                                  ],
                                ),
                              ],
                            )),
                        Container(
                            margin: const EdgeInsets.all(5),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.sp, horizontal: 20.sp),
                            decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                                borderRadius: BorderRadius.circular(5.sp),
                                boxShadow: [
                                  BoxShadow(
                                      color: Get.theme.shadowColor,
                                      blurRadius: 10.sp,
                                      offset: const Offset(2, 3))
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Số câu đúng",
                                  style: AppTextThemes.heading6(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$correctAns',
                                      style: AppTextThemes.label3().copyWith(
                                          color: AppStyles.blueLight,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10.sp,
                                    ),
                                    Icon(
                                      Icons.checklist_rounded,
                                      size: 22.sp,
                                      color: AppStyles.blueDark,
                                    )
                                  ],
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(5.sp),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.sp, horizontal: 20.sp),
                            decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                                borderRadius: BorderRadius.circular(5.sp),
                                boxShadow: [
                                  BoxShadow(
                                      color: Get.theme.shadowColor,
                                      blurRadius: 10.sp,
                                      offset: const Offset(2, 3))
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Kết quả",
                                  style: AppTextThemes.heading6(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$resultPercentage%',
                                      style: AppTextThemes.label3().copyWith(
                                          color: AppStyles.blueLight,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10.sp,
                                    ),
                                    Icon(
                                      Icons.bar_chart_rounded,
                                      size: 22.sp,
                                      color: AppStyles.blueDark,
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        _shouldShowNextButton
                            ? Container(
                                margin: EdgeInsets.all(5.sp),
                                height: 30.sp,
                                width: Get.width,
                                child: ElevatedButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Bài Tiếp Theo",
                                        style: AppTextThemes.heading6()
                                            .copyWith(color: AppStyles.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  style:
                                      ElevatedButton.styleFrom(primary: color),
                                  onPressed: () async {
                                    _didShowGiftDialog = true;
                                    Get.back();
                                    Get.back();

                                    // get next quiz id to load
                                    _quizController.quizInCourseIndex =
                                        _quizController.quizInCourseIndex + 1;
                                    var nextQuizId =
                                        _homeController.getQuizIdFromIndex(
                                            _quizController.quizInCourseIndex);

                                    _quizController.quizID.value = nextQuizId;
                                    var result =
                                        await _quizController.fetchQuizDetail();

                                    if (result != null) {
                                      Get.to(() => const QuizDetailPage());
                                    } else {
                                      AlertUtils.error();
                                    }
                                  },
                                ),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.all(5.sp),
                          height: 30.sp,
                          width: Get.width,
                          child: OutlinedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Quay Lại",
                                  style: AppTextThemes.heading6().copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppStyles.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            onPressed: () async {
                              _didShowGiftDialog = true;
                              Get.back();
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.sp),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
