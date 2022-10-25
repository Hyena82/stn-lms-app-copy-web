import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';

class TagWidget extends StatelessWidget {
  final Color? color;
  final String? tag;
  final IconData? icon;

  const TagWidget({Key? key, this.color, this.tag, this.icon})
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
                  size: 16.sp,
                  color: AppStyles.white,
                )
              : Container(),
          const SizedBox(
            width: 7.0,
          ),
          Text(tag!)
        ]),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: color ?? AppStyles.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Get.theme.shadowColor,
              blurRadius: 1.0,
            ),
          ],
        ));
  }
}
