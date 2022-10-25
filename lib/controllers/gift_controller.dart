import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/models/gift_model.dart';
import 'package:stna_lms_flutter/services/api_service.dart';

class GiftController extends GetxController {
  var isLoading = false.obs;
  GetStorage storage = GetStorage();

  // notification detail page
  RxBool isGiftDetailLoading = false.obs;
  RxInt giftDetailId = 0.obs;
  Rx<GiftModel> giftDetail = GiftModel().obs;

  Future<bool> getGiftDetail() async {
    String? token = storage.read(jwtTokenKey);
    try {
      isGiftDetailLoading.value = true;
      var gift = await APIService.fetchGift(token, giftDetailId.value);
      if (gift == null) {
        giftDetail.value = GiftModel();
        return false;
      }

      giftDetail.value = gift;
      return true;
    } finally {
      isGiftDetailLoading.value = false;
    }
  }
}
