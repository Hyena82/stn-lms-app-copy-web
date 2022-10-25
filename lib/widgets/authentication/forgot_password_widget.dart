// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/authentication/otp_page.dart';
import 'package:stna_lms_flutter/widgets/authentication/sign_up_widget.dart';

class ForgotPasswordWidget extends GetView<DashboardController> {
  final _formKey = GlobalKey<FormState>();
  final _wp = Get.width / 100;
  final _hp = Get.height / 100;

  ForgotPasswordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(physics: const BouncingScrollPhysics(), children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(
                left: 20.sp, top: 30.sp, right: 20.sp, bottom: 5.sp),
            child: Column(
              children: [
                Text(
                  "Quên mật khẩu ?",
                  style: AppTextThemes.heading1(),
                ),
                SizedBox(
                  height: 5.sp,
                ),
                Text(
                  "Vui lòng cung cấp số điện thoại liên kết với tài khoản của bạn để nhận hướng dẫn cài đặt lại mật khẩu",
                  textAlign: TextAlign.center,
                  style: AppTextThemes.label2(),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.sp,
        ),
        SizedBox(
          width: Get.width,
          height: _hp * 40,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.sp))),
            margin: EdgeInsets.all(10.sp),
            child: Image.asset('images/layout/forgot-password.png'),
          ),
        ),
        SizedBox(
          height: 10.sp,
        ),
        LayoutUtils.formInput(context, controller.txtForgotPasswordEmail,
            'Số điện thoại', Icons.phone_android,
            required: true,
            keyboardType: TextInputType.phone, validator: (value) {
          if (!isPhoneNumber(value)) {
            return 'Số điện thoại không hợp lệ';
          }

          return null;
        }),
        SizedBox(
          height: 10.sp,
        ),
        Container(
          height: 35.sp,
          margin: EdgeInsets.symmetric(horizontal: _wp * 20),
          alignment: Alignment.center,
          child: GestureDetector(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppStyles.blueDark,
                borderRadius: BorderRadius.circular(5.sp),
              ),
              child: Text(
                "Gửi Yêu Cầu",
                style:
                    AppTextThemes.heading5().copyWith(color: AppStyles.white),
              ),
            ),
            onTap: () async {
              // controller.obscurePass.value = true;
              // Get.to(
              //   () => OtpPage(
              //     phoneNumber: controller.txtForgotPasswordEmail.text,
              //   ),
              // );
              // return;

              if (_formKey.currentState!.validate()) {
                var result = await controller
                    .sendOtpToServer(controller.txtForgotPasswordEmail.text);

                if (result != null) {
                  Get.to(
                    () => OtpPage(
                      phoneNumber: controller.txtForgotPasswordEmail.text,
                      section: result,
                    ),
                  );
                  // controller.showSignInScreen();
                } else {
                  AlertUtils.error(
                      "Số điện thoại không liên kết với tài khoản nào. Vui lòng kiểm tra lại");
                }
              }
            },
          ),
        ),
        Center(
            child: InkWell(
          onTap: () {
            controller.showSignInScreen();
          },
          child: Container(
            margin: EdgeInsets.only(top: 15.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Không mất mật khẩu ?',
                  style: AppTextThemes.label4(),
                ),
                SizedBox(
                  width: 5.sp,
                ),
                Text(
                  'Quay lại đăng nhập',
                  style: AppTextThemes.heading7()
                      .copyWith(color: AppStyles.blueDark),
                )
              ],
            ),
          ),
        ))
      ]),
    );
  }
}
