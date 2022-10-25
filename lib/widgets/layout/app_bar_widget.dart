// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// Package imports:

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
// Project imports:
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/controllers/notification_controller.dart';
import 'package:stna_lms_flutter/pages/course_search_page.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/pages/notification_page.dart';
import 'package:stna_lms_flutter/utils/launcher_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final bool showSearch;
  final bool goToSearch;
  final bool showBack;
  final bool showFilterToggle;
  final bool showEndDrawer;
  final bool showLogo;
  final double? height;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final Function(String)? searching;
  final bool hideNotificationAction;
  final String? hintTextSearch;
  const AppBarWidget(
      {Key? key,
      this.showSearch = false,
      this.goToSearch = false,
      this.hintTextSearch,
      this.searching,
      this.showBack = false,
      this.showFilterToggle = false,
      this.showEndDrawer = false,
      this.showLogo = true,
      this.actions,
      this.leading,
      this.title,
      this.height,
      this.hideNotificationAction = false,
      this.bottom})
      : super(key: key);

  @override
  Size get preferredSize {
    double? preferredHeight = height;

    if (height == null) {
      if (showSearch && bottom != null) {
        preferredHeight = 145.sp;
      } else if (showSearch) {
        preferredHeight = 100.sp;
      } else if (bottom != null) {
        preferredHeight = 95.sp;
      } else {
        if (title != null) {
          preferredHeight = 45.sp;
        } else {
          preferredHeight = 45.sp;
        }
      }
    }

    return Size(Get.width, preferredHeight!);
  }

  get toolbarHeight {
    double? toolbarHeight = 45.sp;

    if (height == null) {
      if (showSearch && bottom != null) {
        toolbarHeight = 45.sp;
      } else if (showSearch || bottom != null) {
        toolbarHeight = 45.sp;
      }
    }

    return toolbarHeight;
  }

  get searchInputMargin {
    double? marginTop = 50.sp;

    if (showSearch && bottom != null) {
      marginTop = 80.sp;
    } else if (showSearch || bottom != null) {
      marginTop = 45.sp;
    }

    return marginTop;
  }

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  final HomeController homeController = Get.put(HomeController());
  final DashboardController controller = Get.put(DashboardController());
  final NotificationController notificationController =
      Get.put(NotificationController());

  List<Widget> actions = [];

  @override
  void initState() {
    if (widget.actions != null) {
      actions = [..._getDefaultActions(), ...?widget.actions];
    } else {
      actions = [..._getDefaultActions()];
    }

    super.initState();
  }

  List<Widget> _getDefaultActions() {
    List<Widget> defaultActions = [];
    // notificationController.getNotifications();
    if (!widget.hideNotificationAction) {
      defaultActions.add(LayoutUtils.appbarAction(
        icon: FontAwesomeIcons.bell,
        onTap: () async {
          await notificationController.getNotifications();

          Get.to(() => const NotificationPage());
        },
        controller: notificationController,
      ));

      defaultActions.add(SpeedDial(
        dialRoot: (ctx, open, toggleChildren) {
          return LayoutUtils.appbarAction(
            icon: FontAwesomeIcons.headset,
            onTap: toggleChildren,
          );
        },
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: AppStyles.blueDark,
        direction: SpeedDialDirection.down,
        spaceBetweenChildren: 5.sp,
        spacing: 5.sp,
        elevation: 0,
        childPadding: EdgeInsets.only(right: 30.sp),
        childrenButtonSize: Size(80.sp, 80.sp),
        children: [
          SpeedDialChild(
              onTap: () {
                LauncherUtils.launchZalo(
                    controller.systemInformation.value?.zaloID);
              },
              child: LayoutUtils.fadeInImage(
                  fit: BoxFit.cover,
                  height: 38.sp,
                  image: const AssetImage('images/layout/social/zalo.png')),
              backgroundColor: AppStyles.blueLighter,
              labelBackgroundColor: AppStyles.blueLighter,
              labelStyle: AppTextThemes.heading7(),
              label: 'Zalo'),
          SpeedDialChild(
              onTap: () {
                LauncherUtils.launchFacebookMessenger(
                    controller.systemInformation.value?.facebookID);
              },
              child: LayoutUtils.fadeInImage(
                  fit: BoxFit.cover,
                  height: 38.sp,
                  image:
                      const AssetImage('images/layout/social/messenger.png')),
              backgroundColor: AppStyles.blueLighter,
              labelBackgroundColor: AppStyles.blueLighter,
              labelStyle: AppTextThemes.heading7(),
              label: 'Facebook Messenger')
        ],
      ));
    }

    return defaultActions;
  }

  Widget? _getLeading() {
    if (widget.leading != null) {
      return widget.leading;
    }

    if (widget.showBack) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: AppStyles.primary,
          size: 14.sp,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: widget.toolbarHeight,
      backgroundColor: AppStyles.blueLightest,
      centerTitle: true,
      elevation: (0.2).sp,
      automaticallyImplyLeading: true,
      actions: actions,
      title: widget.title != null
          ? Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                widget.title!,
                style: AppTextThemes.heading6(),
              ),
            )
          : widget.showLogo
              ? Container(
                  alignment: Alignment.center,
                  width: 30.sp,
                  child: Image.asset(
                    'images/$appLogo',
                  ),
                )
              : Container(),
      leading: _getLeading(),
      bottom: widget.bottom,
      flexibleSpace: Container(
          child: widget.showSearch
              ? Container(
                  margin: EdgeInsets.only(top: widget.searchInputMargin),
                  child: GestureDetector(
                    child: Container(
                      height: 40.sp,
                      margin:
                          EdgeInsets.symmetric(horizontal: 15.sp, vertical: 0),
                      child: TextField(
                        enabled: widget.goToSearch ? false : true,
                        onChanged: widget.searching,
                        autofocus: false,
                        autocorrect: false,
                        style: TextStyle(fontSize: 15.sp),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(
                              left: 40.sp, right: 20.sp, top: 5.sp),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.sp),
                            borderSide: BorderSide(
                                color: const Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.sp),
                          ),
                          hintText: widget.hintTextSearch ??
                              "Nhập từ khóa để tìm khóa học",
                          hintStyle: AppTextThemes.label4(),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 16.sp,
                            color: AppStyles.primary,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (widget.goToSearch) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CourseSearchPage(),
                            ));
                      }
                    },
                  ),
                )
              : Container()),
    );
  }
}
