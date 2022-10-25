import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/helpers/loading_helper.dart';
import 'package:stna_lms_flutter/pages/about_us_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/account/change_password.dart';
import 'package:stna_lms_flutter/widgets/account/edit_profile.dart';
import 'package:stna_lms_flutter/widgets/account/edit_referral_program.dart';
import 'package:stna_lms_flutter/widgets/account/redeem_code.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final DashboardController _controller = Get.put(DashboardController());

  final _wp = Get.width / 100;
  final _hp = Get.height / 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var releaseMode = _controller.systemInformation.value!.releaseMode;
    var isVip = releaseMode ? _controller.profileData.value.isVip : false;
    var appVersion = _controller.packageInfo?.version;
    var appName = _controller.packageInfo?.appName;

    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: defaultLoadingWidget,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            appBar: const AppBarWidget(title: "Tài Khoản"),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 75.sp),
              child: Obx(() {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: Get.width,
                      margin: EdgeInsets.only(
                          left: 20.sp, right: 20.sp, top: 20.sp),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5.sp),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200),
                            child: _controller.profileData.value.avatar == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey.shade300,
                                    radius: 40.sp,
                                    backgroundImage: defaultAccountImage(),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    radius: 40.sp,
                                    backgroundImage: NetworkImage(
                                        getFullResourceUrl(_controller
                                                .profileData.value.avatar ??
                                            '')),
                                  ),
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _controller.profileData.value.fullName ?? 'N/A',
                                style: AppTextThemes.heading4()
                                    .copyWith(color: AppStyles.blueLight),
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              Container(
                                width: 200.sp,
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 5.sp),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    LayoutUtils.fadeInImage(
                                        fit: BoxFit.cover,
                                        height: 20.sp,
                                        image: AssetImage(isVip
                                            ? 'images/layout/vip-account.png'
                                            : 'images/layout/free-account.png')),
                                    SizedBox(
                                      width: 10.sp,
                                    ),
                                    Text(
                                      isVip ? 'VIP' : 'Cá Nhân',
                                      style: TextStyle(
                                          color: isVip
                                              ? AppStyles.yellow
                                              : AppStyles.blueDark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.sp),
                                    ),
                                    SizedBox(
                                      width: 5.sp,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.sp,
                    ),
                    GestureDetector(
                      child: appDrawerListItem('Thông Tin Cá Nhân',
                          icon: FontAwesomeIcons.userEdit,
                          color: AppStyles.colorWheels[0]),
                      onTap: () {
                        _controller.getProfileData();
                        _controller.scaffoldKey.currentState!.openDrawer();

                        Get.to(() => const EditProfile());
                      },
                    ),
                    GestureDetector(
                      child: appDrawerListItem('Chương Trình Referral',
                          icon: FontAwesomeIcons.peopleArrows,
                          color: AppStyles.colorWheels[1]),
                      onTap: () {
                        Get.to(() => EditReferralProgram());
                      },
                    ),
                    GestureDetector(
                      child: appDrawerListItem('Đổi Mật Khẩu',
                          icon: FontAwesomeIcons.key,
                          color: AppStyles.colorWheels[2]),
                      onTap: () {
                        Get.to(() => const ChangePassword());
                      },
                    ),
                    GestureDetector(
                      child: appDrawerListItem('Đổi Mã Khuyến Mãi',
                          icon: FontAwesomeIcons.exchangeAlt,
                          color: AppStyles.colorWheels[3]),
                      onTap: () {
                        Get.to(() => const RedeemCode());
                      },
                    ),
                    GestureDetector(
                      child: appDrawerListItem('Đóng Tài Khoản',
                          icon: FontAwesomeIcons.userLock,
                          color: Colors.grey.shade500),
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            title: Text(
                              'Đóng tài khoản ?',
                              style: AppTextThemes.heading6(),
                            ),
                            content: const Text(
                                'Sau khi chọn đóng tài khoản, bạn sẽ không thể hoàn tác cũng như tất cả khóa học đã đăng ký sẽ bị xóa.'),
                            actions: <Widget>[
                              LayoutUtils.alertDialogCancelButton(
                                  text: 'Hủy',
                                  onPressed: () {
                                    Get.back();
                                  }),
                              LayoutUtils.alertDialogConfirmButton(
                                  text: 'Đóng Tài Khoản',
                                  bgColor: AppStyles.redDark,
                                  onPressed: () async {
                                    context.loaderOverlay.show();

                                    var result =
                                        await _controller.deleteAccount();

                                    context.loaderOverlay.hide();

                                    Get.back();

                                    if (result) {
                                      AlertUtils.success(
                                          'Tài khoản đã bị đóng !');
                                      await _controller.signOut();
                                    } else {
                                      AlertUtils.error();
                                    }
                                  }),
                            ],
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      child: appDrawerListItem('Về chúng tôi',
                          icon: FontAwesomeIcons.infoCircle,
                          color: AppStyles.colorWheels[3]),
                      onTap: () {
                        Get.to(() => AboutUsPage());
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 40.sp, right: 40.sp, top: 5.sp, bottom: 5.sp),
                      child: const Divider(
                        thickness: 1,
                      ),
                    ),
                    GestureDetector(
                      child: appDrawerListItem("Đăng Xuất",
                          icon: FontAwesomeIcons.signOutAlt,
                          color: AppStyles.red),
                      onTap: () async {
                        context.loaderOverlay.show();

                        await _controller.signOut();

                        context.loaderOverlay.hide();
                      },
                    ),
                    LayoutUtils.version(
                        appName: appName, appVersion: appVersion)
                  ],
                );
              }),
            ),
          ),
        ));
  }

  Widget appDrawerListItem(String txt,
      {required Color color, required IconData icon}) {
    return Container(
      padding: EdgeInsets.only(
          left: _wp * 4, right: _wp * 4, top: _hp * 2, bottom: _hp * 2),
      margin: EdgeInsets.only(
          left: _wp * 10, right: _wp * 10, top: _hp * 1, bottom: _hp * 1),
      decoration: LayoutUtils.boxDecoration(),
      child: Row(
        children: [
          SizedBox(
            width: 10.sp,
          ),
          FaIcon(
            icon,
            size: 14.sp,
            color: color,
          ),
          SizedBox(
            width: _wp * 4,
          ),
          Text(
            txt,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 10.sp),
          ),
          Expanded(child: Container()),
          FaIcon(
            FontAwesomeIcons.angleRight,
            color: color,
            size: 14.sp,
          ),
          SizedBox(
            width: 10.sp,
          ),
        ],
      ),
    );
  }
}
