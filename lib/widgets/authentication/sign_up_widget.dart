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
        //     context, controller.txtVerifyCode, 'M?? x??c th???c', Icons.verified,
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
                        'Ch??a nh???n ???????c m?? x??c th???c.',
                        style: AppTextThemes.label3(),
                      ),
                    SizedBox(
                      width: 5.sp,
                    ),
                    _canResend
                        ? Text(
                            'G???i l???i',
                            style: AppTextThemes.heading6()
                                .copyWith(color: AppStyles.blueDark),
                          )
                        : Text(
                            'G???i l???i m?? x??c th???c sau ${60 - _timer!.tick} gi??y',
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
                "X??c nh???n",
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
                  AlertUtils.success("T???o t??i kho???n th??nh c??ng");
                } else {
                  AlertUtils.error(
                      'M?? x??c th???c kh??ng ????ng. Vui l??ng ki???m tra l???i');
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
            'S??? ??i???n tho???i', Icons.phone_rounded, required: true,
            validator: (value) {
          if (value.isEmpty) {
            return 'Vui l??ng nh???p s??? ??i???n tho???i';
          }

          if (!isPhoneNumber(value)) {
            return 'S??? ??i???n tho???i kh??ng h???p l???';
          }

          return null;
        }, keyboardType: TextInputType.phone),
        SizedBox(height: 10.sp),
        LayoutUtils.formInput(context, controller.txtRegisterPassword,
            'M???t kh???u', Icons.lock_rounded,
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
                return 'M???t kh???u c???n t???i thi???u 8 k?? t???';
              }
              if (regex.hasMatch(value)) {
                return 'Vui l??ng kh??ng nh???p k?? t??? c?? d???u';
              }
              return null;
            }),
        SizedBox(height: 10.sp),
        LayoutUtils.formInput(context, controller.txtRegisterConfirmPassword,
            'M???t kh???u x??c nh???n', Icons.lock_rounded,
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
                return 'M???t kh???u c???n t???i thi???u 8 k?? t???';
              } else if (value != controller.txtRegisterPassword.text) {
                return 'M???t kh???u x??c nh???n kh??ng gi???ng m???t kh???u ???? nh???p';
              }
              return null;
            }),
        SizedBox(height: 20.sp),
        LayoutUtils.formInput(
          context,
          controller.txtRegisterName,
          'H??? v?? t??n',
          Icons.account_box_rounded,
        ),
        SizedBox(height: 10.sp),
        LayoutUtils.formInput(
          context,
          controller.txtRegisterEmail,
          '?????a ch??? Email',
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
                "????ng K??",
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
                      'C?? l???i x???y ra. C?? th??? s??? ??i???n tho???i ho???c ?????a ch??? email ???? ???????c s??? d???ng!');
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
                      showResendAction ? "Nh???p m?? OTP" : "B???t ?????u ngay !",
                      style: AppTextThemes.heading1(),
                    ),
                    SizedBox(
                      height: 5.sp,
                    ),
                    Text(
                      showResendAction
                          ? ("Vui l??ng nh???p m?? OTP ???????c g???i v??? s??? ??i???n tho???i c???a b???n ????? ti???p t???c ????ng k?? t??i kho???n")
                          : "T???o t??i kho???n ngay ????? truy c???p t???t c??? n???i dung",
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
                        '???? c?? t??i kho???n Super English.',
                        style: AppTextThemes.label4(),
                      ),
                      SizedBox(
                        width: 5.sp,
                      ),
                      Text(
                        '????ng nh???p',
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
