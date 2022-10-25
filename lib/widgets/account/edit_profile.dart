// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:get/get.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/edit_profile_controller.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

// ignore: must_be_immutable
class _EditProfileState extends State<EditProfile> {
  final double iconSize = 16.sp;
  final double hintFontSize = 14.sp;
  final _formKey = GlobalKey<FormState>();

  final _hp = Get.height / 100;

  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Scaffold(
          appBar: const AppBarWidget(
            title: "Thông Tin Cá Nhân",
            showBack: true,
          ),
          body: LoaderOverlay(
            child: Obx(() {
              if (controller.isLoading.value) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child:
                        CircularProgressIndicator(color: AppStyles.secondary),
                  ),
                );
              } else {
                String selectedImagePath = controller.selectedImagePath.value;
                String? avatar = controller.profileData.avatar;
                Object image = selectedImagePath == ''
                    ? (avatar != null
                        ? avatarImage(controller.profileData.avatar ?? '')
                        : defaultAccountImage())
                    : FileImage(File(controller.selectedImagePath.value));

                return SingleChildScrollView(
                  padding: EdgeInsets.only(top: 10.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child: Image(
                            fit: BoxFit.cover,
                            width: 120.sp,
                            height: 120.sp,
                            image: image as ImageProvider<Object>,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: 100.sp,
                          height: 28.sp,
                          decoration: BoxDecoration(
                              color: AppStyles.blueDark,
                              borderRadius: BorderRadius.circular(5.sp)),
                          child: Text(
                            "Chọn Ảnh",
                            style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () async {
                          await controller.changeProfileAvatar(context);
                        },
                      ),
                      SizedBox(
                        height: _hp * 3,
                      ),
                      LayoutUtils.formInputLabel(context, 'Họ và tên'),
                      LayoutUtils.formInput(
                        context,
                        controller.txtFullName,
                        "Họ và tên",
                        Icons.person_rounded,
                        required: true,
                      ),
                      LayoutUtils.formInputLabel(context, 'Địa chỉ Email'),
                      LayoutUtils.formInput(
                        context,
                        controller.txtEmail,
                        "Địa chỉ Email",
                        Icons.email_rounded,
                        required: true,
                      ),
                      LayoutUtils.formInputLabel(context, 'Số điện thoại'),
                      LayoutUtils.formInput(
                        context,
                        controller.txtPhoneNumber,
                        "Số điện thoại",
                        Icons.phone_rounded,
                        required: true,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (!RegExp(r"^[+]{0,1}[0-9]{7,15}$")
                              .hasMatch(value)) {
                            return "Số điện thoại không hợp lệ";
                          }
                          return null;
                        },
                      ),
                      LayoutUtils.formInputLabel(context, 'Mã người dùng'),
                      LayoutUtils.formInput(context, controller.txtUserName,
                          "Tên tài khoản", Icons.account_box_rounded,
                          readOnly: true),
                      SizedBox(
                        height: _hp * 2,
                      ),
                      LayoutUtils.button(
                          readonly: controller.isLoading.value,
                          text: 'Cập Nhật',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.updateProfile(context);
                            }
                          }),
                      SizedBox(
                        height: _hp * 2,
                      ),
                    ],
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
