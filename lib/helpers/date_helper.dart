import 'package:intl/intl.dart';
import 'package:logger_console/logger_console.dart';

class DateHelper {
  static int toMilliseconds([DateTime? date]) {
    if (date != null) {
      return date.millisecondsSinceEpoch;
    }

    return DateTime.now().millisecondsSinceEpoch;
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return '';

    final timeZoneOffset = DateTime.now().timeZoneOffset;
    return DateFormat('dd/MM/yyyy hh:mm a').format(date.add(timeZoneOffset));
  }

  static String formatDate(date) {
    return DateFormat.yMd().format(date);
  }

  static String formatDateOnly(date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatHourOnly(date) {
    final timeZoneOffset = DateTime.now().timeZoneOffset;
    return DateFormat('hh:mm a').format(date.add(timeZoneOffset));
  }

  static String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }
}
