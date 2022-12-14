import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/gift_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/models/gift_model.dart';
import 'package:stna_lms_flutter/pages/gift_detail_page.dart';
import 'package:stna_lms_flutter/pages/quiz_detail_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/course_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';

class QuizSurveyResultSummaryPage extends StatefulWidget {
  const QuizSurveyResultSummaryPage({Key? key}) : super(key: key);

  @override
  _QuizSurveyResultSummaryPageState createState() =>
      _QuizSurveyResultSummaryPageState();
}

class _QuizSurveyResultSummaryPageState
    extends State<QuizSurveyResultSummaryPage> {
  final QuizController _quizController = Get.put(QuizController());
  final GiftController _giftController = Get.put(GiftController());
  final HomeController _homeController = Get.put(HomeController());

  final _wp = Get.width / 100;
  final _hp = Get.height / 100;

  bool _didShowGiftDialog = false;

  @override
  void initState() {
    super.initState();

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
        if (_homeController.courseDetailHasFlow) {
        } else {}
      } else {}
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (!_didShowGiftDialog) {
        _showGiftDialog(_quizController.quizStart.value.gift);
      }
    });
  }

  void _showGiftDialog(GiftModel? gift) {
    if (gift == null) return;

    Get.defaultDialog(
        title: 'B???n ???????c nh???n qu?? t???ng',
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
                    "Nh???n Qu?? Ngay",
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
    return SafeArea(
      child: Obx(() {
        if (_quizController.isQuizResultLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppStyles.secondary),
          );
        }

        var color = AppStyles.green;

        return Scaffold(
          backgroundColor: color,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.sp)),
                padding: EdgeInsets.only(
                    left: 20.sp, right: 20.sp, top: 10.sp, bottom: 10.sp),
                margin: EdgeInsets.symmetric(horizontal: 10.sp),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  children: [
                    SizedBox(height: 20.sp),
                    Image.asset(
                      "images/quiz/done-survey.png",
                      width: _wp * 30,
                      height: _wp * 30,
                    ),
                    SizedBox(height: 20.sp),
                    Text("C???m ??n b???n ???? l??m b??i kh???o s??t c???a ch??ng t??i",
                        textAlign: TextAlign.center,
                        style: AppTextThemes.heading2().copyWith(color: color)),
                    SizedBox(height: 20.sp),
                    _quizController.quizInCourseIndex > -1
                        ? Container(
                            margin: EdgeInsets.all(5.sp),
                            height: 30.sp,
                            width: Get.width,
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "B??i Ti???p Theo",
                                    style: AppTextThemes.heading6()
                                        .copyWith(color: AppStyles.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(primary: color),
                              onPressed: () async {
                                // get next quiz id to load
                                _quizController.quizInCourseIndex =
                                    _quizController.quizInCourseIndex + 1;
                                var nextQuizId =
                                    _homeController.getQuizIdFromIndex(
                                        _quizController.quizInCourseIndex);
                                if (nextQuizId == -1) {
                                  AlertUtils.warn(
                                      '????y l?? b??i cu???i trong kh??a h???c');
                                } else {
                                  _didShowGiftDialog = true;
                                  Get.back();
                                  Get.back();
                                  _quizController.quizID.value = nextQuizId;
                                  var result =
                                      await _quizController.fetchQuizDetail();
                                  if (result != null && nextQuizId != -1) {
                                    Get.to(() => const QuizDetailPage());
                                  } else {
                                    AlertUtils.error();
                                  }
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
                              "Quay L???i",
                              style: AppTextThemes.heading6().copyWith(
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
