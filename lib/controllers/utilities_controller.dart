import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/models/dictionary_model.dart';
import 'package:stna_lms_flutter/services/api_service.dart';

class UtilitiesController extends GetxController {
  var dictionaryList = <DictionaryModel>[].obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  GetStorage storage = GetStorage();
  var isLoading = false.obs;
  Rx<int> selectedDictionaryID = 0.obs;

  Future getAllDictionary() async {
    String? token = storage.read(jwtTokenKey);

    try {
      isLoading.value = true;
      dictionaryList.value = [];

      var result = await APIService.fetchDictionary(token);
      if (result != null) {
        dictionaryList.assignAll(result);
      } else {
        dictionaryList.value = [];
      }
    } finally {
      isLoading.value = false;
    }
  }
}
