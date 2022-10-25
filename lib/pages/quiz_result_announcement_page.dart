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

class QuizResultAnnouncementPage extends StatefulWidget {
  const QuizResultAnnouncementPage({Key? key}) : super(key: key);

  @override
  _QuizResultAnnouncementPageState createState() =>
      _QuizResultAnnouncementPageState();
}

class _QuizResultAnnouncementPageState
    extends State<QuizResultAnnouncementPage> {
  final QuizController _quizController = Get.put(QuizController());
  final GiftController _giftController = Get.put(GiftController());
  final HomeController _homeController = Get.put(HomeController());

  final _wp = Get.width / 100;
  final _hp = Get.height / 100;

  bool didShowGiftDialog = false;

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
      if (!didShowGiftDialog) {
        _showGiftDialog(_quizController.quizStart.value.gift);
      }
    });
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
                didShowGiftDialog = true;
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
                      "images/quiz/done-quiz.png",
                      width: _wp * 30,
                      height: _wp * 30,
                    ),
                    SizedBox(height: 20.sp),
                    Text("Hoàn thành bài kiểm tra",
                        textAlign: TextAlign.center,
                        style: AppTextThemes.heading2().copyWith(color: color)),
                    SizedBox(height: 20.sp),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                                        "Bài Tiếp Theo",
                                        style: AppTextThemes.label3().copyWith(
                                            color: AppStyles.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  style:
                                      ElevatedButton.styleFrom(primary: color),
                                  onPressed: () async {
                                    didShowGiftDialog = true;
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
                              didShowGiftDialog = true;
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
