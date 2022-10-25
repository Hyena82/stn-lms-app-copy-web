import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';

// used in Course Search, Course Category
class CourseFullCardWidget extends StatelessWidget {
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
  final double? width;

  const CourseFullCardWidget(
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
      this.width,
      required this.price,
      this.expiredDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: LayoutUtils.boxDecoration(),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                const SizedBox(height: 5),
                Container(
                    width: Get.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        courseTitle(title),
                        const SizedBox(height: 5),
                        subTitle == null
                            ? Container()
                            : courseAuthorName(subTitle),
                        const SizedBox(height: 5),
                        RatingBar.builder(
                            itemSize: 8,
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
                        const SizedBox(height: 5),
                        courseExpiredDate(expiredDate, price)
                      ],
                    )),
              ],
            ),
            getPriceTag(isEnrolled, price)
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
