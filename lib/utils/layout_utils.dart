import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/controllers/notification_controller.dart';
import 'package:stna_lms_flutter/models/tag_model.dart';

class LayoutUtils {
  static List<BoxShadow> boxShadows({double elevation = 10.0}) {
    return [
      BoxShadow(
          color: Colors.grey.shade400,
          spreadRadius: 2.0,
          blurRadius: elevation,
          offset: const Offset(3.0, 3.0)),
      BoxShadow(
          color: Colors.grey.shade400,
          spreadRadius: 2.0,
          blurRadius: elevation / 2.0,
          offset: const Offset(3.0, 3.0)),
      BoxShadow(
          color: Get.theme.cardColor,
          spreadRadius: 2.0,
          blurRadius: elevation,
          offset: const Offset(-3.0, -3.0)),
      BoxShadow(
          color: Get.theme.cardColor,
          spreadRadius: 2.0,
          blurRadius: elevation / 2,
          offset: const Offset(-3.0, -3.0)),
    ];
  }

  static LinearGradient linearGradient(List<Color> colors) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
    );
  }

  static RadialGradient radialGradient(List<Color> colors) {
    return RadialGradient(
      radius: 5,
      colors: colors,
    );
  }

  static Gradient gradientGreyLight =
      radialGradient([Colors.grey.shade300, Colors.grey.shade200]);

  static Gradient gradientWhite = radialGradient([Colors.white, Colors.white]);

  static Gradient gradientGrey =
      radialGradient([Colors.grey.shade500, Colors.grey.shade400]);

  static Gradient gradientBlueLight = radialGradient(
      [AppStyles.gradientBlueLight2, AppStyles.gradientBlueLight1]);

  static Gradient gradientBlueDark =
      radialGradient([AppStyles.blueLight, AppStyles.blueDark]);

  static Gradient gradientGreen =
      radialGradient([AppStyles.greenLight, AppStyles.green]);

  static BoxDecoration boxDecorationNotifcation(
      {double elevation = 10.0, Color color = Colors.grey}) {
    List<BoxShadow> boxShadows = LayoutUtils.boxShadows(elevation: elevation);

    var decoration = BoxDecoration(
        color: Get.theme.cardColor,
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
            stops: const [0.02, 0.02],
            colors: [color.withOpacity(0.6), Colors.white]),
        boxShadow: boxShadows,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)));

    return decoration;
  }

  static BoxDecoration boxDecoration(
      {double? elevation, bool hasColor = false}) {
    elevation ??= 10.sp;

    List<BoxShadow> boxShadows =
        hasColor ? [] : LayoutUtils.boxShadows(elevation: elevation);

    var decoration = BoxDecoration(
      color: Get.theme.cardColor,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(5.sp),
      boxShadow: boxShadows,
    );

    if (!hasColor) {
      decoration.copyWith(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          Colors.grey.shade100,
        ],
      ));
    }

    return decoration;
  }

  static Widget formInputLabel(BuildContext context, String label) {
    var width = MediaQuery.of(context).size.width;
    var widthPercent = width / 100;

    return Container(
        padding: EdgeInsets.only(
            left: widthPercent * 10,
            right: widthPercent * 10,
            top: 10.sp,
            bottom: 10.sp),
        width: MediaQuery.of(context).size.width,
        child: Text(
          label,
          style: AppTextThemes.heading7().copyWith(color: AppStyles.secondary),
        ));
  }

  static Widget formInputValueLabel(
      BuildContext context, String text, Function onPressed) {
    var width = MediaQuery.of(context).size.width;
    var widthPercent = width / 100;

    return Container(
      padding:
          EdgeInsets.only(left: widthPercent * 10, right: widthPercent * 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTextThemes.heading7(),
            ),
            IconButton(
                onPressed: () {
                  onPressed();
                },
                icon: const Icon(Icons.content_copy_rounded))
          ]),
    );
  }

  static Widget formInput(BuildContext context,
      TextEditingController controller, String hintText, IconData? icon,
      {bool obscureText = false,
      bool isPassword = false,
      Function()? onSuffixIconPressed,
      bool readOnly = false,
      Widget? suffixIcon,
      bool required = false,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String)? validator}) {
    var width = MediaQuery.of(context).size.width;
    var widthPercent = width / 100;

    if (isPassword) {
      suffixIcon = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (onSuffixIconPressed != null) {
            onSuffixIconPressed();
          }
        },
        child: Icon(
          obscureText
              ? Icons.remove_red_eye_rounded
              : Icons.remove_red_eye_outlined,
          size: 18.sp,
          color: const Color.fromRGBO(142, 153, 183, 0.5),
        ),
      );
    }

    return Container(
      padding:
          EdgeInsets.only(left: widthPercent * 10, right: widthPercent * 10),
      child: TextFormField(
        readOnly: readOnly,
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 14.sp, color: AppStyles.primary),
        validator: (value) {
          if (required == true) {
            if (value == null || value.isEmpty) {
              return '$hintText không được bỏ trống';
            }
          }

          if (validator != null) {
            return validator(value!);
          }

          return null;
        },
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.only(left: 10.sp, top: 10.sp, bottom: 10.sp),
          filled: true,
          fillColor: Colors.white,
          errorStyle: const TextStyle(height: 1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
                color: Color.fromRGBO(142, 153, 183, 0.4), width: 1.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14.sp, color: AppStyles.secondary),
          suffixIcon: suffixIcon ??
              Icon(icon ?? Icons.hourglass_empty_rounded,
                  size: 20.sp, color: AppStyles.secondary),
        ),
      ),
    );
  }

  static Widget button(
      {required String text,
      required Function onPressed,
      Gradient? gradient,
      EdgeInsets? margin,
      bool readonly = false}) {
    BoxDecoration boxDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: readonly ? Colors.grey.shade300 : Colors.white,
        gradient: gradient ?? gradientBlueDark);

    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        margin: margin ?? EdgeInsets.only(top: 10.sp),
        height: 35.sp,
        width: Get.width - 60.sp,
        decoration: boxDecoration,
        child: Text(
          text,
          style: AppTextThemes.heading7().copyWith(
            color: readonly ? Colors.grey.shade400 : Colors.white,
          ),
        ),
      ),
      onTap: () {
        readonly ? null : onPressed();
      },
    );
  }

  static Widget buttonIcon(BuildContext context,
      {required IconData icon,
      required Function onPressed,
      Color? color,
      double? size,
      Gradient? gradient,
      EdgeInsets? margin,
      double? width,
      bool readonly = false}) {
    size ??= 32.sp;

    var defaultWidth = (MediaQuery.of(context).size.width / 100) * 80;

    BoxDecoration boxDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(5.sp),
        color: readonly ? Colors.grey.shade300 : Colors.white,
        gradient: gradient ?? gradientBlueDark);

    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        margin: margin ??
            const EdgeInsets.only(
              top: 0,
              // bottom: 20,
            ),
        height: 30.sp,
        width: width ?? defaultWidth,
        decoration: boxDecoration,
        child: Icon(
          icon,
          size: size,
          color: color ?? AppStyles.blueDark,
        ),
      ),
      onTap: () {
        readonly ? null : onPressed();
      },
    );
  }

  static Widget floatingButton(BuildContext context,
      {required String text, required Function onPressed, Color? color}) {
    var _wp = Get.width / 100;

    return SizedBox(
        width: _wp * 80,
        height: 30.sp,
        child: ElevatedButton(
          child: Text(
            text,
            style: AppTextThemes.heading6().copyWith(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: color ?? AppStyles.blueLight,
          ),
          onPressed: () {
            onPressed();
          },
        ));
  }

  static Widget alertDialogConfirmButton(
      {required String text, Color? bgColor, required Function onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: bgColor ?? AppStyles.blueDark),
      child: Text(
        text,
        style: AppTextThemes.heading6().copyWith(color: Colors.white),
      ),
      onPressed: () async {
        onPressed();
      },
    );
  }

  static Widget alertDialogCancelButton(
      {required String text, required Function onPressed}) {
    return TextButton(
      child: Text(
        text,
        style: AppTextThemes.heading6().copyWith(color: AppStyles.blueDark),
      ),
      onPressed: () {
        onPressed();
      },
    );
  }

  static Widget tags(List<TagModel> tags) {
    var tagList = [];

    for (var element in tags) {
      {
        if (tagList.length < 4) // max length
        {
          tagList.add(Container(
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(right: 5.0),
            decoration: LayoutUtils.boxDecoration(),
            child: Row(children: [
              Text(
                '#',
                style:
                    AppTextThemes.label3().copyWith(color: AppStyles.blueLight),
              ),
              const SizedBox(
                width: 7.0,
              ),
              Text(
                element.name,
                style: AppTextThemes.heading7()
                    .copyWith(color: AppStyles.blueDark),
              )
            ]),
          ));
        }
      }
    }

    return Row(children: [...tagList]);
  }

  static Widget networkImage(String url,
      {BoxFit fit = BoxFit.cover,
      required double height,
      required double width}) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Image.asset(
          'images/layout/sorry.png',
          height: height,
          width: width,
          fit: BoxFit.contain,
        );
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
            width: width,
            height: height,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ));
      },
    );
  }

  static Widget appbarAction(
      {required IconData icon,
      Color? color,
      Function()? onTap,
      NotificationController? controller}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15.sp, top: 15.sp),
            child: FaIcon(
              icon,
              color: AppStyles.primary,
              size: 14.sp,
            ),
          ),
          controller != null
              ? Obx(() {
                  return controller.countIsRead.value > 0
                      ? Positioned(
                          left: 5.0,
                          top: 5.0,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: FittedBox(
                              child: Text(
                                controller.countIsRead.value.toString(),
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ),
                        )
                      : Container();
                })
              : Container(),
        ],
      ),
    );
  }

  static Widget fadeInImage(
      {required BoxFit fit,
      double? height,
      double? width,
      required ImageProvider<Object> image,
      String? error,
      String? placeholder}) {
    return FadeInImage(
      fit: fit,
      height: height,
      width: width,
      image: image,
      placeholder:
          AssetImage(placeholder ?? 'images/placeholders/image-loading.png'),
      // placeholderFit: BoxFit.none,
      imageErrorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Image.asset(
          error ?? 'images/layout/sorry.png',
          height: height,
          width: width,
          fit: BoxFit.contain,
        );
      },
    );
  }

  static Widget version({String? appName, String? appVersion}) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(top: 5.sp),
      padding: EdgeInsets.all(5.sp),
      child: Text(
        '$appName v$appVersion',
        style: AppTextThemes.label4(),
      ),
    );
  }
}
