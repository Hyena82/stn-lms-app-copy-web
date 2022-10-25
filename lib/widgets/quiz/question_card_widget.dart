import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/question_controller.dart';
import 'package:stna_lms_flutter/models/quiz_question_model.dart';
import 'package:stna_lms_flutter/utils/converter.dart';
import 'package:stna_lms_flutter/utils/text_utils.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/widgets/media/audio_inline_player_widget.dart';
import 'package:stna_lms_flutter/widgets/media/video_player_widget.dart';
import 'package:stna_lms_flutter/widgets/media/youtube_player_widget.dart';

class QuestionCard extends StatefulWidget {
  final QuizQuestionModel question;
  final int index;
  final Function onChooseAnswer;
  final bool autoplay;
  final bool mute;
  final bool showAnswerOnSelect;
  final Function(Function(bool mute))? onMute;

  const QuestionCard({
    Key? key,
    this.autoplay = false,
    this.showAnswerOnSelect = false,
    required this.question,
    required this.index,
    required this.onChooseAnswer,
    required this.mute,
    this.onMute,
  }) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int questionAnswersIndex = 0;
  List<CheckboxModal> checkBoxList = [];
  List<int> answerIds = [];
  List<int> answerIndexes = [];

  bool _showGrid = false;
  bool _isSingleChoice = false;
  bool _showAnswerOnSelect = false;
  String _quizType = 'none';

  final _wp = Get.width / 100;
  final _hp = Get.height / 100;

  final QuestionController _questionController = Get.put(QuestionController());

  late AudioPlayer _questionAudioPlayer;

  @override
  void initState() {
    setState(() {
      if (widget.question.videoUrl != null &&
          widget.question.videoUrl?.trim() != '') {
        _quizType = 'youtube';
      } else if (widget.question.video != null &&
          widget.question.video?.trim() != '') {
        _quizType = 'video';
      } else if (widget.question.image != null) {
        _quizType = 'image';
        if (widget.question.audio != null) {
          _questionAudioPlayer = AudioPlayer();

          if (!widget.mute) {
            playAudio(widget.question.audio ?? '');
          }
        }
      } else if (widget.question.audio != null) {
        _quizType = 'audio';
      }
    });

    var index = 0;
    widget.question.answers?.forEach((answer) {
      index = index + 1;
      checkBoxList.add(CheckboxModal(
          index: index,
          title: answer.answer,
          id: answer.answerId,
          value: false,
          isCorrect: answer.isCorrect));
    });

    _isSingleChoice = widget.question.isSingleChoice;
    _showAnswerOnSelect = widget.showAnswerOnSelect;
    _showGrid = widget.question.showGrid;

    super.initState();
  }

  Future playAudio(String link) async {
    await _questionAudioPlayer.setUrl(getFullResourceUrl(link));
    _questionAudioPlayer.play();
  }

  onChooseAnswer(CheckboxModal answerCheckboxItem) {
    if (widget.question.isSingleChoice) {
      // for questions, with is single choice question
      setState(() {
        var value = !answerCheckboxItem.value;
        for (var element in checkBoxList) {
          element.value = false;
        }
        answerCheckboxItem.value = value;
      });

      answerIds.clear();
      answerIndexes.clear();
    } else {
      // for multiple choice question
      setState(() {
        var value = !answerCheckboxItem.value;
        answerCheckboxItem.value = value;
      });

      answerIds.removeWhere((element) => element == answerCheckboxItem.id);
      answerIndexes
          .removeWhere((element) => element == answerCheckboxItem.index);
    }

    if (answerCheckboxItem.value) {
      answerIds.add(answerCheckboxItem.id ?? 0);
      answerIndexes.add(answerCheckboxItem.index ?? 0);
    }

    widget.onChooseAnswer(answerIds, answerIndexes);
  }

