import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stna_lms_flutter/widgets/loading/loading_skeleton.dart';

class LoadingSkeletonItemWidget extends StatelessWidget {
  const LoadingSkeletonItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width;
    double percentageWidth;

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;

    return SizedBox(
      height: 280.sp,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 15.sp,
            );
          },
          padding: EdgeInsets.only(bottom: 15.sp, left: 20.sp, top: 10.sp),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                color: Get.theme.cardColor,
                borderRadius: BorderRadius.circular(5.sp),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.shadowColor,
                    blurRadius: 10.sp,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: 5.sp),
              width: 174.sp,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.sp),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                      child: LoadingSkeleton(
                        width: 200.sp,
                        height: 150.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.sp, vertical: 5.sp),
                      child: Column(
                        children: [
                          LoadingSkeleton(
                            height: 10.sp,
                            width: percentageWidth * 70,
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          LoadingSkeleton(
                            height: 10.sp,
                            width: percentageWidth * 70,
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          LoadingSkeleton(
                            height: 10.sp,
                            width: percentageWidth * 70,
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 5.sp,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
