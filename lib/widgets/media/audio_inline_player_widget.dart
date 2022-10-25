import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AudioInlinePlayerWidgetButtons extends StatelessWidget {
  final double size;
  final bool fullMode;
  final AudioPlayer _audioPlayer;

  const AudioInlinePlayerWidgetButtons(this._audioPlayer,
      {Key? key, required this.size, required this.fullMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // fullMode
            //     ? StreamBuilder<bool>(
            //         stream: _audioPlayer.shuffleModeEnabledStream,
            //         builder: (context, snapshot) {
            //           return _shuffleButton(context, snapshot.data ?? false);
            //         },
            //       )
            //     : Container(),
            // fullMode
            //     ? StreamBuilder<SequenceState>(
            //         stream: _audioPlayer.sequenceStateStream,
            //         builder: (_, __) {
            //           return _previousButton();
            //         },
            //       )
            //     : Container(),
            StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (_, snapshot) {
                final playerState = snapshot.data;
                return _playPauseButton(playerState!);
              },
            ),
          ],
        ),
        fullMode
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<Duration>(
                    stream: _audioPlayer.positionStream,
                    builder: (_, asyncSnapshot) {
                      final Duration? duration = asyncSnapshot.data;
                      final double bufferedPercent =
                          (duration != null && _audioPlayer.duration != null)
                              ? (duration.inSeconds /
                                  _audioPlayer.duration!.inSeconds)
                              : 0;

                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: LinearPercentIndicator(
                          width: 300.0,
                          lineHeight: 30,
                          percent: bufferedPercent,
                          barRadius: const Radius.circular(16),
                          backgroundColor: Colors.grey.shade300,
                          progressColor: Get.theme.primaryColor,
                        ),
                      );
                    },
                  ),
                ],
              )
            : Container(),
        fullMode
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<Duration>(
                      stream: _audioPlayer.positionStream,
                      builder: (_, snapshot) {
                        final Duration? duration = snapshot.data;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35.0, vertical: 5.0),
                          child: durationNumberText(duration != null
                              ? duration.inSeconds.toDouble()
                              : 0),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35.0, vertical: 5.0),
                    child: durationNumberText(_audioPlayer.duration != null
                        ? _audioPlayer.duration!.inSeconds.toDouble()
                        : 0),
                  )
                ],
              )
            : Container(),
      ],
    );
  }

  Widget _playPauseButton(PlayerState playerState) {
    final processingState = playerState.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return Container(
        margin: const EdgeInsets.all(1.0),
        width: size,
        height: size,
        child: const CircularProgressIndicator(color: AppStyles.secondary),
      );
    } else if (_audioPlayer.playing != true) {
      return ClipOval(
        child: Material(
          color: Colors.grey.shade300, // Button color
          child: InkWell(
            splashColor: Get.theme.secondaryHeaderColor, // Splash color
            onTap: _audioPlayer.play,
            child: SizedBox(
                width: size,
                height: size,
                child: Icon(Icons.volume_up_rounded,
                    size: size, color: Get.theme.primaryColor)),
          ),
        ),
      );
    } else if (processingState != ProcessingState.completed) {
      return ClipOval(
        child: Material(
          color: Colors.grey.shade300, // Button color
          child: InkWell(
            splashColor: Get.theme.secondaryHeaderColor, // Splash color
            onTap: _audioPlayer.pause,
            child: SizedBox(
                width: size,
                height: size,
                child: Icon(Icons.pause_rounded,
                    size: size, color: Get.theme.primaryColor)),
          ),
        ),
      );
    } else {
      return ClipOval(
        child: Material(
          color: Colors.grey.shade300, // Button color
          child: InkWell(
            splashColor: Get.theme.secondaryHeaderColor, // Splash color
            onTap: () => _audioPlayer.seek(Duration.zero,
                index: _audioPlayer.effectiveIndices!.first),
            child: SizedBox(
                width: size,
                height: size,
                child: Icon(Icons.replay_rounded,
                    size: size, color: Get.theme.primaryColor)),
          ),
        ),
      );
    }
  }

  // Widget _shuffleButton(BuildContext context, bool isEnabled) {
  //   return IconButton(
  //     icon: isEnabled
  //         ? Icon(Icons.shuffle_rounded, color: Get.theme.primaryColor)
  //         : Icon(Icons.shuffle_rounded, color: AppStyles.grey),
  //     onPressed: () async {
  //       final enable = !isEnabled;
  //       if (enable) {
  //         await _audioPlayer.shuffle();
  //       }
  //       await _audioPlayer.setShuffleModeEnabled(enable);
  //     },
  //   );
  // }

  // Widget _previousButton() {
  //   return IconButton(
  //     icon: Icon(Icons.skip_previous_rounded,
  //         color: _audioPlayer.hasPrevious
  //             ? Get.theme.primaryColor
  //             : AppStyles.grey),
  //     onPressed: _audioPlayer.hasPrevious ? _audioPlayer.seekToPrevious : null,
  //   );
  // }

  // Widget _nextButton() {
  //   return IconButton(
  //     icon: Icon(Icons.skip_next_rounded,
  //         color:
  //             _audioPlayer.hasNext ? Get.theme.primaryColor : AppStyles.grey),
  //     onPressed: _audioPlayer.hasNext ? _audioPlayer.seekToNext : null,
  //   );
  // }

  // Widget _repeatButton(BuildContext context, LoopMode loopMode) {
  //   final icons = [
  //     Icon(Icons.repeat_rounded, color: Get.theme.primaryColor),
  //     Icon(Icons.repeat_rounded, color: Get.theme.primaryColor),
  //     Icon(Icons.repeat_one_rounded, color: Get.theme.primaryColor),
  //   ];
  //   const cycleModes = [
  //     LoopMode.off,
  //     LoopMode.all,
  //     LoopMode.one,
  //   ];
  //   final index = cycleModes.indexOf(loopMode);
  //   return IconButton(
  //     icon: icons[index],
  //     onPressed: () {
  //       _audioPlayer.setLoopMode(
  //           cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
  //     },
  //   );
  // }

}

