import 'package:intl/intl.dart';

class DateHelper {
  static String format(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }
}
