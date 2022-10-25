// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:stna_lms_flutter/controllers/utilities_controller.dart';
// Project imports:
import 'package:stna_lms_flutter/pages/utilities/dictionary_page.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/helpers/loading_helper.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';
import 'package:stna_lms_flutter/widgets/utilities/dictionary/dictionary_card_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DictionaryListPage extends StatefulWidget {
  const DictionaryListPage({Key? key}) : super(key: key);

  @override
  _DictionaryListPageState createState() => _DictionaryListPageState();
}

class _DictionaryListPageState extends State<DictionaryListPage> {
  final UtilitiesController _controller = Get.put(UtilitiesController());

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    _controller.dictionaryList.value = [];
    await _controller.getAllDictionary();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: defaultLoadingWidget,
      child: SafeArea(
        child: Scaffold(
          key: _controller.scaffoldKey,
          appBar: const AppBarWidget(
            showBack: true,
            title: "Từ Điển",
          ),
          body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                    margin: EdgeInsets.only(
                        left: 20.sp, top: 10.sp, bottom: 75.sp, right: 20.sp),
                    child: Obx(() {
                      if (_controller.isLoading.value) {
                        return Center(
                          child: activityIndicator(),
                        );
                      } else {
                        return _controller.dictionaryList.isNotEmpty
                            ? GridView.builder(
                                padding: EdgeInsets.only(
                                    left: 10.sp,
                                    right: 15.sp,
                                    top: 10.sp,
                                    bottom: 10.sp),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20.sp,
                                  mainAxisSpacing: 20.sp,
                                  mainAxisExtent: 340.sp,
                                ),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: _controller.dictionaryList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return DictionaryCardWidget(
                                    image: getFullResourceUrl(_controller
                                            .dictionaryList[index].cover ??
                                        ''),
                                    updatedDate: _controller
                                        .dictionaryList[index].updatedAt,
                                    title: _controller
                                            .dictionaryList[index].name ??
                                        '',
                                    subTitle: _controller.dictionaryList[index]
                                            .description ??
                                        '',
                                    onTap: () async {
                                      context.loaderOverlay.show();

                                      _controller.selectedDictionaryID.value =
                                          _controller
                                                  .dictionaryList[index].id ??
                                              0;

                                      Get.to(() => DictionaryPage());

                                      context.loaderOverlay.hide();
                                    },
                                  );
                                })
                            : Container();
                      }
                    })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
