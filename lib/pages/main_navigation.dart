// Flutter imports:

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:stna_lms_flutter/controllers/course_search_controller.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/controllers/my_course_controller.dart';
import 'package:stna_lms_flutter/controllers/notification_controller.dart';
import 'package:stna_lms_flutter/pages/account_page.dart';
import 'package:stna_lms_flutter/pages/course_detail_page.dart';
import 'package:stna_lms_flutter/pages/course_progress_page.dart';
import 'package:stna_lms_flutter/pages/course_search_page.dart';
import 'package:stna_lms_flutter/pages/home_page.dart';
import 'package:stna_lms_flutter/pages/my_resource_page.dart';
import 'package:stna_lms_flutter/pages/utilities_page.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rxdart/rxdart.dart';

//notificatiopn handler
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({Key? key}) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  final DashboardController _controller = Get.put(DashboardController());
  final CourseSearchController _allCourseController =
      Get.put(CourseSearchController());
  final HomeController _homeController = Get.put(HomeController());
  final MyCourseController _myCourseController = Get.put(MyCourseController());
  final NotificationController _notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // _notificationController.getNotifications();
    // print('get in app');
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        var data = jsonDecode(payload);
        selectNotificationSubject.add(payload);

        String link = data['link'] ?? 'none';
        switch (link) {
          case 'all_course':
            _controller.changeTabIndex(
              1,
              courseSearchController: _allCourseController,
            );
            break;
          case 'utilities':
            _controller.changeTabIndex(2);
            break;
          case 'home':
            _controller.changeTabIndex(0, homeController: _homeController);
            break;
          case 'my_resources':
            _controller.changeTabIndex(3,
                myCourseController: _myCourseController);
            break;
          case 'account':
            _controller.changeTabIndex(4);
            break;
          case 'course':
            int courseId = dynamicToInt(data['linkParameter']);

            _homeController.courseID.value = courseId;

            var course = await _homeController.fetchCourseDetail();

            if (course == null) {
              AlertUtils.warn(
                  'Khóa học đang được xây dựng. Vui lòng quay lại sau');
              return;
            }

            if (course.isEnrolled) {
              Get.to(() => const CourseProgressPage());
            } else {
              Get.to(() => const CourseDetailPage());
            }
            break;
        }
      }
    });

    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Ok'),
              onPressed: () async {},
            )
          ],
        ),
      );
    });

    selectNotificationSubject.stream.listen((String payload) async {});

    _controller.checkUserDeviceToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      builder: (context) {
        return SafeArea(
          child: Scaffold(
            key: _controller.scaffoldKey,
            body: GestureDetector(
              onTap: () {
                Get.focusScope!.unfocus();
              },
              child: PersistentTabView(
                context,
                controller: _controller.persistentTabController,
                screens: kIsWeb
                    ? [
                        HomePage(),
                        const UtilitiesPage(),
                      ]
                    : [
                        HomePage(),
                        const CourseSearchPage(),
                        const UtilitiesPage(),
                        const MyResourcePage(),
                        // NotificationPage(),
                        const AccountPage(),
                      ],
                items: kIsWeb
                    ? [
                        PersistentBottomNavBarItem(
                          inactiveIcon: const Icon(
                            Icons.home_rounded,
                            color: Colors.white,
                          ),
                          icon: const Icon(
                            Icons.home_rounded,
                            color: AppStyles.blueDark,
                          ),
                          title: 'Trang Chủ',
                          textStyle: TextStyle(
                              fontSize: 10.sp, fontWeight: FontWeight.bold),
                          activeColorSecondary: AppStyles.blueDark,
                          activeColorPrimary: AppStyles.white,
                          inactiveColorPrimary: AppStyles.white,
                        ),
                        PersistentBottomNavBarItem(
                          inactiveIcon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          icon: const Icon(
                            Icons.settings,
                            color: AppStyles.blueDark,
                          ),
                          title: 'Tiện Ích',
                          textStyle: TextStyle(
                              fontSize: 10.sp, fontWeight: FontWeight.bold),
                          activeColorSecondary: AppStyles.blueDark,
                          activeColorPrimary: AppStyles.white,
                          inactiveColorPrimary: AppStyles.white,
                        ),
                      ]
                    : [
                        PersistentBottomNavBarItem(
                          inactiveIcon: const Icon(
                            Icons.home_rounded,
                            color: Colors.white,
                          ),
                          icon: const Icon(
                            Icons.home_rounded,
                            color: AppStyles.blueDark,
                          ),
                          title: 'Trang Chủ',
                          textStyle: TextStyle(
                              fontSize: 10.sp, fontWeight: FontWeight.bold),
                          activeColorSecondary: AppStyles.blueDark,
                          activeColorPrimary: AppStyles.white,
                          inactiveColorPrimary: AppStyles.white,
                        ),
                        PersistentBottomNavBarItem(
                          inactiveIcon: const Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                          ),
                          icon: const Icon(
                            Icons.search_rounded,
                            color: AppStyles.blueDark,
                          ),
                          title: 'Tìm Kiếm',
                          textStyle: TextStyle(
                              fontSize: 10.sp, fontWeight: FontWeight.bold),
                          activeColorSecondary: AppStyles.blueDark,
                          activeColorPrimary: AppStyles.white,
                          inactiveColorPrimary: AppStyles.white,
                        ),
                        PersistentBottomNavBarItem(
                          inactiveIcon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          icon: const Icon(
                            Icons.settings,
                            color: AppStyles.blueDark,
                          ),
                          title: 'Tiện Ích',
                          textStyle: TextStyle(
                              fontSize: 10.sp, fontWeight: FontWeight.bold),
                          activeColorSecondary: AppStyles.blueDark,
                          activeColorPrimary: AppStyles.white,
                          inactiveColorPrimary: AppStyles.white,
                        ),
                        PersistentBottomNavBarItem(
                          inactiveIcon: const Icon(
                            Icons.book_rounded,
                            color: Colors.white,
                          ),
                          icon: const Icon(
                            Icons.book_rounded,
                            color: AppStyles.blueDark,
                          ),
                          title: 'Đã Học',
                          textStyle: TextStyle(
                              fontSize: 10.sp, fontWeight: FontWeight.bold),
                          activeColorSecondary: AppStyles.blueDark,
                          activeColorPrimary: AppStyles.white,
                          inactiveColorPrimary: AppStyles.white,
                        ),
                        PersistentBottomNavBarItem(
                          inactiveIcon: const Icon(
                            Icons.account_circle_rounded,
                            color: Colors.white,
                          ),
                          icon: const Icon(
                            Icons.account_circle_rounded,
                            color: AppStyles.blueDark,
                          ),
                          title: 'Tài Khoản',
                          textStyle: TextStyle(
                              fontSize: 10.sp, fontWeight: FontWeight.bold),
                          activeColorSecondary: AppStyles.blueDark,
                          activeColorPrimary: AppStyles.white,
                          inactiveColorPrimary: AppStyles.white,
                        ),
                      ],
                hideNavigationBar: false,
                navBarHeight: 50.sp,
                bottomScreenMargin: 5.sp,
                margin: const EdgeInsets.all(0),
                padding: NavBarPadding.symmetric(horizontal: 5.sp),
                onItemSelected: (int index) async {
                  Get.focusScope!.unfocus();
                  _controller.persistentTabController.index = index;
                  _controller.changeTabIndex(index,
                      notificationController: _notificationController,
                      myCourseController: _myCourseController,
                      homeController: _homeController,
                      courseSearchController: _allCourseController);
                },
                confineInSafeArea: true,
                backgroundColor: AppStyles.blueDark,
                handleAndroidBackButtonPress: true,
                resizeToAvoidBottomInset: false,
                stateManagement: true,
                hideNavigationBarWhenKeyboardShows: true,
                popAllScreensOnTapOfSelectedTab: true,
                popActionScreens: PopActionScreensType.all,
                itemAnimationProperties: const ItemAnimationProperties(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                ),
                screenTransitionAnimation: const ScreenTransitionAnimation(
                  animateTabTransition: false,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                ),
                navBarStyle: NavBarStyle.style10,
              ),
            ),
          ),
        );
      },
      maximumSize: const Size(475.0, 812.0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey,
    );
  }
}
