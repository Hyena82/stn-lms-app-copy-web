// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/helpers/format_vnl_regex.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';

import 'package:loader_overlay/loader_overlay.dart';

bool isPhoneNumber(String number) {
  return RegExp(r"^[+]{0,1}[0-9]{7,15}$").hasMatch(number);
}

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  final DashboardController controller = Get.put(DashboardController());

  bool obscurePass = true;
  bool obscurePassConfirm = true;

  final _hp = Get.height / 100;
  final _wp = Get.width / 100;

  bool showResendAction = false;
  bool _canResend = true;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _countResendOtp() {
    _timer?.cancel();
    setState(() {
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick == 60) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {});
      }
    });
  }

  Widget _buildResendAction() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30, left: 20, right: 30),
          child: PinCodeTextField(
            appContext: context,
            length: 6,
            textStyle: const TextStyle(color: AppStyles.blueDark),
            obscureText: false,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              activeColor: const Color(0xFFD7D6DC),
              selectedColor: AppStyles.blueDark,
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 40,
              fieldWidth: 40,
            ),
            animationDuration: const Duration(milliseconds: 300),
            controller: controller.txtVerifyCode,
            onChanged: (String value) {},
          ),
        ),
        // LayoutUtils.formInput(
        //     context, controller.txtVerifyCode, 'Mã xác thực', Icons.verified,
        //     keyboardType: TextInputType.emailAddress, required: true),
        SizedBox(height: 10.sp),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: InkWell(
              onTap: () {
                if (_canResend) {
                  controller.sendOtp();
                  _countResendOtp();
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 5.sp, bottom: 5.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_canResend)
                      Text(
                        'Chưa nhận được mã xác thực.',
                        style: AppTextThemes.label3(),
                      ),
                    SizedBox(
                      width: 5.sp,
                    ),
                    _canResend
                        ? Text(
                            'Gửi lại',
                            style: AppTextThemes.heading6()
                                .copyWith(color: AppStyles.blueDark),
                          )
                        : Text(
                            'Gửi lại mã xác thực sau ${60 - _timer!.tick} giây',
                            style: AppTextThemes.heading6()
                                .copyWith(color: AppStyles.blueDark),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.sp),
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
                "Xác nhận",
                style:
                    AppTextThemes.heading5().copyWith(color: AppStyles.white),
              ),
            ),
            onTap: () async {
              context.loaderOverlay.show();

              if (_formKey.currentState!.validate()) {
                var response = await controller.confirmOtp();

                if (response == true) {
                  controller.showSignInScreen();
                  AlertUtils.success("Tạo tài khoản thành công");
                } else {
                  AlertUtils.error(
                      'Mã xác thực không đúng. Vui lòng kiểm tra lại');
                }
              }

              context.loaderOverlay.hide();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      children: [
        LayoutUtils.formInput(context, controller.txtRegisterPhone,
            'Số điện thoại', Icons.phone_rounded, required: true,
            validator: (value) {
          if (value.isEmpty) {
            return 'Vui lòng nhập số điện thoại';
          }

          if (!isPhoneNumber(value)) {
            return 'Số điện thoại không hợp lệ';
          }

          return null;
        }, keyboardType: TextInputType.phone),
        SizedBox(height: 10.sp),
        LayoutUtils.formInput(context, controller.txtRegisterPassword,
            'Mật khẩu', Icons.lock_rounded,
            isPassword: true,
            obscureText: obscurePass,
            onSuffixIconPressed: () {
              setState(() {
                obscurePass = !obscurePass;
              });
            },
            required: true,
            validator: (value) {
              if (controller.txtRegisterPassword.text.length < 8) {
                return 'Mật khẩu cần tối thiểu 8 ký tự';
              }
              if (regex.hasMatch(value)) {
                return 'Vui lòng không nhập kí tự có dấu';
              }
              return null;
            }),
        SizedBox(height: 10.sp),
        LayoutUtils.formInput(context, controller.txtRegisterConfirmPassword,
            'Mật khẩu xác nhận', Icons.lock_rounded,
            isPassword: true,
            obscureText: obscurePassConfirm,
            onSuffixIconPressed: () {
              setState(() {
                obscurePassConfirm = !obscurePassConfirm;
              });
            },
            required: true,
            validator: (value) {
              if (controller.txtRegisterPassword.text.length < 8) {
                return 'Mật khẩu cần tối thiểu 8 ký tự';
              } else if (value != controller.txtRegisterPassword.text) {
                return 'Mật khẩu xác nhận không giống mật khẩu đã nhập';
              }
              return null;
            }),
        SizedBox(height: 20.sp),
        LayoutUtils.formInput(
          context,
          controller.txtRegisterName,
          'Họ và tên',
          Icons.account_box_rounded,
        ),
        SizedBox(height: 10.sp),
        LayoutUtils.formInput(
          context,
          controller.txtRegisterEmail,
          'Địa chỉ Email',
          Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
          required: true,
        ),
        SizedBox(height: 20.sp),
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
                "Đăng Ký",
                style:
                    AppTextThemes.heading5().copyWith(color: AppStyles.white),
              ),
            ),
            onTap: () async {
              context.loaderOverlay.show();

              if (_formKey.currentState!.validate()) {
                var signUp = await controller.signUp();

                if (signUp == true) {
                  controller.sendOtp();
                  setState(() {
                    showResendAction = true;
                  });
                } else {
                  AlertUtils.error(
                      'Có lỗi xảy ra. Có thể số điện thoại hoặc địa chỉ email đã được sử dụng!');
                }
              }

              context.loaderOverlay.hide();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            !showResendAction
                ? SizedBox(
                    width: Get.width,
                    height: _hp * 25,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.sp))),
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.sp, vertical: 10.sp),
                        child: Image.asset('images/layout/sign-up.png')),
                  )
                : Container(margin: const EdgeInsets.only(top: 30)),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      showResendAction ? "Nhập mã OTP" : "Bắt đầu ngay !",
                      style: AppTextThemes.heading1(),
                    ),
                    SizedBox(
                      height: 5.sp,
                    ),
                    Text(
                      showResendAction
                          ? ("Vui lòng nhập mã OTP được gửi về số điện thoại của bạn để tiếp tục đăng ký tài khoản")
                          : "Tạo tài khoản ngay để truy cập tất cả nội dung",
                      style: AppTextThemes.label2(),
                      textAlign: TextAlign.center,
                    ),
                    showResendAction
                        ? Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Image.asset('images/layout/enter-otp.png'))
                        : Container(),
                    SizedBox(
                      height: 10.sp,
                    ),
                  ],
                ),
              ),
            ),
            showResendAction ? _buildResendAction() : _buildSignUpForm(),
            Center(
              child: InkWell(
                onTap: () {
                  controller.showSignInScreen();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15.sp, bottom: 30.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đã có tài khoản Super English.',
                        style: AppTextThemes.label4(),
                      ),
                      SizedBox(
                        width: 5.sp,
                      ),
                      Text(
                        'Đăng nhập',
                        style: AppTextThemes.heading7()
                            .copyWith(color: AppStyles.blueDark),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
