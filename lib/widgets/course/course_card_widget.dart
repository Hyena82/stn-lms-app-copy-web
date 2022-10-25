import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// used in Home Page
class CourseCardWidget extends StatelessWidget {
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
  final DateTime? expiredDate;

  const CourseCardWidget(
      {Key? key,
      this.showRating = true,
      this.showPaidType = true,
      required this.image,
      required this.title,
      this.subTitle,
      required this.onTap,
      this.isVip = false,
      this.isEnrolled = false,
      this.expiredDate,
      this.rating = 0.0,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: LayoutUtils.boxDecoration(),
        width: 140.sp,
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
                        width: 130.sp,
                        image: NetworkImage(image),
                        fit: BoxFit.contain),
                  ),
                ),
                SizedBox(
                  height: 5.sp,
                ),
                SizedBox(
                    width: Get.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        courseTitle(title),
                        SizedBox(
                          height: 5.sp,
                        ),
                        RatingBar.builder(
                            itemSize: 8.sp,
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: AppStyles.yellow,
                                ),
                            onRatingUpdate: (rating) {},
                            ignoreGestures: true),
                        SizedBox(
                          height: 5.sp,
                        ),
                        courseExpiredDate(expiredDate, price)
                      ],
                    )),
              ],
            ),
            getPriceTag(isEnrolled, price),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
