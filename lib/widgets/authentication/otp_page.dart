import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/widgets/authentication/new_password_page.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final String? section;

  const OtpPage({Key? key, required this.phoneNumber, this.section})
      : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final DashboardController controller = Get.put(DashboardController());

  Timer? _timer;
  bool _canResend = true;
  String? section;
  String otp = '';

  @override
  void initState() {
    section = widget.section;
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Nhập mã OTP',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: AppStyles.blueDark,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Vui lòng nhập mã OTP được gửi về số điện thoại của bạn để tiếp tục cài đặt lại mật khẩu",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppStyles.otpGuide,
                    height: 22 / 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Image.asset(
                  'images/layout/enter-otp.png',
                  height: 181,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  child: OtpTextField(
                    numberOfFields: 6,
                    fieldWidth: 40,
                    borderRadius: BorderRadius.circular(5),
                    borderWidth: 1,
                    borderColor: const Color(0xFFD7D6DC),
                    showFieldAsBox: true,
                    textStyle: const TextStyle(
                      color: AppStyles.black,
                    ),
                    onCodeChanged: (String code) {
                      setState(() {
                        otp = '';
                      });
                      //handle validation or checks here
                    },
                    onSubmit: (String verificationCode) {
                      setState(() {
                        otp = verificationCode;
                      });
                    }, // end onSubmit
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 35.sp,
                  width: 200.sp,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (otp.length == 6) {
                        final response = await controller.confirmOtpToServer(
                            otp: otp, session: section ?? '');
                        if (response) {
                          Get.to(() => NewPasswordPage(
                                phoneNumber: widget.phoneNumber,
                                section: section,
                              ));
                        } else {
                          Get.snackbar('Thông báo', 'Mã OTP không đúng');
                          setState(() {
                            otp = '';
                          });
                        }
                      } else {
                        setState(() {
                          otp = '';
                        });
                        Get.snackbar('Thông báo', 'Mã OTP không đúng');
                      }
                    },
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppStyles.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: AppStyles.blueDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                      style: const TextStyle(
                        color: AppStyles.otpGuide,
                      ),
                      text: "Chưa nhận được mã? ",
                      children: [
                        if (_canResend)
                          TextSpan(
                            text: "Gửi lại",
                            style: const TextStyle(
                              color: AppStyles.blueDark,
                              fontWeight: FontWeight.w700,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                _countResendOtp();
                                final response = await controller
                                    .sendOtpToServer(widget.phoneNumber);

                                if (response != null) {
                                  setState(() {
                                    section = response;
                                  });
                                }
                              },
                          ),
                        if (!_canResend)
                          TextSpan(
                            text: "Gửi lại sau ${60 - _timer!.tick} giây",
                            style: const TextStyle(
                              color: AppStyles.blueDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ]),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
