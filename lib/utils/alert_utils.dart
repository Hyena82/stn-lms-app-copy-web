// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';

class AlertUtils {
  static SnackbarController snackbar(String message, Color backgroundColor) {
    return Get.snackbar(
      message.toString(),
      '',
      isDismissible: false,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      borderRadius: 5,
      margin: EdgeInsets.only(bottom: 10.h, left: 5.w, right: 5.w, top: 10.h),
      duration: const Duration(seconds: 3),
    );
  }

  static SnackbarController success(message) {
    return snackbar(message.toString(), AppStyles.green);
  }

  static SnackbarController error(
      [message = 'Có lỗi xảy ra. Vui lòng thử lại !']) {
    return snackbar(message.toString(), AppStyles.red);
  }

  static SnackbarController warn(message) {
    return snackbar(message.toString(), AppStyles.yellow);
  }

  static SnackbarController snackBarNotification(title, body) {
    return Get.snackbar(
      "${title.toString().capitalizeFirst}",
      "${body.toString().capitalizeFirst}",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 5,
      duration: const Duration(seconds: 10),
    );
  }
}
