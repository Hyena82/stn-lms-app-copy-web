// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:stna_lms_flutter/controllers/my_resource_controller.dart';
// Project imports:
import 'package:stna_lms_flutter/helpers/loading_helper.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:stna_lms_flutter/widgets/my_resource_page/my_course_tab_widget.dart';
import 'package:stna_lms_flutter/widgets/my_resource_page/my_quiz_tab_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MyResourcePage extends StatefulWidget {
  const MyResourcePage({Key? key}) : super(key: key);

  @override
  _MyResourcePageState createState() => _MyResourcePageState();
}

class _MyResourcePageState extends State<MyResourcePage> {
  final MyResourceController _tabx = Get.put(MyResourceController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: defaultLoadingWidget,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBarWidget(
            title: "Đã Đăng Ký",
            bottom: TabBar(
              controller: _tabx.tabController,
              tabs: _tabx.myTabs,
              indicator: Get.theme.tabBarTheme.indicator,
              automaticIndicatorColorAdjustment: true,
              isScrollable: false,
            ),
          ),
          body: TabBarView(
            controller: _tabx.tabController,
            physics: const BouncingScrollPhysics(),
            children: const <Widget>[
              MyCourseTabWidget(),
              MyQuizTabWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
