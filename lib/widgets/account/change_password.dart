// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger_console/logger_console.dart';
// Project imports:
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/helpers/format_vnl_regex.dart';
import 'package:stna_lms_flutter/services/api_service.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final DashboardController controller = Get.put(DashboardController());

  double iconSize = 16.sp;
  double hintFontSize = 14.sp;

  bool inResponse = false;
  bool obscureMainPass = true;
  bool obscureNewPass = true;
  bool obscureConfirmPass = true;

  final _wp = Get.width / 100;
  final _hp = Get.height / 100;

  void update(token) async {
    setState(() {
      inResponse = true;
    });

    try {
      GetStorage storage = GetStorage();

      String? token = storage.read(jwtTokenKey);
      final response = await APIService.changePassword(
        oldPassword: controller.oldPassword.text,
        newPassword: controller.newPassword.text,
        token: token ?? '',
      );
      if (response['jwt'] == null) {
        AlertUtils.error(response['error']['message']);
        setState(() {
          inResponse = false;
        });
      } else if (response['jwt'] != null) {
        AlertUtils.success('M???t kh???u ???? ???????c thay ?????i');
        controller.signOut();
        Navigator.pop(context);
        controller.oldPassword.clear();
        controller.newPassword.clear();
        controller.confirmPassword.clear();
      }
    } catch (e) {
      AlertUtils.error(e.toString());
    }

    setState(() {
      inResponse = false;
    });
  }

  static GetStorage userToken = GetStorage();
  String tokenKey = "token";

  @override
  void initState() {
    super.initState();
    // profileData.getProfileData(userToken.read(tokenKey));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarWidget(
          title: "Thay ?????i M???t Kh???u",
          showBack: true,
        ),
        body: SingleChildScrollView(child: Obx(() {
          if (controller.isLoading.value) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(color: AppStyles.secondary),
              ),
            );
          } else {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: Get.width,
                    height: _hp * 30,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      margin: const EdgeInsets.all(10),
                      child: Image.asset('images/layout/change-password.png'),
                    ),
                  ),
                  SizedBox(
                    height: _hp * 2,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: _wp * 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'Vui l??ng nh???p ?????y ????? c??c th??ng tin d?????i ????? thay ?????i m???t kh???u',
                            textAlign: TextAlign.center,
                            style: AppTextThemes.label3(),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: _hp * 1),
                  Container(
                    padding: EdgeInsets.only(left: _wp * 10, right: _wp * 10),
                    child: TextFormField(
                      controller: controller.oldPassword,
                      obscureText: obscureMainPass,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 20, top: 15, bottom: 15, right: 20),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        hintText: 'M???t kh???u c??',
                        hintStyle: TextStyle(
                            color: const Color(0xff8E99B7),
                            fontSize: hintFontSize),
                        suffixIcon: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              obscureMainPass = !obscureMainPass;
                            });
                          },
                          child: Icon(
                            obscureMainPass
                                ? Icons.remove_red_eye_rounded
                                : Icons.remove_red_eye_outlined,
                            size: iconSize,
                            color: const Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui l??ng nh???p m???t kh???u';
                        }
                        // if (value.length < 8) {
                        //   return 'M???t kh???u ph???i d??i h??n 8 k?? t???';
                        // }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: _hp * 1),
                  Container(
                    padding: EdgeInsets.only(left: _wp * 10, right: _wp * 10),
                    child: TextFormField(
                      controller: controller.newPassword,
                      obscureText: obscureNewPass,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      // ],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 20, top: 15, bottom: 15, right: 20),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        hintText: 'M???t kh???u m???i',
                        hintStyle: TextStyle(
                            color: const Color(0xff8E99B7),
                            fontSize: hintFontSize),
                        suffixIcon: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              obscureNewPass = !obscureNewPass;
                            });
                          },
                          child: Icon(
                            obscureNewPass
                                ? Icons.remove_red_eye_rounded
                                : Icons.remove_red_eye_outlined,
                            size: iconSize,
                            color: const Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui l??ng nh???p m???t kh???u';
                        }
                        if (value.length < 8) {
                          return 'M???t kh???u c???n t???i thi???u 8 k?? t???';
                        }
                        if (regex.hasMatch(value)) {
                          return 'Vui l??ng kh??ng nh???p k?? t??? c?? d???u';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: _hp * 1),
                  Container(
                    padding: EdgeInsets.only(left: _wp * 10, right: _wp * 10),
                    child: TextFormField(
                      controller: controller.confirmPassword,
                      obscureText: obscureConfirmPass,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 20, top: 15, bottom: 15, right: 20),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        hintText: 'M???t kh???u x??c nh???n',
                        hintStyle: TextStyle(
                            color: const Color(0xff8E99B7),
                            fontSize: hintFontSize),
                        suffixIcon: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              obscureConfirmPass = !obscureConfirmPass;
                            });
                          },
                          child: Icon(
                            obscureConfirmPass
                                ? Icons.remove_red_eye_rounded
                                : Icons.remove_red_eye_outlined,
                            size: iconSize,
                            color: const Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui l??ng nh???p m???t kh???u';
                        }
                        if (value.length < 8) {
                          return 'M???t kh???u c???n t???i thi???u 8 k?? t???';
                        }
                        if (regex.hasMatch(value)) {
                          return 'Vui l??ng kh??ng nh???p k?? t??? c?? d???u';
                        }
                        if (value != controller.newPassword.text) {
                          return 'M???t kh???u x??c nh???n kh??ng tr??ng kh???p';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: _hp * 2,
                  ),
                  LayoutUtils.button(
                      // readonly: controller.isLoading.value,
                      text: 'L??u Thay ?????i',
                      onPressed: () {
                        // updateRequest(userToken.read(tokenKey));
                        // _formKey.currentState!.validate();
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            inResponse = true;
                          });
                          update(userToken.read(tokenKey));
                        }
                      }),
                  SizedBox(
                    height: _hp * 2,
                  ),
                ],
              ),
            );
          }
        })),
      ),
    );
  }
}
