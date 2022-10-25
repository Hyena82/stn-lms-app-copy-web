import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/pages/utilities/dictionary_list_page.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/widgets/layout/app_bar_widget.dart';

class UtilitiesPage extends StatefulWidget {
  const UtilitiesPage({Key? key}) : super(key: key);

  @override
  _UtilitiesPageState createState() => _UtilitiesPageState();
}

class _UtilitiesPageState extends State<UtilitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(
          title: "Tiện Ích",
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15.sp, 10.sp, 15.sp, 10.sp),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return UtilityItemWidget(
                      image: 'images/utility/dictionary.jpg',
                      title: "Từ điển Siêu Trí Nhớ",
                      description:
                          "Cung cấp giải nghĩa của từ vựng, cách phát âm, ngữ pháp, ví dụ ...",
                      onTap: () async {
                        Get.to(() => const DictionaryListPage());
                      },
                    );
                  }),
            )
          ],
        ));
  }
}

class UtilityItemWidget extends StatefulWidget {
  final VoidCallback onTap;
  final String image;
  final String title;
  final String description;

  const UtilityItemWidget(
      {Key? key,
      required this.onTap,
      required this.image,
      required this.title,
      required this.description})
      : super(key: key);

  @override
  State<UtilityItemWidget> createState() => _UtilityItemWidgetState();
}

class _UtilityItemWidgetState extends State<UtilityItemWidget> {
  final _wp = Get.width / 100;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: LayoutUtils.boxDecoration(),
        margin: EdgeInsets.fromLTRB(0, 6.sp, 0, 6.sp),
        child: IntrinsicHeight(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(5.sp),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5.sp)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.sp),
                child: LayoutUtils.fadeInImage(
                  height: 100.sp,
                  width: 100.sp,
                  image: AssetImage(widget.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: _wp * 60,
                margin: EdgeInsets.only(left: 16.sp, right: 16.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5.sp,
                    ),
                    courseTitle(widget.title),
                    SizedBox(
                      height: 2.sp,
                    ),
                    courseAuthorName(widget.description),
                    SizedBox(
                      height: 10.sp,
                    )
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
      onTap: widget.onTap,
    );
  }
}
