import 'package:intl/intl.dart';

final numberFormatConfig = NumberFormat("#,##0", "en_US");

class CurrencyHelper {
  static String format(double? input) {
    return '${numberFormatConfig.format(input ?? 0)}đ';
  }
}
