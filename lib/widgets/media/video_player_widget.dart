import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/question_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool showFullScreenButton;
  final bool autoplay;
  final bool mute;
  final Function(int, int)? updateProgress;

  const VideoPlayerWidget(
      {Key? key,
      required this.videoUrl,
      this.autoplay = false,
      this.mute = false,
      this.showFullScreenButton = true,
      this.updateProgress})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerWidgetState();
  }
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  final _questionController = Get.find<QuestionController>();

  int? bufferDelay;

  int currentPercentage = 0;
  int currentPosition = 0;

  bool isPlayed = false;

  @override
  void initState() {
    _initializePlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _questionController.setVideoPlayController(_videoPlayerController);

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: widget.autoplay,
        looping: false,
        showControls: true,
        showOptions: true,
        allowFullScreen: widget.showFullScreenButton,
        hideControlsTimer: const Duration(seconds: 1),
        showControlsOnInitialize: true,
        playbackSpeeds: [1.25, 1.5, 1.75, 2.0, 2.25, 2.5],
        allowedScreenSleep: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppStyles.blueDark,
          handleColor: AppStyles.blueDark,
          backgroundColor: Colors.grey,
          bufferedColor: AppStyles.blue,
        ),
        placeholder: Container(
          color: Colors.grey,
        ));

    _videoPlayerController.setVolume(0.0);
    if (widget.mute) {
    } else {
      _videoPlayerController.setVolume(1.0);
    }

    _videoPlayerController.addListener(_checkVideo);

    setState(() {});
  }

  double _getVideoCompletedPercentage(Duration? position, Duration? duration) {
    int pos = 0;
    int dur = 0;

    if (position != null) {
      pos = position.inMilliseconds;
    }

    if (duration != null) {
      dur = duration.inMilliseconds;
    }

    return (pos / dur) * 100;
  }

  void _checkVideo() {
    if (_videoPlayerController.value.position ==
        _videoPlayerController.value.duration) {
      if (widget.updateProgress != null) {
        widget.updateProgress!(100,
            _videoPlayerController.value.duration.inSeconds); // update progress
      }
    }

    // callback to update progress
    if (widget.updateProgress != null) {
      int percentage = int.parse(_getVideoCompletedPercentage(
              _videoPlayerController.value.position,
              _videoPlayerController.value.duration)
          .toStringAsFixed(0));
      int positionInSeconds = _videoPlayerController.value.position.inSeconds;

      if (!isPlayed ||
          (percentage != currentPercentage &&
              positionInSeconds != currentPosition)) {
        currentPercentage = percentage;
        currentPosition = positionInSeconds;

        if (widget.updateProgress != null) {
          widget.updateProgress!(
              currentPercentage, positionInSeconds); // update progress

        }

        if (!isPlayed) {
          setState(() {
            isPlayed = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isReady = _videoPlayerController.value.isInitialized;

    return SafeArea(
        child: Column(
      children: <Widget>[
        Expanded(
          child: isReady
              ? Center(
                  child: Chewie(
                  controller: _chewieController!,
                ))
              : Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                ),
        ),
      ],
    ));
  }
}
