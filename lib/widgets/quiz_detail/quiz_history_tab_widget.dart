import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/pages/quiz_leaderboard_page.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/helpers/date_helper.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';

class QuizHistoryTabWidget extends StatelessWidget {
  final QuizController controller;
  final DashboardController dashboardController;

  const QuizHistoryTabWidget(
      {Key? key, required this.controller, required this.dashboardController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() {
          if (controller.isQuizTabLoading.value) {
            // is loading
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
              child: Center(
                child: activityIndicator(),
              ),
            );
          }

          if (controller.quizHistory.isEmpty) {
            return Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 20.sp),
              child: textHeading("Bạn chưa thực hiện bài kiểm tra"),
            );
          }

          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 0),
            children: [
              Container(
                padding: EdgeInsets.only(top: 0, left: 15.sp, right: 15.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Ngày Tháng",
                            textAlign: TextAlign.center,
                            style: AppTextThemes.label5().copyWith(
                                color: Get.theme.secondaryHeaderColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Thời Gian",
                            textAlign: TextAlign.center,
                            style: AppTextThemes.label5().copyWith(
                                color: Get.theme.secondaryHeaderColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Kết Quả",
                            textAlign: TextAlign.center,
                            style: AppTextThemes.label5().copyWith(
                                color: Get.theme.secondaryHeaderColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Kết Quả (%)",
                            textAlign: TextAlign.center,
                            style: AppTextThemes.label5().copyWith(
                                color: Get.theme.secondaryHeaderColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10.sp,
                    ),
                    ListView.separated(
                      key: UniqueKey(),
                      shrinkWrap: true,
                      itemCount: controller.quizHistory.length,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 5.sp),
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 10.sp,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        var quizHistory = controller.quizHistory[index];
                        var resultPercentage = (quizHistory.numOfCorrect /
                                quizHistory.totalQuestion) *
                            100;
                        var isPass = quizHistory.isPass;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                  DateHelper.formatDateOnly(
                                      quizHistory.startDate),
                                  textAlign: TextAlign.center,
                                  style: AppTextThemes.label4()
                                      .copyWith(color: AppStyles.primary)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                  DateHelper.formatHourOnly(
                                      quizHistory.finishedDate),
                                  textAlign: TextAlign.center,
                                  style: AppTextThemes.label4()
                                      .copyWith(color: AppStyles.primary)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                  '${quizHistory.numOfCorrect} / ${quizHistory.totalQuestion}',
                                  textAlign: TextAlign.center,
                                  style: AppTextThemes.label4().copyWith(
                                      color: AppStyles.primary,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${resultPercentage.toStringAsFixed(0)}%',
                                textAlign: TextAlign.center,
                                style: AppTextThemes.label4().copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isPass
                                        ? AppStyles.green
                                        : AppStyles.red),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 70.sp,
                    ),
                  ],
                ),
              )
            ],
          );
        }),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: LayoutUtils.floatingButton(context,
            text: 'Bảng Xếp Hạng', onPressed: () async {
          await controller.fetchQuizLeaderboard();
          Get.to(() => const QuizLeaderboardPage());
        }));
  }
}
