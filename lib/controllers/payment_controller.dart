// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/models/promo_code_model.dart';
// Project imports:
import 'package:stna_lms_flutter/services/api_service.dart';
import 'package:stna_lms_flutter/widgets/payment/payment_instruction_widget.dart';
import 'package:uuid/uuid.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;

  GetStorage storage = GetStorage();

  final TextEditingController promoCodeText = TextEditingController();
  Rx<PromoCodeModel?> promoCode = PromoCodeModel().obs;
  Rx<bool> isPromoCodeValidated = false.obs;

  final uuid = const Uuid(); // testing

  void resetPromoCodeForm() {
    promoCodeText.text = '';
    isPromoCodeValidated.value = false;
  }

  Future<bool> applyPromoCode() async {
    String? token = storage.read(jwtTokenKey);

    try {
      var result =
          await APIService.postApplyPromoCode(token, promoCodeText.text);
      if (result) {
        isPromoCodeValidated.value = false;
        promoCodeText.text = '';
        return true;
      } else {
        return false;
      }
    } finally {}
  }

  Future<PromoCodeModel?> validatePromoCode() async {
    String? token = storage.read(jwtTokenKey);

    try {
      isLoading(true);

      var result =
          await APIService.postValidatePromoCode(token, promoCodeText.text);

      if (result != null) {
        promoCode.value = result;
        isPromoCodeValidated.value = true;
      } else {
        promoCode.value = PromoCodeModel();
        isPromoCodeValidated.value = false;
      }

      return result;
    } finally {
      isLoading(false);
    }
  }

  void showPaymentInstructionDialog() async {
    String? token = storage.read(jwtTokenKey);
    APIService.postLogActivity(token,
        type: 'request_checkout',
        activity: 'người dùng yêu cầu xem hướng dẫn thanh toán');

    Get.defaultDialog(
        title: 'Hướng dẫn thanh toán',
        backgroundColor: Get.theme.cardColor,
        titleStyle:
            AppTextThemes.heading5().copyWith(color: AppStyles.blueDark),
        barrierDismissible: true,
        radius: 10.sp,
        content: PaymentInstructionWidget());
  }
}
