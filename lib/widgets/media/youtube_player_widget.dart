import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
// Package imports:
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoID;
  final bool showFullScreenButton;
  final bool autoplay;
  final bool mute;
  final Function(int, int)? updateProgress;

  const YoutubePlayerWidget(
      {Key? key,
      required this.videoID,
      this.autoplay = false,
      this.showFullScreenButton = true,
      this.updateProgress,
      this.mute = false})
      : super(key: key);

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  late String? video;
  int currentPercentage = -1;
  int currentPosition = -1;
  bool isPlayed = false;

  List<Widget>? bottomActions;

  @override
  void initState() {
    super.initState();

    video = YoutubePlayer.convertUrlToId(widget.videoID);
    _controller = YoutubePlayerController(
      initialVideoId: video ?? '',
      flags: YoutubePlayerFlags(
        mute: widget.mute,
        autoPlay: widget.autoplay,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    bottomActions = [
      CurrentPosition(),
      ProgressBar(isExpanded: true),
      RemainingDuration(),
      PlaybackSpeedButton(controller: _controller),
    ];

    if (widget.showFullScreenButton) {
      bottomActions?.add(FullScreenButton());
    }
  }

  double getVideoCompletedPercentage(Duration? position, Duration? duration) {
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

  void listener() {
    if (_isPlayerReady && mounted) {
      // callback to update progress
      if (widget.updateProgress != null) {
        try {
          int percentage = int.parse(getVideoCompletedPercentage(
                  _controller.value.position, _controller.metadata.duration)
              .toStringAsFixed(0));
          int positionInSeconds = _controller.value.position.inSeconds;

          if ((percentage > currentPercentage) &&
              (positionInSeconds > currentPosition)) {
            setState(() {
              currentPercentage = percentage;
              currentPosition = positionInSeconds;
            });

            if (widget.updateProgress != null) {
              widget.updateProgress!(currentPercentage, positionInSeconds);
            }

            // if (!isPlayed) {
            //   setState(() {
            //     isPlayed = true;
            //   });
            // }
          }
        } catch (e) {
          print(e);
        }
      }
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  Future<bool> _checkForLandscape(BuildContext ctx) async {
    if (MediaQuery.of(ctx).orientation == Orientation.landscape) {
      await SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
        ],
      );
      _controller.toggleFullScreenMode();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _checkForLandscape(context),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return YoutubePlayerBuilder(
            onExitFullScreen: () {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
            },
            onEnterFullScreen: () {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.landscapeLeft]);
            },
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: AppStyles.blueDark,
              aspectRatio: constraints.maxHeight / constraints.maxWidth,
              topActions: <Widget>[
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    _controller.metadata.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
              bottomActions: bottomActions,
              onReady: () {
                setState(() {
                  _isPlayerReady = true;
                });
              },
              onEnded: (data) async {
                if (widget.updateProgress != null) {
                  widget.updateProgress!(
                      100, _controller.metadata.duration.inSeconds);
                }
              },
            ),
            builder: (context, player) => SafeArea(
                child: Scaffold(
              body: Stack(
                children: [
                  Positioned.fill(
                      child: Container(
                    color: Colors.black,
                    child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: player,
                      ),
                    ),
                  )),
                  Positioned(
                    top: 30,
                    left: 30,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon:
                          const Icon(Icons.cancel, color: AppStyles.blueLight),
                    ),
                  ),
                ],
              ),
            )),
          );
        }));
  }
}
