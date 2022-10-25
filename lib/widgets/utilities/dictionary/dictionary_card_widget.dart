import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';

class DictionaryCardWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  final DateTime? updatedDate;

  const DictionaryCardWidget(
      {Key? key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.onTap,
      this.updatedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: LayoutUtils.boxDecoration(),
        margin: EdgeInsets.only(bottom: 5.sp),
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
                        width: 150.sp,
                        image: NetworkImage(image),
                        fit: BoxFit.contain),
                  ),
                ),
                SizedBox(
                  height: 5.sp,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    courseTitle(title),
                    SizedBox(
                      height: 5.sp,
                    ),
                    courseDescription(subTitle),
                  ],
                ),
              ],
            ),
            courseUpdatedDate(updatedDate),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