class AudioInlinePlayerWidget extends StatefulWidget {
  final double size;
  final bool fullMode;
  final List<String>? urls;
  final bool autoplay;
  final bool mute;
  final Function(Function(bool mute))? onMute;

  const AudioInlinePlayerWidget({
    Key? key,
    required this.size,
    this.fullMode = false,
    this.urls,
    this.mute = false,
    this.autoplay = false,
    this.onMute,
  }) : super(key: key);

  @override
  _AudioInlinePlayerWidgetState createState() =>
      _AudioInlinePlayerWidgetState();
}

class _AudioInlinePlayerWidgetState extends State<AudioInlinePlayerWidget> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    List<UriAudioSource> audioSourceUris = [];

    if (widget.urls != null) {
      for (var element in widget.urls!) {
        audioSourceUris.add(AudioSource.uri(Uri.parse(element)));
      }
    }

    _audioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: audioSourceUris))
        .catchError((error) {
      // catch load errors: 404, invalid url ...
    });

    if (widget.mute) {
      _audioPlayer.setVolume(0.0);
    } else {
      _audioPlayer.setVolume(1.0);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.autoplay) {
        _audioPlayer.play();
      }
    });

    _listenOnMute();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _listenOnMute() {
    widget.onMute?.call((bool mute) {
      if (mute) {
        _audioPlayer.setVolume(0.0);
      } else {
        _audioPlayer.setVolume(1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Get.theme.scaffoldBackgroundColor),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: AudioInlinePlayerWidgetButtons(
        _audioPlayer,
        fullMode: widget.fullMode,
        size: widget.size,
      ),
    );
  }
}
