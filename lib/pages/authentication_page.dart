// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:

import 'package:get/get.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/helpers/loading_helper.dart';
import 'package:stna_lms_flutter/widgets/authentication/forgot_password_widget.dart';
import 'package:stna_lms_flutter/widgets/authentication/sign_in_widget.dart';
import 'package:stna_lms_flutter/widgets/authentication/sign_up_widget.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AuthenticationPage extends GetView<DashboardController> {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: defaultLoadingWidget,
        child: Scaffold(
          appBar: const AppBarWidget(
            showLogo: false,
            height: 0,
          ),
          body: Obx(() {
            if (controller.currentScreenIndex.value == 1) {
              return const SignUpWidget();
            } else if (controller.currentScreenIndex.value == 2) {
              return ForgotPasswordWidget();
            } else {
              return const SignInWidget();
            }
          }),
        ));
  }
}
