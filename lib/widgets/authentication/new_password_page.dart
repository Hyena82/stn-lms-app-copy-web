import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/helpers/format_vnl_regex.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';

class NewPasswordPage extends StatefulWidget {
  final String phoneNumber;
  final String? section;

  const NewPasswordPage({
    Key? key,
    required this.phoneNumber,
    required this.section,
  }) : super(key: key);

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final DashboardController controller = Get.put(DashboardController());
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool obscurePass = true;
  bool obscurePassConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Mật khẩu mới',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: AppStyles.blueDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Vui lòng nhập mật khẩu mới",
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
                    'images/layout/change-password.png',
                    height: 181,
                  ),
                  const SizedBox(height: 32),
                  LayoutUtils.formInput(context, _passwordController,
                      'Mật khẩu', Icons.lock_rounded,
                      isPassword: true,
                      validator: (value) {
                        if (regex.hasMatch(value)) {
                          return 'Vui lòng không nhập kí tự có dấu';
                        }
                        if (value.length < 8) {
                          return 'Mật khẩu cần tối thiểu 8 ký tự';
                        }
                        return null;
                      },
                      obscureText: obscurePass,
                      onSuffixIconPressed: () {
                        setState(() {
                          obscurePass = !obscurePass;
                        });
                      },
                      required: true),
                  SizedBox(height: 10.sp),
                  LayoutUtils.formInput(context, _confirmPasswordController,
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
                        if (value != _passwordController.text) {
                          return 'Mật khẩu xác nhận không giống mật khẩu đã nhập';
                        }

                        return null;
                      }),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 35.sp,
                    width: 200.sp,
                    child: ElevatedButton(
                      onPressed: () async {
                        context.loaderOverlay.show();

                        if (_formKey.currentState!.validate()) {
                          var response = await controller.forgotPassword(
                            phone: widget.phoneNumber,
                            newPassword: _passwordController.text,
                            token: widget.section!,
                          );

                          if (response != null && response["jwt"] != null) {
                            controller.showSignInScreen();
                            Get.back();
                            Get.back();
                            Get.back();
                            AlertUtils.success("Đổi mật khẩu thành công");
                          } else {
                            AlertUtils.error(
                              'Có lỗi xảy ra. Vui lòng thử lại sau!',
                            );
                          }
                        }

                        context.loaderOverlay.hide();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
