class CourseInprogressModel {
  CourseInprogressModel(
      {this.courseId,
      this.courseName,
      this.contentName,
      this.date,
      this.thumbnail});

  int? courseId;
  String? courseName;
  String? contentName;
  DateTime? date;
  String? thumbnail;
}
