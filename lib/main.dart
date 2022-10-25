// Flutter imports:

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger_console/logger_console.dart';
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/controllers/course_search_controller.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/edit_profile_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/controllers/my_course_controller.dart';
import 'package:stna_lms_flutter/controllers/notification_controller.dart';
import 'package:stna_lms_flutter/controllers/payment_controller.dart';
import 'package:stna_lms_flutter/pages/splash_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:wakelock/wakelock.dart';

// Project imports:
import 'configs/app_themes.dart';
import 'services/theme_service.dart';

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  await GetStorage.init();
  HttpOverrides.global = MyHttpoverrides();
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();

  if (!kIsWeb && Platform.isAndroid) {
    Console.host = '192.168.1.72';
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  late Future<FirebaseApp> _initialization;

  @override
  void initState() {
    if (kIsWeb) {
      _initialization = Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCC7wJncAK5xHfq7fkkq4BtlUIIBgD0Rkw',
              appId: '1:602375111201:web:775d54995d1187cfb55960',
              messagingSenderId: '602375111201',
              projectId: 'stn-lms-test'));
    } else {
      _initialization = Firebase.initializeApp();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: ScreenUtilInit(
      designSize: const Size(360, 360),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: companyName,
          debugShowCheckedModeBanner: false,
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: ThemeService().theme,
          home: FutureBuilder(
              future: _initialization,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text(
                        snapshot.error.toString(),
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return const Scaffold(
                    body: SplashScreen(),
                  );
                }

                return const CircularProgressIndicator(
                    color: AppStyles.secondary);
              }),
          initialBinding: MainAppBinding(),
          builder: (BuildContext context, Widget? child) {
            return FlutterSmartDialog(child: child);
          },
        );
      },
    ));
  }
}

class MainAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CourseSearchController>(() => CourseSearchController());
    Get.lazyPut<MyCourseController>(() => MyCourseController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<EditProfileController>(() => EditProfileController());
    Get.lazyPut<PaymentController>(() => PaymentController());
  }
}
