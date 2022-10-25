// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:stna_lms_flutter/controllers/dictionary_controller.dart';

class DictionaryTabController extends GetxController
    with GetTickerProviderStateMixin {
  late List<Tab> myTabs;

  late TabController controller;
  final DictionaryController dictController = Get.put(DictionaryController());

  @override
  void onInit() async {
    super.onInit();

    myTabs = <Tab>[
      const Tab(
        text: 'Từ Vựng',
      ),
      const Tab(text: 'Đã Lưu')
    ];

    controller =
        TabController(vsync: this, length: myTabs.length, initialIndex: 0);
    controller.addListener(() async {
      dictController.currentTabIndex = controller.index;

      if (controller.indexIsChanging && controller.index == 0) {
        await dictController.getDictionaryWords(
            search: dictController.paginationFilterDict.value.search);
      } else if (controller.indexIsChanging && controller.index == 1) {
        await dictController.getFavoriteWords(
            search: dictController.paginationFilterDict.value.search);
      }
    });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