  Widget _buildAnswerGrid(QuestionController qnController) {
    return Expanded(
        child: GridView.count(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.0,
      mainAxisSpacing: 4.sp,
      crossAxisSpacing: 4.sp,
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 5.sp),
      children: _buildAnswerGridItem(qnController),
    ));
  }

  Widget _buildAnswerList(QuestionController qnController) {
    return Expanded(
        child: ListView.builder(
            itemCount: checkBoxList.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 5.sp),
            itemBuilder: (BuildContext context, int index) {
              return _buildAnswerListItem(qnController, checkBoxList[index]);
            }));
  }

  Widget _buildAnswerListItem(
      QuestionController qnController, CheckboxModal item) {
    var isSelected = qnController.currentAnswerIndexes.contains(item.index);
    var color = AppStyles.blue;
    var iconOn = _isSingleChoice
        ? Icons.radio_button_on_rounded
        : Icons.check_box_rounded;
    var iconOff = _isSingleChoice
        ? Icons.radio_button_off_rounded
        : Icons.check_box_outline_blank_rounded;
    var icon = iconOff;
    var disabled = qnController.needCheckResult.value == -1;

    if (qnController.needCheckResult.value == 1) {
      color = isSelected ? AppStyles.blueDark : AppStyles.grey;
      icon = isSelected ? iconOn : iconOff;
    }

    if (qnController.needCheckResult.value == -1 && _showAnswerOnSelect) {
      var isCorrect = item.isCorrect;
      color = isCorrect
          ? AppStyles.green
          : (isSelected ? AppStyles.red : AppStyles.grey);
      icon = isCorrect
          ? Icons.check_circle_rounded
          : (isSelected ? Icons.cancel_rounded : iconOff);
    }

    return Container(
      margin: EdgeInsets.fromLTRB(5.sp, 0, 5.sp, 5.sp),
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      decoration: BoxDecoration(
          border: Border.all(width: 2.sp, color: color),
          borderRadius: BorderRadius.circular(5.sp)),
      child: ListTile(
        leading: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
            child: Icon(
              icon,
              color: color,
              size: 20.sp,
            )),
        onTap: () {
          if (disabled) {
            return;
          }

          onChooseAnswer(item);
        },
        title: Text(
          item.title ?? '',
          style: AppTextThemes.heading6().copyWith(color: color),
        ),
      ),
    );
  }

  List<Widget> _buildAnswerGridItem(QuestionController qnController) {
    return checkBoxList.map((item) {
      var isSelected = qnController.currentAnswerIndexes.contains(item.index);
      var color = AppStyles.blue;
      var iconOn = _isSingleChoice
          ? Icons.radio_button_on_rounded
          : Icons.check_box_rounded;
      var iconOff = _isSingleChoice
          ? Icons.radio_button_off_rounded
          : Icons.check_box_outline_blank_rounded;
      var icon = iconOff;
      var disabled = qnController.needCheckResult.value == -1;

      if (qnController.needCheckResult.value == 1) {
        color = isSelected ? AppStyles.blueDark : AppStyles.grey;
        icon = isSelected ? iconOn : iconOff;
      }

      if (qnController.needCheckResult.value == -1 && _showAnswerOnSelect) {
        var isCorrect = item.isCorrect;
        color = isCorrect
            ? AppStyles.green
            : (isSelected ? AppStyles.red : AppStyles.grey);
        icon = isCorrect
            ? Icons.check_circle_rounded
            : (isSelected ? Icons.cancel_rounded : iconOff);
      }

      return Container(
        margin: EdgeInsets.fromLTRB(5.sp, 0, 5.sp, 5.sp),
        padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
        decoration: BoxDecoration(
            border: Border.all(width: 2.sp, color: color),
            borderRadius: BorderRadius.circular(5.sp)),
        child: GridTile(
          header: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
              child: Icon(
                icon,
                color: color,
                size: 20.sp,
              )),
          child: InkWell(
              onTap: () {
                if (disabled) {
                  return;
                }

                onChooseAnswer(item);
              },
              child: Container(
                  margin: EdgeInsets.only(top: 15.sp),
                  padding: EdgeInsets.all(10.sp),
                  alignment: Alignment.center,
                  child: Text(
                    item.title ?? '',
                    style: AppTextThemes.heading6().copyWith(color: color),
                  ))),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildQuestionResourceSection(Get.height, _hp),
        _showGrid
            ? _buildAnswerGrid(_questionController)
            : _buildAnswerList(_questionController)
      ],
    );
  }

  Widget _buildQuestionResourceSection(double height, double heightPercent) {
    return Container(
      padding: EdgeInsets.only(right: 10.sp, left: 10.sp, bottom: 5.sp),
      child: Column(
        children: [
          SizedBox(
              width: Get.width,
              child: questionText(widget.question.question, widget.index)),
          _quizType == 'image'
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(5.sp),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          child: Container(
                            alignment: Alignment.center,
                            child: questionImage(widget.question.image,
                                height: heightPercent * 30, width: Get.width),
                          ),
                        ),
                        widget.question.audio != null
                            ? Positioned(
                                child: GestureDetector(
                                    onTap: () async {
                                      if (_questionController
                                          .questionMute.value) return;
                                      await playAudio(widget.question.audio!);
                                    },
                                    child: Material(
                                      color: Colors.grey.shade300,
                                      shape: const CircleBorder(),
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        size: 30.sp,
                                        color: AppStyles.blueDark,
                                      ),
                                    )),
                              )
                            : Container()
                      ],
                    ),
                  ))
              : Container(),
          _quizType == 'youtube'
              ? Container(
                  height: _wp * 55,
                  width: _wp * 95,
                  padding: EdgeInsets.all(5.sp),
                  child: YoutubePlayerWidget(
                    videoID: widget.question.videoUrl ?? '',
                    autoplay: true,
                    mute: widget.mute,
                    showFullScreenButton: true,
                  ))
              : Container(),
          _quizType == 'video'
              ? Container(
                  child: VideoPlayerWidget(
                      showFullScreenButton: true,
                      autoplay: true,
                      mute: widget.mute,
                      videoUrl:
                          getFullResourceUrl(widget.question.video ?? '')),
                  height: _wp * 55,
                  width: _wp * 95,
                  padding: EdgeInsets.all(5.sp),
                )
              : Container(),
          _quizType == 'audio'
              ? AudioInlinePlayerWidget(
                  urls: [getFullResourceUrl(widget.question.audio ?? '')],
                  autoplay: true,
                  mute: widget.mute,
                  size: 30.sp,
                  onMute: widget.onMute,
                )
              : Container(),
        ],
      ),
    );
  }
}
