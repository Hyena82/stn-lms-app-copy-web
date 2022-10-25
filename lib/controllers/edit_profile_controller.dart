// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
// Project imports:
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/models/pagination_filter_model.dart';
import 'package:stna_lms_flutter/models/user_model.dart';
import 'package:stna_lms_flutter/services/api_service.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:loader_overlay/loader_overlay.dart';

class EditProfileController extends GetxController {
  final DashboardController dashboardController =
      Get.put(DashboardController());
  GetStorage userToken = GetStorage();
  var profileData = UserModel();
  var isLoading = false.obs;
  var isUpdatingReferBy = false.obs;
  Rx<String> selectedImagePath = "".obs;
  Rx<String?> userImage = "".obs;

  final ImagePicker _imagePicker = ImagePicker();

  TextEditingController txtFullName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPhoneNumber = TextEditingController();
  TextEditingController txtUserName = TextEditingController();
  TextEditingController txtReferralAlias = TextEditingController();
  TextEditingController txtReferredBy = TextEditingController();

  String? referralCode;
  String? referrer;

  // referrer list
  int currentTabIndex = 0; // 0 is edit referral, 1 is view list refered by
  Rx<bool> referrerListLastPage = false.obs;
  Rx<bool> referrerListLoading = false.obs;
  RxList<UserModel> referrerList = <UserModel>[].obs;
  final referrerListPaginationFilter = PaginationFilterModel().obs;
  int get referrerListPage => referrerListPaginationFilter.value.page;
  int get referrerListPageSize => referrerListPaginationFilter.value.pageSize;
  TextEditingController txtReferrerSearch = TextEditingController();

  @override
  void onReady() async {
    fetchProfileData();
    super.onReady();
  }

  void referrerListNextPage() {
    // referrerListChangePaginationFilter(
    //     page: referrerListPage + 1, pageSize: referrerListPageSize);
  }

  void referrerListChangePaginationFilter({
    int page = 1,
    int pageSize = 15,
    String text = '',
  }) {
    referrerListPaginationFilter.update((val) {
      if (val != null) {
        val.search = text;
        val.page = page;
        val.pageSize = pageSize;
      }
    });
  }

  Future filterReferrerList(String text) async {
    referrerListChangePaginationFilter(text: text);
  }

  Future<void> fetchReferrerList(
      {String? search, int page = 1, int pageSize = 15}) async {
    try {
      referrerListLoading.value = true;

      String? token = userToken.read(jwtTokenKey);
      var result = await APIService.fetchReferrerList(token,
          page: page, pageSize: pageSize, search: search);

      if (result.isEmpty) {
        referrerListLastPage.value = true;
      }

      if (page == 1) {
        // reset search result
        referrerList.assignAll(result);
      } else {
        referrerList.addAll(result);
      }
    } finally {
      referrerListLoading.value = false;
    }
  }

  Future<UserModel?> fetchProfileData() async {
    String? token = userToken.read(jwtTokenKey);
    try {
      isLoading(true);

      var profile = await APIService.fetchUserProfile(token);

      if (profile != null) {
        profileData = profile;
        txtFullName.text = profileData.fullName ?? '';
        txtEmail.text = profileData.email ?? '';
        txtPhoneNumber.text = profileData.phoneNumber ?? '';
        txtUserName.text = profileData.username ?? '';
        txtReferralAlias.text =
            profileData.referralAlias ?? profileData.referralCode ?? '';

        referralCode = profileData.referralCode;
        referrer = profileData.referBy;
        userImage.value = profileData.imageUrl ?? '';
      }

      return profile;
    } finally {
      isLoading(false);
    }
  }

  Future pickImage(BuildContext context, {required Function onPressed}) async {
    var width = Get.width / 100;
    var buttonWidth = width * 40;

    Get.bottomSheet(Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(5), topLeft: Radius.circular(5)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: buttonWidth,
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(width: 2.0, color: AppStyles.blueLight)),
              child: Icon(
                Icons.camera_alt_rounded,
                size: 24.sp,
                color: AppStyles.blueDark,
              ),
            ),
            onTap: () async {
              XFile? imageFile = await _imagePicker.pickImage(
                source: ImageSource.camera,
              );

              Get.back(); // close bottom sheet
              onPressed(imageFile);
            },
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: buttonWidth,
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(width: 2.0, color: AppStyles.blueLight)),
              child: Icon(
                Icons.image_rounded,
                size: 24.sp,
                color: AppStyles.blueDark,
              ),
            ),
            onTap: () async {
              XFile? imageFile = await _imagePicker.pickImage(
                source: ImageSource.gallery,
              );

              Get.back(); // close bottom sheet
              onPressed(imageFile);
            },
          )
        ])));
  }

  Future changeProfileAvatar(BuildContext context) async {
    await pickImage(context, onPressed: (XFile? imageFile) async {
      if (imageFile != null) {
        // String? token = userToken.read(jwtTokenKey);
        // bool res = await APIService.postUploadAvatar(token, imageFile.path);
        // if (res) {
        selectedImagePath.value = imageFile.path;
        //   await dashboardController.getProfileData();
        //   AlertUtils.success('Cập nhật ảnh đại diện thành công !');
        //   return;
        // }
      }

      // AlertUtils.error();
      return;
    });
  }

  Future updateProfile(BuildContext context) async {
    context.loaderOverlay.show();
    String? token = userToken.read(jwtTokenKey);
    bool res = true;
    var result = await APIService.postUpdateProfile(token,
        email: txtEmail.text,
        fullName: txtFullName.text,
        phoneNumber: txtPhoneNumber.text,
        referralAlias: txtReferralAlias.text);
    if (selectedImagePath.value != '') {
      res = await APIService.postUploadAvatar(token, selectedImagePath.value);
    }

    if (result != null && res) {
      await dashboardController.getProfileData();

      AlertUtils.success("Cập nhật thông tin cá nhân thành công !");
    } else {
      AlertUtils.error();
    }

    context.loaderOverlay.hide();
  }

  void copyReferralCode(String text) {
    if (referralCode == null) {
      AlertUtils.error();
    } else {
      Clipboard.setData(ClipboardData(text: text));
      AlertUtils.success('Sao chép mã giới thiệu $text');
    }
  }

  Future<void> updateUserReferBy() async {
    try {
      isUpdatingReferBy(true);

      String? token = userToken.read(jwtTokenKey);
      // check referral code is invalid or not
      var validReferrer =
          await APIService.fetchUserByReferralCode(token, txtReferredBy.text);

      if (validReferrer != null) {
        var success =
            await APIService.postUpdateUserReferral(token, validReferrer.id);
        Get.back(); // close bottom sheet modal
        if (success) {
          AlertUtils.success('Cập nhật người giới thiệu thành công');
          return;
        } else {
          AlertUtils.error();
          return;
        }
      } else {
        AlertUtils.warn(
            'Người giới thiệu không tồn tại hoặc mã giới thiệu không chính xác');
        return;
      }
    } finally {
      isUpdatingReferBy(false);
    }
  }
}
