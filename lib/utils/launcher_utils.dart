import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger_console/logger_console.dart';
import 'package:stna_lms_flutter/utils/alert_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appcheck/appcheck.dart';

const String zaloStoreAndroid =
    'http://play.google.com/store/apps/details?id=com.zing.zalo';
const String zaloStoreIos = 'http://itunes.apple.com/us/app/id579523206';
const zaloIos = 'itms-apps://itunes.apple.com/us/app/id579523206';
const zaloAndroid = 'com.zing.zalo';

class LauncherUtils {
  static void launchZalo(String? zaloID) async {
    Console.log('launchZalo', zaloID);
    final Uri _url = Uri.parse('https://zalo.me/g/${zaloID ?? ''}');
    final Uri _url2 = Uri.parse('https://zalo.me/${zaloID ?? ''}');

    if (!kIsWeb && Platform.isAndroid) {
      late bool appEnable;
      try {
        appEnable = await AppCheck.isAppEnabled(zaloAndroid);
      } catch (error) {
        appEnable = false;
      }

      if (appEnable) {
        if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
          AlertUtils.error(
              'Không thể liên lạc qua Zalo lúc này. Vui lòng thử lại');
        }
      } else {
        await launchUrl(Uri.parse(zaloStoreAndroid),
            mode: LaunchMode.externalApplication);
      }

      return;
    }

    if (!await canLaunchUrl(Uri.parse(zaloIos))) {
      await launchUrl(Uri.parse(zaloStoreIos),
          mode: LaunchMode.externalApplication);
    } else {
      if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
        AlertUtils.error(
            'Không thể liên lạc qua Zalo lúc này. Vui lòng thử lại');
      }
    }
  }

  static void launchFacebookMessenger(String? messengerID) async {
    final Uri _url = Uri.parse('https://m.me/${messengerID ?? ''}');
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      AlertUtils.error(
          'Không thể liên lạc qua Facebook Messenger lúc này. Vui lòng thử lại');
    }
  }

  static void launchBrowserUrl(String? url) async {
    final Uri _url = Uri.parse(url ?? '');
    if (!await launchUrl(_url)) {
      AlertUtils.error('Không thể mở đường dẫn này. Vui lòng thử lại');
    }
  }
}
