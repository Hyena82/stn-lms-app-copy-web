import 'package:flutter/material.dart';
import 'package:stna_lms_flutter/controllers/dashboard_controller.dart';
import 'package:stna_lms_flutter/controllers/home_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stna_lms_flutter/utils/converter.dart';

class LessonViewerGalleryWidget extends StatefulWidget {
  final HomeController controller;
  final DashboardController dashboardController;

  const LessonViewerGalleryWidget(
      {Key? key, required this.controller, required this.dashboardController})
      : super(key: key);

  @override
  State<LessonViewerGalleryWidget> createState() =>
      _LessonViewerGalleryWidgetState();
}

class _LessonViewerGalleryWidgetState extends State<LessonViewerGalleryWidget> {
  final List<String> images = [];

  @override
  void initState() {
    widget.controller.lectureDetail.value?.images?.forEach((element) {
      images.add(getFullResourceUrl(element));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var imageUrl in images) {
        precacheImage(NetworkImage(imageUrl), context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(10.0),
          child: CarouselSlider.builder(
            itemCount: images.length,
            options: CarouselOptions(
              height: double.infinity,
              autoPlay: false,
              enlargeCenterPage: true,
            ),
            itemBuilder: (context, index, realIdx) {
              return Center(
                  child: Image.network(images[index],
                      fit: BoxFit.cover, width: 1000));
            },
          )),
    );
  }
}
