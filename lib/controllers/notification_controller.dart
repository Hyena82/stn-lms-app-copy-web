import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stna_lms_flutter/configs/app_config.dart';
import 'package:stna_lms_flutter/models/notification_model.dart';
import 'package:stna_lms_flutter/services/api_service.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  GetStorage storage = GetStorage();

  // notification detail page
  RxInt userNotificationId = 0.obs;
  RxBool isNotificationDetailLoading = false.obs;
  Rx<NotificationModel> notificationDetail = NotificationModel().obs;
  RxInt countIsRead = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    await getNotifications();
  }

  Future<bool> getNotification() async {
    String? token = storage.read(jwtTokenKey);
    try {
      isNotificationDetailLoading.value = true;
      var notification =
          await APIService.fetchNotification(token, userNotificationId.value);
      if (notification == null) {
        notificationDetail.value = NotificationModel();
        return false;
      }

      notificationDetail.value = notification;
      return true;
    } finally {
      isNotificationDetailLoading.value = false;
    }
  }

  Future<void> markNotificationRead(int id) async {
    try {
      String? token = storage.read(jwtTokenKey);
      await APIService.postMarkNotificationRead(token, id);
      await getNotifications();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      String? token = storage.read(jwtTokenKey);
      await APIService.postDeleteAllNotifications(token);
      await getNotifications();
    } finally {}
  }

  Future<void> getNotifications() async {
    try {
      isLoading.value = true;
      notificationList.value = [];

      String? token = storage.read(jwtTokenKey);
      var result = await APIService.fetchNotifications(token);
      if (result != null) {
        notificationList.assignAll(result);

        countIsRead.value =
            notificationList.where((element) => element.isRead == false).length;
      } else {
        notificationList.value = [];
      }
      update(['notification_list']);
    } finally {
      isLoading.value = false;
    }
  }
}
