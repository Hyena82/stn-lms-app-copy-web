import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/quiz_controller.dart';
import 'package:stna_lms_flutter/models/quiz_leaderboard_model.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:stna_lms_flutter/widgets/tag_transparent_widget.dart';

class QuizLeaderboardPage extends StatefulWidget {
  const QuizLeaderboardPage({Key? key}) : super(key: key);

  @override
  _QuizLeaderboardPageState createState() => _QuizLeaderboardPageState();
}

class _QuizLeaderboardPageState extends State<QuizLeaderboardPage> {
  final QuizController _quizController = Get.put(QuizController());

  final _wp = Get.width / 100;

  Widget _buildRankingTableItem(int index, QuizLeaderboardRankerModel ranker) {
    var backgroundColor = Get.theme.cardColor;
    var rankColor = AppStyles.black;

    switch (index) {
      case 1:
        rankColor = AppStyles.green;
        break;
      case 2:
        rankColor = AppStyles.blue;
        break;
      case 3:
        rankColor = AppStyles.yellow;
        break;
    }

    return Container(
        margin: EdgeInsets.all(5.sp),
        padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5.sp),
            boxShadow: [
              BoxShadow(
                  color: Get.theme.shadowColor,
                  blurRadius: 10.sp,
                  offset: const Offset(2, 3))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(5.sp, 0.sp, 10.sp, 0.sp),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.sp),
                  child: Container(
                    width: _wp * 15,
                    alignment: Alignment.center,
                    child: accountImage(ranker.avatar),
                  ),
                )),
            SizedBox(
                width: _wp * 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ranker.fullName ?? '',
                      style: AppTextThemes.heading6().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        TagTransparentWidget(
                          icon: Icons.format_list_numbered_rounded,
                          color: AppStyles.blueDark,
                          tag: '${ranker.totalQuestion}',
                        ),
                        SizedBox(
                          width: 5.sp,
                        ),
                        TagTransparentWidget(
                          icon: Icons.timer_rounded,
                          color: AppStyles.blueDark,
                          tag: durationString(ranker.duration),
                        )
                      ],
                    )
                  ],
                )),
            SizedBox(
                width: _wp * 15,
                child: Container(
                  decoration: BoxDecoration(
                      color: rankColor.withOpacity(0.2),
                      shape: BoxShape.circle),
                  padding: EdgeInsets.all(5.sp),
                  child: Text(
                    '#${ranker.rankNo}',
                    textAlign: TextAlign.center,
                    style: AppTextThemes.label4().copyWith(
                        fontWeight: FontWeight.bold, color: rankColor),
                  ),
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var userData = _quizController.quizLeaderboard.value?.currentUser;
    var hasUserData = userData?.userId != null;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        appBar: const AppBarWidget(
          title: "Bảng Xếp Hạng",
          showBack: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Obx(() {
                if (_quizController.isQuizLeaderboardLoading.value) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppStyles.secondary),
                  );
                }

                return ListView.builder(
                  itemCount: _quizController.quizLeaderboard.value?.ranks ==
                          null
                      ? 0
                      : _quizController.quizLeaderboard.value?.ranks?.length,
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildRankingTableItem(index + 1,
                        _quizController.quizLeaderboard.value!.ranks![index]);
                  },
                );
              }),
            ),
            !hasUserData
                ? Container()
                : Container(
                    margin: EdgeInsets.fromLTRB(10.sp, 5.sp, 10.sp, 5.sp),
                    padding: EdgeInsets.fromLTRB(20.sp, 20.sp, 20.sp, 20.sp),
                    decoration: BoxDecoration(
                        color: AppStyles.blueDark,
                        borderRadius: BorderRadius.circular(5.sp),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10.sp,
                              offset: const Offset(3, 3),
                              color: Get.theme.shadowColor)
                        ]),
                    alignment: Alignment.bottomCenter,
                    child: Row(children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5.sp,
                              ),
                              Text("XẾP HẠNG",
                                  style: AppTextThemes.label3()
                                      .copyWith(color: Colors.white)),
                              Text(
                                hasUserData ? '${userData?.rankNo}' : 'N/A',
                                style: AppTextThemes.heading4().copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle),
                                padding: EdgeInsets.all(5.sp),
                                width: _wp * 15,
                                child: ClipOval(
                                    child: accountImage(userData?.avatar)),
                              ),
                              Text(
                                  hasUserData ? '${userData?.fullName}' : 'N/A',
                                  textAlign: TextAlign.center,
                                  style: AppTextThemes.heading4().copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5.sp,
                              ),
                              Text("KẾT QUẢ",
                                  style: AppTextThemes.label3()
                                      .copyWith(color: Colors.white)),
                              Text(
                                  hasUserData
                                      ? '${userData?.score.toStringAsFixed(0)}%'
                                      : 'N/A',
                                  style: AppTextThemes.heading4().copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                            ],
                          ))
                    ]),
                  ),
          ],
        ),
      ),
    );
  }
}
