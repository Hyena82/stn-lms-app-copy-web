import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/payment_controller.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';

class PaymentInstructionWidget extends StatelessWidget {
  final PaymentController controller = Get.put(PaymentController());
  final DashboardController _dashboardController =
      Get.put(DashboardController());

  PaymentInstructionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var widthPercent = width / 100;
    var height = MediaQuery.of(context).size.height;
    var heightPercent = height / 100;

    ImageProvider<Object> image = const AssetImage('images/layout/payment.png');

    if (_dashboardController.systemInformation.value!.paymentBanner != null) {
      image = NetworkImage(getFullResourceUrl(
          _dashboardController.systemInformation.value!.paymentBanner ?? ''));
    }

    return Container(
      color: Colors.white,
      width: widthPercent * 75,
      height: heightPercent * 50,
      child: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LayoutUtils.gradientGreyLight,
                borderRadius: BorderRadius.circular(5.sp)),
            margin: EdgeInsets.only(right: 5.sp, left: 5.sp, bottom: 5.sp),
            padding: const EdgeInsets.all(5),
            child: LayoutUtils.fadeInImage(
                fit: BoxFit.cover, height: heightPercent * 20, image: image),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: markdown(_dashboardController
                  .systemInformation.value!.paymentInstruction))
        ],
      )),
    );
  }
}
