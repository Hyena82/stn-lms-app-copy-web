import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/helpers/date_helper.dart';

class MyQuizListItemWidget extends StatelessWidget {
  final String? image;
  final String? title;
  final String? subTitle;
  final int numOfCorrect;
  final int totalQuestion;
  final DateTime? finishedDate;
  final bool isPass;
  final VoidCallback onTap;

  final _wp = Get.width / 100;

  final HomeController controller = Get.put(HomeController());

  MyQuizListItemWidget(
      {Key? key,
      this.image,
      this.title,
      this.subTitle,
      required this.onTap,
      this.isPass = false,
      this.numOfCorrect = 0,
      this.totalQuestion = 0,
      this.finishedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: LayoutUtils.boxDecoration(),
        margin: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 10.sp),
        child: IntrinsicHeight(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Container(
                width: _wp * 50,
                padding: EdgeInsets.only(left: 10.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    courseTitle(title ?? ''),
                    SizedBox(
                      height: 5.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Kết quả',
                          style: AppTextThemes.label5()
                              .copyWith(color: AppStyles.primary),
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        Text(
                          '$numOfCorrect / $totalQuestion',
                          style: AppTextThemes.label5().copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppStyles.primary),
                        )
                      ],
                    ),
                    SizedBox(height: 5.sp),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ngày thực hiện',
                          style: AppTextThemes.label5()
                              .copyWith(color: AppStyles.primary),
                        ),
                        SizedBox(
                          height: 5.sp,
                        ),
                        Text(
                            finishedDate != null
                                ? DateHelper.formatDateTime(finishedDate)
                                : 'N/A',
                            style: AppTextThemes.label5().copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppStyles.primary))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
                child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 5.sp),
                  padding: EdgeInsets.all(5.sp),
                  width: _wp * 40,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5.sp)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.sp),
                    child: thumbnailImage(
                      image,
                      fit: BoxFit.contain,
                      placeholder: 'images/placeholders/image-loading-16x9.jpg',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin:
                      EdgeInsets.only(left: 5.sp, right: 5.sp, bottom: 5.sp),
                  padding: EdgeInsets.all(5.sp),
                  width: _wp * 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.sp),
                    color: isPass ? AppStyles.green : AppStyles.red,
                  ),
                  child: Text((isPass ? 'Đạt' : 'Không Đạt').toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppTextThemes.heading8().copyWith(
                          color: AppStyles.white, fontWeight: FontWeight.bold)),
                )
              ],
            )),
          ],
        )),
      ),
      onTap: onTap,
    );
  }
}
