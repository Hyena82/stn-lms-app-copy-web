import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';
import 'package:stna_lms_flutter/widgets/media/youtube_player_widget.dart';

class LessonViewerYoutubeWidget extends StatelessWidget {
  final HomeController controller;
  final DashboardController dashboardController;
  final Function(int, int) updateProgress;

  const LessonViewerYoutubeWidget(
      {Key? key,
      required this.controller,
      required this.dashboardController,
      required this.updateProgress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      decoration: LayoutUtils.boxDecoration(),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: NetworkImage(getYoutubeThumbnailUrl(
                      controller.lectureDetail.value?.youtubeUrl) ??
                  ''),
            ),
          )),
          Positioned(
              child: AvatarGlow(
            glowColor: AppStyles.blueDark,
            endRadius: 110.0,
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            showTwoGlows: true,
            repeatPauseDuration: const Duration(milliseconds: 100),
            child: GestureDetector(
                onTap: () async {
                  Get.bottomSheet(
                    YoutubePlayerWidget(
                      videoID: controller.lectureDetail.value?.youtubeUrl ?? '',
                      updateProgress: (percentage, position) {
                        updateProgress(percentage, position);
                      },
                    ),
                    backgroundColor: Colors.black,
                    isScrollControlled: true,
                  );
                },
                child: Material(
                  color: AppStyles.blueLighter,
                  shape: const CircleBorder(),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 70.sp,
                    color: AppStyles.blueDark,
                  ),
                )),
          ))
        ],
      ),
    );
  }
}
