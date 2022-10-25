import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/pages/authentication_page.dart';
import 'package:stna_lms_flutter/pages/main_navigation.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DashboardController _dashboardController =
      Get.put(DashboardController());

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () async {
      var validToken = await _dashboardController.checkToken();

      if (validToken) {
        Get.off(() => const MainNavigationPage());
      } else {
        _dashboardController.showSignInScreen();
        Get.off(() => const AuthenticationPage());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.primaryColor,
        body: Center(
            child: Container(
          decoration: const BoxDecoration(color: AppStyles.blueLightest),
          child: Center(
            child: Image.asset(
              'images/$appLogo',
              width: (Get.width / 100) * 30,
              fit: BoxFit.fitWidth,
            ),
          ),
        )));
  }
}
