// Dart imports:

// Flutter imports:
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/payment_controller.dart';
import 'package:stna_lms_flutter/helpers/date_helper.dart';
import 'package:stna_lms_flutter/helpers/loading_helper.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RedeemCode extends StatefulWidget {
  const RedeemCode({Key? key}) : super(key: key);

  @override
  _RedeemCodeState createState() => _RedeemCodeState();
}

class _RedeemCodeState extends State<RedeemCode> {
  final _formKey = GlobalKey<FormState>();
  final DashboardController _dashboardController =
      Get.put(DashboardController());
  final PaymentController controller = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();

    controller.resetPromoCodeForm();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var heightPercent = height / 100;
    var width = MediaQuery.of(context).size.width;
    var widthPercent = width / 100;

    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: defaultLoadingWidget,
        child: SafeArea(
          child: Scaffold(
              appBar: const AppBarWidget(
                title: "Đổi Mã Khuyến Mãi",
                showBack: true,
              ),
              body: SingleChildScrollView(child: Obx(() {
                // loading
                if (controller.isLoading.value) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child:
                          CircularProgressIndicator(color: AppStyles.secondary),
                    ),
                  );
                }

                // promo code validated
                if (controller.isPromoCodeValidated.value) {
                  return Center(
                      child: Column(
                    children: [
                      SizedBox(
                        width: Get.width,
                        height: heightPercent * 20,
                        child:
                            Image.asset('images/layout/promo-code-success.png'),
                      ),
                      SizedBox(
                        height: heightPercent * 1,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.sp),
                        margin: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(10.sp),
                          padding: const EdgeInsets.all(10),
                          dashPattern: const [8, 4],
                          color: AppStyles.green,
                          strokeWidth: 5,
                          child: ClipRRect(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, left: 15, right: 15),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppStyles.green,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Text(
                                    controller.promoCode.value?.code ?? 'N/A',
                                    textAlign: TextAlign.center,
                                    style: AppTextThemes.heading2()
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                                controller.promoCode.value?.expiredDate == null
                                    ? Container()
                                    : Container(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 15,
                                            bottom: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Ngày hết hạn',
                                              style: AppTextThemes.heading6(),
                                            ),
                                            Text(
                                              DateHelper.formatDate(controller
                                                  .promoCode
                                                  .value
                                                  ?.expiredDate),
                                              style: AppTextThemes.label3(),
                                            )
                                          ],
                                        ),
                                      ),
                                (controller.promoCode.value?.duration == null ||
                                        controller.promoCode.value?.duration ==
                                            0)
                                    ? Container()
                                    : Container(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 15,
                                            bottom: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Thời hạn',
                                              style: AppTextThemes.heading6(),
                                            ),
                                            Text(
                                              '${controller.promoCode.value?.duration} ngày',
                                              style: AppTextThemes.label3(),
                                            )
                                          ],
                                        ),
                                      ),
                                controller.promoCode.value?.description == null
                                    ? Container()
                                    : Container(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 15,
                                            bottom: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Mô tả',
                                              style: AppTextThemes.heading6(),
                                            ),
                                            Text(
                                                controller.promoCode.value
                                                        ?.description ??
                                                    'N/A',
                                                style: AppTextThemes.label3())
                                          ],
                                        ),
                                      ),
                                controller.promoCode.value?.type == 'vip_access'
                                    ? Container(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Nội dung',
                                              style: AppTextThemes.heading6(),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.circle_rounded,
                                                  size: 8.sp,
                                                  color: AppStyles.blueDark,
                                                ),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Flexible(
                                                    child: Text(
                                                        'Được cấp quyền truy cập tới tất cả chức năng, ứng dụng',
                                                        style: AppTextThemes
                                                            .label3()))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.circle_rounded,
                                                  size: 8.sp,
                                                  color: AppStyles.blueDark,
                                                ),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Flexible(
                                                    child: Text(
                                                        'Được cấp quyền tham gia tất cả khóa học',
                                                        style: AppTextThemes
                                                            .label3()))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.circle_rounded,
                                                  size: 8.sp,
                                                  color: AppStyles.blueDark,
                                                ),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Flexible(
                                                    child: Text(
                                                        'Được cấp quyền tham gia tất cả bài kiểm tra',
                                                        style: AppTextThemes
                                                            .label3()))
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                (controller.promoCode.value?.courses != null &&
                                        controller.promoCode.value!.courses!
                                            .isNotEmpty)
                                    ? Container(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 15,
                                            bottom: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Khóa học được tặng gồm',
                                              style: AppTextThemes.heading6(),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Obx(() {
                                                return ListView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    // physics:
                                                    //     const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: controller
                                                        .promoCode
                                                        .value!
                                                        .courses!
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      var course = controller
                                                          .promoCode
                                                          .value!
                                                          .courses![index];
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5,
                                                                bottom: 5,
                                                                left: 10,
                                                                right: 10),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .book_rounded,
                                                                color: AppStyles
                                                                    .blueDark,
                                                                size: 14.sp,
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Text(
                                                                course.name ??
                                                                    'N/A',
                                                                style: AppTextThemes
                                                                        .heading6()
                                                                    .copyWith(
                                                                        color: AppStyles
                                                                            .secondary),
                                                              ),
                                                            ]),
                                                      );
                                                    });
                                              }),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: heightPercent * 2),
                      LayoutUtils.button(
                          text: 'Sử Dụng',
                          readonly: controller.isLoading.value,
                          gradient: LayoutUtils.gradientGreen,
                          onPressed: () async {
                            context.loaderOverlay.show();

                            var result = await controller.applyPromoCode();
                            if (result) {
                              await _dashboardController.getProfileData();
                              AlertUtils.success(
                                  'Mã khuyến mãi đã được áp dụng');
                            } else {
                              AlertUtils.error();
                            }

                            context.loaderOverlay.hide();
                          }),
                      SizedBox(height: heightPercent * 2),
                    ],
                  ));
                }

                // submit promo code
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: Get.width,
                        height: heightPercent * 30,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.sp))),
                          margin: EdgeInsets.all(10.sp),
                          child: Image.asset('images/layout/redeem-code.png'),
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.sp),
                        margin: EdgeInsets.symmetric(horizontal: 10.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                'Vui lòng nhập mã khuyến mãi vào ô bên dưới',
                                style: AppTextThemes.label3(),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.sp),
                        margin: EdgeInsets.symmetric(horizontal: 10.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Mã khuyến mãi hợp lệ gồm',
                                  style: AppTextThemes.label3(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.circle_rounded,
                                  size: 6.sp,
                                ),
                                SizedBox(
                                  width: 10.sp,
                                ),
                                Flexible(
                                  child: Text(
                                    'Có từ 8-16 ký tự',
                                    style: AppTextThemes.label3(),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.circle_rounded,
                                  size: 6.sp,
                                ),
                                SizedBox(
                                  width: 10.sp,
                                ),
                                Flexible(
                                  child: Text(
                                    'Bao gồm các chữ cái từ A-Z và chữ số từ 0-9',
                                    style: AppTextThemes.label3(),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.circle_rounded,
                                  size: 6.sp,
                                ),
                                SizedBox(
                                  width: 10.sp,
                                ),
                                Flexible(
                                  child: Text(
                                    'Viết hoa',
                                    style: AppTextThemes.label3(),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                child: Text(
                                  "Làm sao để mua mã khuyến mãi ?",
                                  style: AppTextThemes.heading6(),
                                ),
                                onTap: () async {
                                  controller.showPaymentInstructionDialog();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.only(
                            left: widthPercent * 10, right: widthPercent * 10),
                        child: TextFormField(
                          controller: controller.promoCodeText,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            UpperCaseTextFormatter(),
                          ],
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
                            hintText: 'Mã khuyến mãi',
                            hintStyle: TextStyle(
                                color: const Color(0xff8E99B7),
                                fontSize: 14.sp),
                            suffixIcon: Icon(
                              Icons.text_fields_rounded,
                              size: 16.sp,
                              color: const Color.fromRGBO(142, 153, 183, 0.5),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập mã khuyến mãi';
                            }
                            if (value.length < 8) {
                              return 'Độ dài mã phải nhiều hơn 8 ký tự';
                            }
                            return null;
                          },
                        ),
                      ),
                      LayoutUtils.button(
                          readonly: controller.isLoading.value,
                          text: 'Kiểm Tra',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var promoCode =
                                  await controller.validatePromoCode();
                              if (promoCode != null) {
                                // success
                                // AlertUtils.success('Mã khuyến mãi hợp lệ');
                              } else {
                                // failure
                                AlertUtils.error();
                              }
                            }
                          }),
                      SizedBox(height: heightPercent * 2),
                    ],
                  ),
                );
              }))),
        ));
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
