// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/pages/splash_screen.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';

import 'package:loader_overlay/loader_overlay.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final DashboardController controller = Get.put(DashboardController());
  final _formKey = GlobalKey<FormState>();
  bool obscurePass = true;
  final _hp = Get.height / 100;
  final _wp = Get.width / 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appVersion = controller.packageInfo?.version;
    var appName = controller.packageInfo?.appName;

    return Form(
        key: _formKey,
        child: ListView(physics: const BouncingScrollPhysics(), children: [
          SizedBox(
            width: Get.width,
            height: _hp * 35,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.sp))),
              margin: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
              child: Image.asset('images/layout/sign-in.png'),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
              child: Column(
                children: [
                  Text(
                    "Chào Bạn !",
                    style: AppTextThemes.heading1(),
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  Text(
                    "Đăng nhập với tài khoản",
                    style: AppTextThemes.label2(),
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Super English - Siêu Trí Nhớ Tiếng Anh",
                      style: AppTextThemes.label2()
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
          LayoutUtils.formInput(context, controller.email,
              'Địa chỉ Email Hoặc số điện thoại', Icons.account_circle,
              keyboardType: TextInputType.emailAddress, required: true),
          SizedBox(
            height: 10.sp,
          ),
          LayoutUtils.formInput(
              context, controller.password, 'Mật khẩu', Icons.lock_rounded,
              isPassword: true,
              obscureText: obscurePass, onSuffixIconPressed: () {
            setState(() {
              obscurePass = !obscurePass;
            });
          }, required: true),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.sp),
            padding: EdgeInsets.only(top: 10.sp),
            alignment: Alignment.center,
            child: GestureDetector(
              child: Text(
                "Quên mật khẩu ?",
                style: AppTextThemes.heading6(),
              ),
              onTap: () async {
                controller.showForgotPasswordScreen();
              },
            ),
          ),
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
                  "Đăng Nhập",
                  style:
                      AppTextThemes.heading5().copyWith(color: AppStyles.white),
                ),
              ),
              onTap: () async {
                context.loaderOverlay.show();
                controller.obscurePass.value = true;

                if (_formKey.currentState!.validate()) {
                  var signIn = await controller.signIn();

                  if (signIn != null) {
                    AlertUtils.success("Đăng nhập thành công !!!");

                    Get.off(() => const SplashScreen());
                  } else {
                    AlertUtils.error(
                        'Địa chỉ Email hoặc mật khẩu không chính xác');
                  }
                }

                context.loaderOverlay.hide();
              },
            ),
          ),
          Center(
              child: InkWell(
            onTap: () {
              controller.showRegisterScreen();
            },
            child: Container(
              margin: EdgeInsets.only(top: 15.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chưa có tài khoản?',
                    style: AppTextThemes.label4(),
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  Text(
                    'Đăng ký tại đây',
                    style: AppTextThemes.heading7()
                        .copyWith(color: AppStyles.blueDark),
                  )
                ],
              ),
            ),
          )),
          LayoutUtils.version(appName: appName, appVersion: appVersion)
        ]));
  }
}
