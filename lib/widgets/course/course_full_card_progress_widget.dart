import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CourseFullCardProgressWidget extends StatelessWidget {
  final String image;
  final String title;
  final String? subTitle;
  final VoidCallback onTap;
  final bool isVip;
  final bool isEnrolled;
  final double rating;
  final bool showRating;
  final bool showPaidType;
  final double price;
  final int totalLecture;
  final int totalCompleted;

  const CourseFullCardProgressWidget(
      {Key? key,
      this.showRating = true,
      this.showPaidType = true,
      required this.image,
      required this.title,
      this.subTitle,
      required this.onTap,
      this.isVip = false,
      this.isEnrolled = false,
      this.rating = 0.0,
      required this.price,
      this.totalCompleted = 0,
      this.totalLecture = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: LayoutUtils.boxDecoration(),
        margin: EdgeInsets.only(bottom: 10.sp),
        padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                    child: LayoutUtils.fadeInImage(
                        width: Get.width,
                        image: NetworkImage(image),
                        fit: BoxFit.contain),
                  ),
                ),
                SizedBox(
                  height: 5.sp,
                ),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        courseTitle(title),
                      ],
                    )),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearPercentIndicator(
                  lineHeight: 8.sp,
                  percent: safeDouble(totalCompleted / totalLecture),
                  backgroundColor: Colors.grey.shade300,
                  progressColor: AppStyles.blueDark,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tiến độ",
                        style: AppTextThemes.heading7().copyWith(
                          color: AppStyles.primary,
                        ),
                      ),
                      SizedBox(
                        width: 5.sp,
                      ),
                      Text(
                        '$totalCompleted',
                        style: AppTextThemes.heading7().copyWith(
                            color: AppStyles.blueDark,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "/",
                        style: AppTextThemes.heading7()
                            .copyWith(color: AppStyles.primary),
                      ),
                      Text(
                        '$totalLecture',
                        style: AppTextThemes.heading7().copyWith(
                            color: AppStyles.blueDark,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
