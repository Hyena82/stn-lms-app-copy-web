import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';

class TagTransparentWidget extends StatelessWidget {
  final Color? color;
  final String? tag;
  final IconData? icon;

  const TagTransparentWidget({Key? key, this.color, this.tag, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tag == null) {
      return Container();
    }

    return Container(
      child: Row(children: [
        icon != null
            ? Icon(
                icon,
                size: 14.sp,
                color: AppStyles.primary,
              )
            : Container(),
        SizedBox(
          width: 5.sp,
        ),
        Text(
          tag!,
          style: AppTextThemes.heading6().copyWith(
            fontWeight: FontWeight.bold,
            color: AppStyles.primary,
          ),
        )
      ]),
      padding: EdgeInsets.all(5.sp),
    );
  }
}
