import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/notification_controller.dart';
import 'package:stna_lms_flutter/helpers/date_helper.dart';
import 'package:stna_lms_flutter/helpers/loading_helper.dart';
import 'package:stna_lms_flutter/helpers/text_helper.dart';
import 'package:stna_lms_flutter/pages/notification_detail_page.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _wp = Get.width / 100;
  final _hp = Get.height / 100;

  final NotificationController _controller = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
  }

  Future<void> refresh() async {
    _controller.notificationList.value = [];
    await _controller.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    var notifications = _controller.notificationList;

    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: defaultLoadingWidget,
        child: SafeArea(
            child: Scaffold(
          appBar: AppBarWidget(
            title: "Thông Báo",
            showBack: true,
            hideNotificationAction: true,
            actions: [
              LayoutUtils.appbarAction(
                  icon: FontAwesomeIcons.trashAlt,
                  color: AppStyles.red,
                  onTap: () {
                    Get.dialog(
                      AlertDialog(
                        title: Text(
                          'Xóa tất cả thông báo ?',
                          style: AppTextThemes.heading6(),
                        ),
                        content: const Text(
                            'Sau khi chọn xóa tất cả, bạn sẽ không thể hoàn tác.'),
                        actions: <Widget>[
                          LayoutUtils.alertDialogCancelButton(
                              text: 'Hủy',
                              onPressed: () {
                                Get.back();
                              }),
                          LayoutUtils.alertDialogConfirmButton(
                              text: 'Xóa tất cả',
                              bgColor: AppStyles.redDark,
                              onPressed: () async {
                                Get.back();
                                await _controller.deleteAllNotifications();
                              }),
                        ],
                      ),
                    );
                  })
            ],
          ),
          body: Column(children: [
            Expanded(
                child: RefreshIndicator(
                    onRefresh: refresh,
                    child: Obx(() {
                      return _controller.isLoading.value
                          ? Center(
                              child: activityIndicator(),
                            )
                          : notifications.isEmpty
                              ? ListView(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.sp, vertical: _hp * 20),
                                  shrinkWrap: true,
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Chưa có thông báo mới !!!',
                                            style: AppTextThemes.heading1(),
                                          ),
                                          Container(
                                            width: Get.width,
                                            height: _hp * 40,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0))),
                                            child: Image.asset(
                                                'images/layout/notifications.png'),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.fromLTRB(
                                      20.sp, 20.sp, 15.sp, 15.sp),
                                  shrinkWrap: true,
                                  itemCount: notifications.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var notification = notifications[index];
                                    var notificationLink =
                                        notification.link ?? 'none';
                                    // var notificationLink = 'none';
                                    var color = AppStyles.grey;
                                    var icon = FontAwesomeIcons.ellipsisH;

                                    switch (notificationLink) {
                                      case 'all_course':
                                        icon = FontAwesomeIcons.bookReader;
                                        color = AppStyles.colorWheels[0];
                                        break;
                                      case 'utilities':
                                        icon = FontAwesomeIcons.toolbox;
                                        color = AppStyles.colorWheels[1];
                                        break;
                                      case 'home':
                                        icon = FontAwesomeIcons.home;
                                        color = AppStyles.colorWheels[2];
                                        break;
                                      case 'my_resources':
                                        icon = FontAwesomeIcons.bookmark;
                                        color = AppStyles.colorWheels[3];
                                        break;
                                      case 'account':
                                        icon = FontAwesomeIcons.user;
                                        color = AppStyles.colorWheels[4];
                                        break;
                                      default:
                                        break;
                                    }

                                    return GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.all(5.sp),
                                        decoration: LayoutUtils
                                            .boxDecorationNotifcation(
                                                color: color),
                                        child: IntrinsicHeight(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                _wp * 3),
                                                    padding:
                                                        EdgeInsets.all(10.sp),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: color
                                                            .withOpacity(0.2)),
                                                    child: FaIcon(
                                                      icon,
                                                      color: color,
                                                      size: 16.sp,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 5.sp,
                                                        ),
                                                        Text(
                                                            DateHelper
                                                                .formatDateTime(
                                                                    notification
                                                                        .createdAt),
                                                            style: TextStyle(
                                                                fontSize: 13.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: const Color(
                                                                    0xff8E99B7))),
                                                        SizedBox(
                                                          height: 5.sp,
                                                        ),
                                                        Text(
                                                          TextHelper.lowerCase(
                                                              notification
                                                                  .title),
                                                          maxLines: 2,
                                                          style: AppTextThemes
                                                              .heading7(),
                                                        ),
                                                        SizedBox(
                                                          height: 5.sp,
                                                        ),
                                                        Text(
                                                            TextHelper.lowerCase(
                                                                notification
                                                                    .message),
                                                            style: AppTextThemes
                                                                    .heading7()
                                                                .copyWith(
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            )),
                                                        SizedBox(
                                                          height: 10.sp,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  !notification.isRead
                                                      ? Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: AvatarGlow(
                                                                endRadius:
                                                                    13.sp,
                                                                glowColor: Colors
                                                                    .yellowAccent,
                                                                child: Icon(
                                                                  Icons
                                                                      .circle_rounded,
                                                                  color: AppStyles
                                                                      .yellow,
                                                                  size: 12.sp,
                                                                )),
                                                          ),
                                                        )
                                                      : Container(
                                                          width: _wp * 4,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                      ),
                                      onTap: () async {
                                        context.loaderOverlay.show();

                                        _controller.userNotificationId.value =
                                            notification.id ?? 0;
                                        var success =
                                            await _controller.getNotification();

                                        context.loaderOverlay.hide();

                                        if (success) {
                                          Get.to(
                                              () => NotificationDetailPage());
                                        } else {
                                          AlertUtils.error();
                                        }

                                        // mark as read
                                        if (!notification.isRead) {
                                          _controller.markNotificationRead(
                                              notification.id ?? 0);
                                        }
                                      },
                                    );
                                  });
                    }))),
          ]),
        )));
  }
}
