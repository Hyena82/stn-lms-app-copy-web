// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Project imports:
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class AppThemes {
  static final light = ThemeData.light().copyWith(
    primaryColor: AppStyles.blueDark,
    secondaryHeaderColor: AppStyles.blueDark,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    unselectedWidgetColor: AppStyles.secondary,
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0.5)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(AppStyles.blueDark),
        backgroundColor: MaterialStateProperty.all<Color>(AppStyles.blueLight),
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppStyles.primary,
      labelPadding: EdgeInsets.only(bottom: 5.sp),
      labelStyle: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 11.sp),
      indicator: MaterialIndicator(
        height: 5.sp,
        topLeftRadius: 8.sp,
        topRightRadius: 8.sp,
        bottomLeftRadius: 8.sp,
        bottomRightRadius: 8.sp,
        horizontalPadding: 50.sp,
        tabPosition: TabPosition.bottom,
        color: AppStyles.blueDark,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xff6A779A),
    ),
    shadowColor: Colors.grey.shade400,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
    cardTheme: const CardTheme(color: Colors.white),
    textTheme: TextTheme(
      bodyText1: TextStyle(fontSize: 19.sp, height: 2),
      headline1:
          TextStyle(fontSize: 73.sp, fontWeight: FontWeight.bold, height: 1.5),
      headline6:
          TextStyle(fontSize: 37.sp, fontStyle: FontStyle.italic, height: 1.5),
      bodyText2: TextStyle(fontSize: 15.sp, height: 1.5),
      subtitle2: TextStyle(fontSize: 15.sp, color: Colors.black, height: 1.5),
      subtitle1: TextStyle(fontSize: 15.sp, color: Colors.black, height: 1.5),
      button: TextStyle(fontSize: 15.sp, color: Colors.black, height: 1.5),
    ),
    // .apply(fontFamily: 'SourceSansPro'),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final dark = ThemeData.dark().copyWith(
    primaryColor: AppStyles.blueLight,
    unselectedWidgetColor: Colors.black87,
    scaffoldBackgroundColor: Colors.black54,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0.5)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(AppStyles.blueDark),
        backgroundColor: MaterialStateProperty.all<Color>(AppStyles.blueDark),
      ),
    ),
    shadowColor: Colors.transparent,
    cardTheme: const CardTheme(color: Colors.black45),
    tabBarTheme: const TabBarTheme(
      indicator: BoxDecoration(
        color: AppStyles.blueDark,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xff8E99B7),
    ),
    textTheme: TextTheme(
      subtitle2: TextStyle(
        fontSize: 15.sp,
      ),
      subtitle1: TextStyle(
        fontSize: 17.sp,
        color: Colors.white,
      ),
      button: TextStyle(
        fontSize: 15.sp,
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        fontSize: 19.sp,
        color: Colors.white,
      ),
      headline1: TextStyle(
        fontSize: 73.sp,
        fontWeight: FontWeight.bold,
      ),
      headline6: TextStyle(
        fontSize: 37.sp,
        fontStyle: FontStyle.italic,
      ),
      bodyText2: TextStyle(
        fontSize: 15.sp,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
