// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/edit_profile_controller.dart';
import 'package:stna_lms_flutter/controllers/profile_referral_tab_controller.dart';
import 'package:stna_lms_flutter/helpers/text_helper.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:stna_lms_flutter/helpers/date_helper.dart';

// ignore: must_be_immutable
class EditReferralProgram extends GetView<EditProfileController> {
  final double iconSize = 16.sp;
  final double hintFontSize = 14.sp;
  final EditProfileController _editProfileController =
      Get.put(EditProfileController());
  final ProfileReferralTabController _tabx =
      Get.put(ProfileReferralTabController());
  final _hp = Get.height / 100;
  final _wp = Get.width / 100;

  EditReferralProgram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        child: SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
            title: "Chương Trình Referral",
            showBack: true,
            bottom: TabBar(
              controller: _tabx.controller,
              tabs: _tabx.myTabs,
            )),
        body: TabBarView(
            controller: _tabx.controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildEditReferralSection(context),
              _buildReferralList()
            ]),
      ),
    ));
  }

  _onSearchReferrerList(String text) async {
    controller.filterReferrerList(text);
  }

  Widget _buildEditReferralSection(BuildContext parentContext) {
    return Obx(() {
      if (_editProfileController.isLoading.value) {
        return SizedBox(
          height: MediaQuery.of(parentContext).size.height,
          width: MediaQuery.of(parentContext).size.width,
          child: const Center(
            child: CircularProgressIndicator(color: AppStyles.secondary),
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: Get.width,
              height: _hp * 30,
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                margin: const EdgeInsets.all(10),
                child: Image.asset('images/layout/referral.png'),
              ),
            ),
            SizedBox(
              height: _hp * 2,
            ),
            LayoutUtils.formInputLabel(parentContext, 'Mã giới thiệu'),
            LayoutUtils.formInputValueLabel(
              parentContext,
              _editProfileController.referralCode ?? 'N/A',
              () => {
                _editProfileController.copyReferralCode(
                    _editProfileController.referralCode.toString()),
              },
            ),
            LayoutUtils.formInputLabel(parentContext, 'Mã giới thiệu cá nhân'),
            LayoutUtils.formInput(parentContext,
                _editProfileController.txtReferralAlias, "Mã giới thiệu", null,
                suffixIcon: IconButton(
                    onPressed: () {
                      _editProfileController.copyReferralCode(
                          _editProfileController.txtReferralAlias.text);
                    },
                    icon: const Icon(Icons.content_copy_rounded))),
            LayoutUtils.formInputLabel(parentContext, 'Người giới thiệu'),
            LayoutUtils.formInputValueLabel(
                parentContext, _editProfileController.referrer ?? 'N/A', () {
              Get.bottomSheet(
                  Container(
                      padding: EdgeInsets.all(15.sp),
                      height: 190.sp,
                      child: Column(children: [
                        SizedBox(
                            width: MediaQuery.of(parentContext).size.width,
                            child: Text(
                              'Người giới thiệu',
                              style: AppTextThemes.heading7(),
                            )),
                        SizedBox(
                          height: 15.sp,
                        ),
                        TextField(
                          controller: _editProfileController.txtReferredBy,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 15.sp,
                                top: 3.sp,
                                bottom: 3.sp,
                                right: 15.sp),
                            filled: true,
                            fillColor: Get.theme.canvasColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.sp),
                              borderSide: BorderSide(
                                  color:
                                      const Color.fromRGBO(142, 153, 183, 0.4),
                                  width: 1.sp),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.sp),
                              borderSide: BorderSide(
                                  color:
                                      const Color.fromRGBO(142, 153, 183, 0.4),
                                  width: 1.sp),
                            ),
                            hintText: "Mã Giới Thiệu",
                            hintStyle: TextStyle(
                                color: const Color(0xff8E99B7),
                                fontSize: hintFontSize),
                          ),
                        ),
                        SizedBox(
                          height: 15.sp,
                        ),
                        SizedBox(
                          width: Get.width,
                          height: 30.sp,
                          child: ElevatedButton(
                              onPressed: () async {
                                // update referred by
                                await _editProfileController
                                    .updateUserReferBy();
                                await _editProfileController.fetchProfileData();
                              },
                              child: Text(
                                "Cập Nhật",
                                style: AppTextThemes.label3().copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )),
                        )
                      ])),
                  persistent: false,
                  isDismissible: true,
                  backgroundColor: Colors.white);
            }),
            SizedBox(
              height: _hp * 2,
            ),
            LayoutUtils.button(
                readonly: _editProfileController.isLoading.value,
                text: 'Cập Nhật',
                onPressed: () {
                  _editProfileController.updateProfile(parentContext);
                })
          ],
        ),
      );
    });
  }

  Widget _buildReferralList() {
    var referrerList = _editProfileController.referrerList;

    return Scaffold(
      body: Obx(() {
        List<Widget> widgets = [
          Container(
            height: 50.sp,
            margin: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 0),
            child: TextField(
              controller: _editProfileController.txtReferrerSearch,
              enabled: true,
              onChanged: _onSearchReferrerList,
              autofocus: false,
              autocorrect: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.only(
                    left: 20.sp, top: 15.sp, bottom: 15.sp, right: 20.sp),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(142, 153, 183, 0.4), width: 1.0),
                ),
                hintText: "Tìm người giới thiệu",
                hintStyle: AppTextThemes.label4(),
                prefixIcon: Icon(
                  Icons.search,
                  size: 24.sp,
                  color: AppStyles.primary,
                ),
              ),
            ),
          ),
        ];

        if (referrerList.isEmpty) {
          // empty
          widgets.add(Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 20.sp),
            child: textHeading("Không có kết quả"),
          ));
        } else {
          // not empty
          widgets.add(Expanded(
              child: LazyLoadScrollView(
                  onEndOfPage: _editProfileController.referrerListNextPage,
                  isLoading: _editProfileController.referrerListLoading.value,
                  child: ListView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.sp, vertical: 15.sp),
                      itemCount: referrerList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var referrer = referrerList[index];

                        return GestureDetector(
                            child: Container(
                          decoration: LayoutUtils.boxDecoration(),
                          margin: EdgeInsets.fromLTRB(0, 7.sp, 0, 7.sp),
                          child: Container(
                            margin: EdgeInsets.only(left: 5.sp, right: 5.sp),
                            child: Row(
                              children: [
                                Flexible(
                                    child: Container(
                                  width: 10.sp,
                                  height: 20.sp,
                                  margin: EdgeInsets.only(
                                      right: 20.sp, top: 5.sp, bottom: 5.sp),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.sp),
                                      color: AppStyles.blueLight),
                                )),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: _hp * 1,
                                    ),
                                    Text(
                                      referrer.fullName ?? 'N/A',
                                      style: AppTextThemes.heading5(),
                                    ),
                                    SizedBox(
                                      height: _hp * 0.5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.email_rounded,
                                          size: 16.sp,
                                          color: AppStyles.secondary,
                                        ),
                                        SizedBox(
                                          width: 10.sp,
                                        ),
                                        Text(
                                            TextHelper.lowerCase(
                                                referrer.email ?? ''),
                                            style: AppTextThemes.heading8()
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FontStyle.italic)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: _hp * 0.5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.phone_rounded,
                                          size: 16.sp,
                                          color: AppStyles.secondary,
                                        ),
                                        SizedBox(
                                          width: _wp * 2,
                                        ),
                                        Text(
                                            TextHelper.lowerCase(
                                                referrer.phoneNumber ?? ''),
                                            style: AppTextThemes.heading8()
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FontStyle.italic)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: _hp * 0.5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.date_range_rounded,
                                          size: 16.sp,
                                          color: AppStyles.secondary,
                                        ),
                                        SizedBox(
                                          width: _wp * 2,
                                        ),
                                        Text(
                                            DateHelper.formatDateOnly(
                                                referrer.createAt),
                                            style: AppTextThemes.heading8()
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FontStyle.italic)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: _hp * 1,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                      }))));
        }

        return Container(
          margin: EdgeInsets.only(top: 10.sp),
          child: Column(
            children: [...widgets],
          ),
        );
      }),
    );
  }
}
