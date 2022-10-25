import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';

class CourseListItemWidget extends StatelessWidget {
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
  final DateTime expiredDate;

  final HomeController controller = Get.put(HomeController());

  CourseListItemWidget(
      {Key? key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.onTap,
      required this.isVip,
      required this.isEnrolled,
      required this.rating,
      required this.showRating,
      required this.showPaidType,
      required this.price,
      required this.expiredDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var widthPercent = width / 100;

    return GestureDetector(
      child: Container(
        decoration: LayoutUtils.boxDecoration(),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: IntrinsicHeight(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              width: 250,
              height: 250,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: thumbnailImage(image),
              ),
            ),
            Flexible(
              child: Container(
                width: widthPercent * 70,
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    courseTitle(title),
                    const SizedBox(
                      height: 5,
                    ),
                    subTitle == null ? Container() : courseAuthorName(subTitle),
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
                    const SizedBox(height: 15),
                    courseExpiredDate(expiredDate, price),
                    const SizedBox(height: 5),
                    getPriceText(price),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            getPriceTag(isEnrolled, price)
          ],
        )),
      ),
      onTap: onTap,
    );
  }
}
