import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/configs/app_styles.dart';
import 'package:stna_lms_flutter/utils/layout_utils.dart';

class QuizResultAlertWidget extends StatelessWidget {
  final bool isCorrect;
  final bool isLastQuestion;
  final Function onClick;

  final List<String> correctMessages = [
    'Hoàn hảo!',
    'Tốt!',
    'Rất tốt!',
    'Chúc mừng!',
    'Tuyệt vời!',
    'Làm tốt lắm!',
    'Đúng rồi!',
    'Thật khó tin!',
    'Bạn đã làm được!',
  ];
  final List<String> incorrectMessages = [
    'Không đúng rồi!',
    'Không, sai hết rồi!',
    "Rất tiếc, câu trả lời không chính xác!"
  ];

  QuizResultAlertWidget(
      {Key? key,
      this.isCorrect = false,
      this.isLastQuestion = false,
      required this.onClick})
      : super(key: key);

  String _getCorrectMessage() {
    final random = Random();
    return correctMessages[random.nextInt(correctMessages.length)];
  }

  String _getIncorrectMessage() {
    final random = Random();
    return incorrectMessages[random.nextInt(incorrectMessages.length)];
  }

  @override
  Widget build(BuildContext context) {
    var imagePath =
        isCorrect ? 'images/quiz/correct.png' : 'images/quiz/incorrect.png';
    var title = isCorrect ? 'Chính Xác' : 'Không Đúng';
    var message = isCorrect ? _getCorrectMessage() : _getIncorrectMessage();
    var buttonText = isCorrect
        ? isLastQuestion
            ? 'Xem Kết Quả'
            : 'Tiếp Tục'
        : 'Thử Lại';
    var buttonColor = isCorrect ? AppStyles.green : AppStyles.red;

    return AlertDialog(
      title: Container(
          height: 70.sp,
          alignment: Alignment.center,
          child: LayoutUtils.fadeInImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            height: 70.sp,
          )),
      content: Container(
          height: 90.sp,
          margin: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.sp,
                    fontStyle: FontStyle.normal),
              ),
              SizedBox(
                height: 5.sp,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                    fontStyle: FontStyle.normal),
              )
            ],
          )),
      actions: <Widget>[
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: buttonColor),
            child: Text(
              buttonText,
              style: TextStyle(
                  color: AppStyles.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Get.back();
              onClick(); // call callback
            },
          ),
        )
      ],
    );
  }
}
