import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/controllers/dictionary_controller.dart';
import 'package:stna_lms_flutter/models/dictionary_model.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';

class ToggleFavoriteWord extends StatefulWidget {
  final DictionaryWordModel? word;
  const ToggleFavoriteWord({Key? key, this.word}) : super(key: key);

  @override
  State<ToggleFavoriteWord> createState() => _ToggleFavoriteWordState();
}

class _ToggleFavoriteWordState extends State<ToggleFavoriteWord> {
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DictionaryController>(builder: (controller) {
      final currentWord = controller.currentTabIndex == 0
          ? controller.listWord.where((w) => w.id == widget.word!.id).first
          : controller.listWordFavorite
              .where((w) => w.id == widget.word!.id)
              .first;
      // ;
      return GestureDetector(
        onTap: () async {
          await controller.toggleFavoriteWord(
              widget.word!.id ?? 0, widget.word?.orderNumber ?? 0);

          setState(() {
            toggle = !toggle;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          decoration: BoxDecoration(
              gradient: currentWord.isFavorite
                  ? LayoutUtils.gradientBlueDark
                  : LayoutUtils.gradientGrey,
              borderRadius: BorderRadius.circular(5.0)),
          child: Icon(
            currentWord.isFavorite
                ? Icons.flag_rounded
                : Icons.outlined_flag_rounded,
            color: Colors.white,
            size: 22.sp,
          ),
        ),
        // child: const ToggleClick(),
      );
    });
  }
}
