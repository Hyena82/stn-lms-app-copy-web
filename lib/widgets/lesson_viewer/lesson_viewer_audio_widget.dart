import 'package:flutter/material.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:stna_lms_flutter/widgets/media/audio_player_widget.dart';

class LessonViewerAudioWidget extends StatelessWidget {
  final HomeController controller;
  final DashboardController dashboardController;
  final Function(int, int) updateProgress;

  const LessonViewerAudioWidget(
      {Key? key,
      required this.controller,
      required this.dashboardController,
      required this.updateProgress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: AudioPlayerWidget(
            urls: controller.lectureDetail.value?.audios ?? [],
            updateProgress: (percentage, position) {
              updateProgress(percentage, position);
            },
          )),
    );
  }
}
