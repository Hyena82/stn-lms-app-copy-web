import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/utils/launcher_utils.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class AboutUsPage extends StatelessWidget {
  AboutUsPage({Key? key}) : super(key: key);
  final DashboardController _dashboardController =
      Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Thông tin về Super English',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: AppStyles.blueDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                Image.asset(
                  'images/layout/about_us.png',
                  height: 172,
                ),
                const SizedBox(height: 13),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "${_dashboardController.systemInformation.value!.introduce}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppStyles.textAbout,
                          height: 22 / 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 15),
                _buildRowInfo(
                  onTap: () {},
                  title:
                      "${_dashboardController.systemInformation.value!.address}",
                  icon: 'images/location.png',
                ),
                const SizedBox(height: 15),
                _buildRowInfo(
                  onTap: () {
                    UrlLauncher.launch(
                        "tel:${_dashboardController.systemInformation.value!.phoneNumber}");
                  },
                  title:
                      "${_dashboardController.systemInformation.value!.phoneNumber}",
                  icon: 'images/call.png',
                ),
                const SizedBox(height: 15),
                _buildRowInfo(
                  onTap: () {},
                  title:
                      "${_dashboardController.systemInformation.value!.email}",
                  icon: 'images/message.png',
                ),
                const SizedBox(height: 15),
                _buildRowInfo(
                  onTap: () {
                    LauncherUtils.launchBrowserUrl(
                        "${_dashboardController.systemInformation.value!.website}");
                  },
                  title:
                      "${_dashboardController.systemInformation.value!.website}",
                  icon: 'images/internet.png',
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowInfo({
    required String title,
    required String icon,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(icon, height: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppStyles.blueDark,
                height: 16 / 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
