// Dart imports:

// Flutter imports:
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger_console/logger_console.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// Project imports:
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/controllers/course_search_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/controllers/my_course_controller.dart';
import 'package:stna_lms_flutter/controllers/notification_controller.dart';
import 'package:stna_lms_flutter/models/system_information_model.dart';
import 'package:stna_lms_flutter/models/user_model.dart';
import 'package:stna_lms_flutter/pages/authentication_page.dart';
import 'package:stna_lms_flutter/pages/main_navigation.dart';
import 'package:stna_lms_flutter/services/api_service.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class DashboardController extends GetxController {
  PersistentTabController persistentTabController =
      PersistentTabController(initialIndex: 0);

  var scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  var loginReturn = " ";

  var loggedIn = false.obs;
  var registerConfirmPhone = false.obs;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final TextEditingController txtRegisterName = TextEditingController();
  final TextEditingController txtRegisterEmail = TextEditingController();
  final TextEditingController txtRegisterPhone = TextEditingController();
  final TextEditingController txtRegisterPassword = TextEditingController();
  final TextEditingController txtRegisterConfirmPassword =
      TextEditingController();
  final TextEditingController txtVerifyCode = TextEditingController();

  final TextEditingController txtForgotPasswordEmail = TextEditingController();
  String? resendEmailAddress;
  final NotificationController notificationController =
      Get.put(NotificationController());
  var isLoading = false.obs;
  Rx<UserModel> profileData = UserModel().obs;
  Rx<SystemInformationModel?> systemInformation = SystemInformationModel().obs;
  Rx<int> currentScreenIndex = 0.obs;
  PackageInfo? packageInfo;
  // 0 is sign in, 1 is sign up, 2 is forgot password

  GetStorage storage = GetStorage();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? section;
  var userId = 0.obs;

  Future setupNotification() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    messaging.getToken().then((value) async {
      if (loggedIn.value && value != null) {
        await saveFCMToken(value);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      notificationController.getNotifications();
      if (message != null && message.notification != null) {
        String? title = message.notification!.title;
        String? body = message.notification!.body;
        String? payload =
            message.data.isNotEmpty ? jsonEncode(message.data) : null;
        if (title == "Cảnh báo đăng nhập") {
          Get.dialog(
            AlertDialog(
              title: const Text(
                'Cảnh báo',
                style: TextStyle(color: Colors.black),
              ),
              content: const Text(
                'Tài khoản của bạn đã được đăng nhập trên thiết bị khác. Vui lòng đăng xuất tài khoản trên thiết bị khác để tiếp tục sử dụng ứng dụng.',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Đồng ý'),
                  onPressed: () {
                    Get.back();
                    signOut();
                  },
                ),
              ],
            ),
            barrierDismissible: kDebugMode,
          );
        }
        if (body != null) {
          flutterLocalNotificationsPlugin.zonedSchedule(
            message.hashCode,
            title ?? '',
            body,
            tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'main_channel', 'Main Channel', 'Main channel notifications',
                  importance: Importance.max,
                  priority: Priority.max,
                  icon: '@drawable/splash'),
              iOS: IOSNotificationDetails(),
            ),
            payload: payload,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
          );

          // Get.defaultDialog(
          //   title: '''${title}''',
          //   titleStyle:
          //       AppTextThemes.heading5().copyWith(color: AppStyles.blueDark),
          //   backgroundColor: Get.theme.cardColor,
          //   barrierDismissible: true,
          //   radius: 10,
          //   content: SingleChildScrollView(
          //     child: ListBody(
          //       children: <Widget>[
          //         Container(
          //           padding: EdgeInsets.symmetric(horizontal: 20),
          //           child: Text(
          //             '''${body}''',
          //             style: AppTextThemes.label4()
          //                 .copyWith(color: AppStyles.primary),
          //           ),
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //       ],
          //     ),
          //   ),
          // );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final main = jsonEncode(message.data);
      final data = jsonDecode(main);

      if (data['title'] != null && data['body'] != null) {
        Get.dialog(
          AlertDialog(
            title: data['image'] != null
                ? Image.network(data['image'], width: 50, height: 50)
                : Image.asset(
                    appLogo,
                    width: 50,
                    height: 50,
                  ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data['title'],
                    style: Get.theme.textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data['body'],
                    style: Get.theme.textTheme.subtitle2,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      }
    });
  }

  Future saveFCMToken(String? deviceToken) async {
    if (deviceToken != null) {
      // should save token to device
      await storage.write(fcmTokenKey, deviceToken);
    }
  }

  Future checkUserDeviceToken() async {
    // call API with user token + device token to verify device
    String? token = storage.read(jwtTokenKey);
    String? fcmToken = storage.read(fcmTokenKey);

    if (fcmToken != null && token != null) {
      // should save token to device
      final activity = await APIService.postVerifyDeviceToken(
        token,
        fcmToken,
        userId.value,
      );

      if (activity == false) {
        Get.dialog(
          AlertDialog(
            title: const Text(
              'Cảnh báo',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'Tài khoản của bạn đã được đăng nhập trên thiết bị khác. Vui lòng đăng xuất tài khoản trên thiết bị khác để tiếp tục sử dụng ứng dụng.',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Đồng ý'),
                onPressed: () {
                  Get.back();
                  signOut();
                },
              ),
            ],
          ),
          barrierDismissible: kDebugMode,
        );
      }
    }
  }

  Future<String?> _readToken() async {
    String? token = storage.read(jwtTokenKey);
    return token;
  }

  Future _writeToken(String token) async {
    await storage.write(jwtTokenKey, token);
  }

  Future _eraseToken() async {
    await storage.remove(jwtTokenKey);
    await storage.remove(fcmTokenKey);
  }

  void changeTabIndex(int index,
      {CourseSearchController? courseSearchController,
      HomeController? homeController,
      MyCourseController? myCourseController,
      NotificationController? notificationController}) async {
    Get.focusScope!.unfocus();
    persistentTabController.index = index;

    await getSystemInformation();

    switch (index) {
      case 0:
        homeController?.onInit();
        break;
      case 1:
        courseSearchController?.fetchAllCourse(null);
        break;
      case 2:
        break;
      case 3:
        myCourseController?.onInit();
        break;
      case 4:
        await getProfileData();

        break;
    }
  }

  Future<String?> getUserToken() async {
    String? token = await _readToken();
    checkToken();

    isLoading(false);
    return token;
  }

  Future<bool> checkToken() async {
    String? token = await _readToken();
    bool validToken = token != null;
    loggedIn.value = validToken;
    update();

    return validToken;
  }

  Future<bool> signUp() async {
    try {
      isLoading(true);

      var register = await APIService.register(
          name: txtRegisterName.text,
          email: txtRegisterEmail.text.toLowerCase(),
          phone: txtRegisterPhone.text,
          password: txtRegisterPassword.text);

      if (register != null) {
        resendEmailAddress = txtRegisterEmail.text;
        registerConfirmPhone.value = true;
        update();
        clearInputs();
        return true;
      }

      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<dynamic> forgotPassword({
    required String phone,
    required String newPassword,
    required String token,
  }) async {
    try {
      isLoading(true);

      var response = await APIService.forgotPassword(
        phone: phone,
        newPassword: newPassword,
        token: token,
      );

      return response;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> confirmOtp() async {
    try {
      isLoading(true);

      var response = await APIService.confirmOtp(
        otp: txtVerifyCode.text,
        session: section ?? '',
      );

      if (response != null) {
        clearInputs();
        return true;
      }

      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> confirmOtpToServer({
    required String otp,
    required String session,
  }) async {
    try {
      isLoading(true);

      var response = await APIService.confirmOtp(
        otp: otp,
        session: session,
      );

      if (response != null) {
        return true;
      }

      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> deleteAccount() async {
    String? token = storage.read(jwtTokenKey);

    await APIService.postLogActivity(
      token,
      type: 'deleteAccount',
      activity: 'người dùng đóng tài khoản',
    );

    return await APIService.postDeleteAccount(token);
  }

  Future<void> signOut() async {
    String? token = storage.read(jwtTokenKey);
    String? fcmToken = storage.read(fcmTokenKey);

    await APIService.postLogActivity(
      token,
      type: 'logout',
      activity: 'người dùng đăng xuất',
    );

    if (fcmToken != null) {
      await APIService.logout(deviceToken: fcmToken);
    }

    await _eraseToken();
    loggedIn.value = false;
    update();

    final HomeController _homeController = Get.put(HomeController());

    showSignInScreen();
    Get.off(() => const AuthenticationPage());
    changeTabIndex(0, homeController: _homeController);
  }

  Future<String?> sendOtpToServer(String phone) async {
    try {
      isLoading(true);

      var request = await APIService.sendOtp(phone: phone);
      if (request != null) {
        // clearInputs();
        return request['session'];
      }

      return null;
    } finally {
      isLoading(false);
    }
  }

  Future signIn() async {
    try {
      isLoading(true);

      var login = await APIService.login(email.text, password.text);
      if (login != null) {
        clearInputs();

        var token = login['jwt'];
        var user = login['user'];

        if (user != null && token != null) {
          userId.value = user['id'] as int;
          token = token;
          _writeToken(token);
          await checkToken();
          await setupNotification();

          await APIService.postLogActivity(
            token,
            type: 'login',
            activity: 'người dùng đăng nhập',
          );

          return login;
        }
      }

      return null;
    } finally {
      isLoading(false);
    }
  }

  void showRegisterScreen() {
    currentScreenIndex.value = 1;

    clearRegisterScreen();
  }

  void clearRegisterScreen() {
    txtRegisterConfirmPassword.text = '';
    txtRegisterEmail.text = '';
    txtRegisterName.text = '';
    txtRegisterPassword.text = '';
    txtRegisterPhone.text = '';
    txtVerifyCode.text = '';
  }

  void resendRegisterConfirmEmail() async {
    try {
      isLoading(true);

      var result = await APIService.postResendRegisterConfirmEmail(
          resendEmailAddress ?? '');
      if (!result) {
        AlertUtils.error();
      }
    } finally {
      isLoading(false);
    }
  }

  void sendOtp() async {
    try {
      isLoading(true);

      var result = await APIService.sendOtp(phone: txtRegisterPhone.text);

      if (result != null) {
        section = result['session'];
        Console.log('sendOtp', result['session']);
      }
    } finally {
      isLoading(false);
    }
  }

  void showSignInScreen() {
    currentScreenIndex.value = 0;

    email.text = '';
    password.text = '';
  }

  void showForgotPasswordScreen() {
    currentScreenIndex.value = 2;

    txtForgotPasswordEmail.text = '';
  }

  // get user profile data
  Future<UserModel?> getProfileData() async {
    String? token = await _readToken();
    try {
      isLoading(true);

      var profile = await APIService.fetchUserProfile(token ?? '');
      if (profile != null) {
        profileData.value = profile;
      }

      return profile;
    } finally {
      isLoading(false);
    }
  }

  Future getPackageInformation() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future getSystemInformation() async {
    String? token = await _readToken();

    try {
      var meta = await APIService.fetchSystemInformations(token ?? '');
      await getPackageInformation(); // get package information

      if (meta != null && meta.releaseVersion != null) {
        Version releaseVersion = Version.parse(
            meta.releaseVersion == null ? '0.0.1' : meta.releaseVersion!);
        Version currentVersion =
            Version.parse(packageInfo == null ? '0.0.1' : packageInfo!.version);

        meta.releaseMode = kDebugMode ? true : releaseVersion >= currentVersion;

        print('** is_android ${meta.isAndroid}');
        print('** is_ios ${meta.isIos}');
        print('** is_web $kIsWeb');
        print('** current_version ${currentVersion.toString()}');
        print('** release_version ${releaseVersion.toString()}');
        print('** release_mode ${meta.releaseMode}');
        systemInformation.value = meta;
      } else {
        systemInformation.value = SystemInformationModel();
      }
    } finally {}
  }

  void clearInputs() {
    // clear inputs
    email.text = '';
    password.text = '';

    // clear inputs
    txtRegisterConfirmPassword.text = '';
    txtRegisterEmail.text = '';
    txtRegisterName.text = '';
    txtRegisterPassword.text = '';
    // txtRegisterPhone.text = '';
    txtVerifyCode.text = '';

    // clear inputs
    txtForgotPasswordEmail.text = '';
  }

  var obscurePass = true.obs;
  var obscureNewPass = true.obs;
  var obscureConfirmPass = true.obs;

  @override
  void onInit() async {
    var validToken = await checkToken();

    if (validToken) {
      await getSystemInformation();
      await getProfileData();
      await setupNotification();
    } else {
      await _eraseToken();
      await getPackageInformation();
      showSignInScreen();
      Get.off(() => const AuthenticationPage());
    }

    tz.initializeTimeZones();

    super.onInit();
  }
}
