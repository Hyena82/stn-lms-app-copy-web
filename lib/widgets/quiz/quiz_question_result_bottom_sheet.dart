import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stna_lms_flutter/configs/app_text_themes.dart';
import 'package:stna_lms_flutter/controllers/question_controller.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';

class QuizQuestionResultBottomSheet extends StatelessWidget {
  final QuestionController questionController;
  final List<int> answerIds;
  final int questionIndex;
  final bool success;
  final String message;

  const QuizQuestionResultBottomSheet(
      {Key? key,
      required this.questionController,
      required this.answerIds,
      required this.questionIndex,
      required this.success,
      required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = success ? AppStyles.green : AppStyles.red;

    return SizedBox(
        height: 80,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    child: Text(message,
                        style: AppTextThemes.label3().copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 21.sp))),
              ],
            ),
          ],
        ));
  }
}
