import 'package:flutter/material.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/widgets/media/video_player_widget.dart';

class LessonViewerVideoWidget extends StatelessWidget {
  final HomeController controller;
  final DashboardController dashboardController;
  final Function(int, int) updateProgress;

  const LessonViewerVideoWidget(
      {Key? key,
      required this.controller,
      required this.dashboardController,
      required this.updateProgress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
          padding: const EdgeInsets.all(5.0),
          child: VideoPlayerWidget(
            updateProgress: (percentage, position) {
              updateProgress(percentage, position);
            },
            videoUrl:
                getFullResourceUrl(controller.lectureDetail.value?.video ?? ''),
          )),
    );
  }
}
