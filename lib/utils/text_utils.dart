// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/helpers/date_helper.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:recase/recase.dart';

bool isEmpty(String? text) {
  if (text == null) return true;

  return text.isEmpty;
}

// ignore: non_constant_identifier_names
Widget textHeading(String txt) {
  return Text(
    txt,
    style: AppTextThemes.heading6().copyWith(
      color: AppStyles.blueDark,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget seeAllText() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text('Xem tất cả', style: AppTextThemes.label5()),
      Icon(
        Icons.arrow_right_rounded,
        size: 35.sp,
        color: AppStyles.secondary,
      ),
    ],
  );
}

Widget courseTitle(String txt) {
  return Text(
    txt,
    maxLines: 3,
    textAlign: TextAlign.left,
    overflow: TextOverflow.ellipsis,
    style: AppTextThemes.heading7().copyWith(
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget courseDescription(String? txt) {
  return Text(txt ?? 'N/A',
      maxLines: 3,
      style: AppTextThemes.heading7().copyWith(
          fontWeight: FontWeight.w500, color: const Color(0xff8E99B7)));
}

Widget courseAuthorName(String? txt) {
  return Text(txt ?? 'N/A',
      style: AppTextThemes.heading7().copyWith(
          fontWeight: FontWeight.w500, color: const Color(0xff8E99B7)));
}

Widget courseUpdatedDate(DateTime? date) {
  return date == null
      ? SizedBox(height: 10.sp)
      : Text('Cập nhật ${DateHelper.formatDateOnly(date)}',
          style: AppTextThemes.heading8().copyWith(
              fontWeight: FontWeight.w500, color: const Color(0xff8E99B7)));
}

Widget courseExpiredDate(DateTime? expiredDate, double price) {
  final date = expiredDate ?? DateTime.now();
  final now = DateTime.now();
  final differenceInDay = date.difference(now).inDays;

  return (expiredDate == null || differenceInDay >= 7)
      ? SizedBox(height: 10.sp)
      : Text(
          'Hết hạn ${DateHelper.formatDateOnly(expiredDate)}',
          style: AppTextThemes.heading8().copyWith(
              fontWeight: FontWeight.w500, color: const Color(0xff8E99B7)),
          // maxLines: 1,
          // overflow: TextOverflow.ellipsis,
        );
}

Widget userNameTitleText(String? txt) {
  return Text(txt ?? 'N/A',
      style: AppTextThemes.heading8().copyWith(
        color: Get.theme.secondaryHeaderColor,
      ));
}

Widget courseTitleText(String? text) {
  return Text(text ?? 'N/A',
      style: AppTextThemes.heading5().copyWith(color: AppStyles.primary));
}

Widget courseNameText(String? txt, [Color? color]) {
  return Text(
    txt ?? 'N/A',
    maxLines: 2,
    style: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppStyles.primary,
    ),
    textAlign: TextAlign.left,
  );
}

Widget courseAuthorNameText(String? txt, [Color? color]) {
  return Text(txt ?? 'N/A',
      maxLines: 3,
      style: AppTextThemes.label4().copyWith(color: AppStyles.blueDark));
}

Widget courseStructure(String? txt) {
  return Text(
    txt ?? 'N/A',
    style: AppTextThemes.label4().copyWith(color: AppStyles.primary),
  );
}

String durationString(int source) {
  var duration = source.abs();

  var hour = (duration / 3600).floor();
  var minute = ((duration - (hour * 3600)) / 60).floor();
  var second = duration - (hour * 3600) - (minute * 60);

  var durations = [];
  if (hour > 0) durations.add(hour);
  durations.add(minute < 10 ? '0$minute' : minute);
  durations.add(second < 10 ? '0$second' : second);

  return durations.join(':');
}

Widget durationNumberText(double duration, [bool fullText = false]) {
  String text;

  if (duration < 0) {
    text = '00:00';
  } else {
    int minutes = (duration / 60).floor();
    int seconds = (duration % 60).floor();

    String minuteText = minutes < 10 ? '0$minutes' : '$minutes';
    String secondText = seconds < 10 ? '0$seconds' : '$seconds';

    text = '$minuteText:$secondText';
  }

  return Text(
    text,
    style: AppTextThemes.heading7(),
  );
}

Widget getPriceText(double price) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text('Xem Ngay',
          textAlign: TextAlign.center,
          style: AppTextThemes.heading7().copyWith(
              color: AppStyles.blueLight, fontWeight: FontWeight.bold)),
      Icon(
        Icons.keyboard_arrow_right_rounded,
        size: 22.sp,
        color: AppStyles.blueLight,
      )
    ],
  );
}

Widget getPriceTag(bool isEnrolled, double price) {
  // define types
  var type = 'free';
  if (isEnrolled) {
    type = 'enrolled';
  } else {
    if (price > 0) {
      type = 'price';
    }
  }

  var bgColor = LayoutUtils.gradientGrey;
  var color = Colors.white;
  var text = type;
  var padding = 5.sp;

  switch (type) {
    case 'enrolled':
      text = 'Đã Đăng Ký';
      bgColor = LayoutUtils.gradientBlueDark;
      break;
    case 'free':
      text = 'Miễn Phí';
      break;
    default:
      padding = 0.0;
      bgColor = LayoutUtils.gradientWhite;
      break;
  }

  var textWidget = type == 'price'
      ? getPriceText(price)
      : Text(text,
          textAlign: TextAlign.center,
          style: AppTextThemes.heading7().copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ));

  var boxDecoration =
      BoxDecoration(borderRadius: BorderRadius.circular(5), gradient: bgColor);

  return Container(
      alignment: Alignment.center,
      width: double.infinity,
      decoration: boxDecoration,
      padding: EdgeInsets.all(padding),
      child: textWidget);
}

Widget questionText(String? text, int index) {
  String questionNo = 'Câu ${index + 1}';
  String txt = text == null ? '' : ': $text';
  return Text(
    '$questionNo$txt',
    textAlign: TextAlign.center,
    style: AppTextThemes.heading5()
        .copyWith(color: AppStyles.primary, fontWeight: FontWeight.bold),
  );
}

Widget markdown(String? content) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.sp),
      child: MarkdownBody(
        data: '''$content''',
        styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
            textTheme: TextTheme(
                bodyText2: AppTextThemes.label4()
                    .copyWith(color: AppStyles.primary)))),
      ));
}

Widget longTextSection(String? title, String? content) {
  var list = <Widget>[];
  var _hp = Get.height / 100;

  if (content == null) {
    return Container();
  }

  if (title != null) {
    list.add(Text(
      title,
      style: AppTextThemes.heading7().copyWith(color: AppStyles.blueDark),
    ));
    list.add(SizedBox(
      height: _hp,
    ));
  }

  list.add(markdown(content));

  return Container(
    padding: EdgeInsets.all(15.sp),
    // decoration: LayoutUtils.boxDecoration(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...list],
    ),
  );
}

String? convertLinkType(String? link) {
  var original = (link ?? '').trim().toLowerCase();
  var encoded = ReCase(original).constantCase;

  switch (encoded) {
    case 'TIỆN_ÍCH':
      return 'utilities';
    case 'TÌM_KHÓA_HỌC':
      return 'all_course';
    case 'TRANG_CHỦ':
      return 'home';
    case 'KHOÁ_HỌC_CỦA_BẠN':
      return 'my_resources';
    case 'TÀI_KHOẢN':
      return 'account';
    case 'KHOÁ_HỌC':
      return 'course';
    default:
      return null;
  }
}
