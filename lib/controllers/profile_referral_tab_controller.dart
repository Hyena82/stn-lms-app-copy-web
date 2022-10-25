// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:stna_lms_flutter/controllers/edit_profile_controller.dart';

class ProfileReferralTabController extends GetxController
    with GetTickerProviderStateMixin {
  late List<Tab> myTabs;

  late TabController controller;
  final EditProfileController editProfileController =
      Get.put(EditProfileController());

  @override
  void onInit() async {
    super.onInit();

    myTabs = <Tab>[
      const Tab(
        text: 'Cá Nhân',
      ),
      const Tab(text: 'Đã Giới Thiệu')
    ];

    ever(
        editProfileController.referrerListPaginationFilter,
        (_) => editProfileController.fetchReferrerList(
            search:
                editProfileController.referrerListPaginationFilter.value.search,
            page: editProfileController.referrerListPaginationFilter.value.page,
            pageSize: editProfileController
                .referrerListPaginationFilter.value.pageSize));

    controller =
        TabController(vsync: this, length: myTabs.length, initialIndex: 0);
    controller.addListener(() async {
      editProfileController.currentTabIndex = controller.index;

      if (controller.indexIsChanging && controller.index == 0) {
        await editProfileController.fetchProfileData();
      } else if (controller.indexIsChanging && controller.index == 1) {
        editProfileController.txtReferrerSearch.text = '';
        editProfileController.referrerListChangePaginationFilter(
            text: '', page: 1, pageSize: 25);
      }
    });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
