import 'package:intl/intl.dart';

class DateUtils {
  static bool isSameDate(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime1 == null || dateTime2 == null) {
      return false;
    }
    final localdate1 = dateTime1.toLocal();
    final localdate2 = dateTime2.toLocal();
    return localdate1.year == localdate2.year &&
        localdate1.month == localdate2.month &&
        localdate1.day == localdate2.day;
  }

  static bool isToday(DateTime dateTime) =>
      isSameDate(dateTime, DateTime.now());

  static bool isTomorrow(DateTime dateTime) =>
      isSameDate(dateTime, DateTime.now().add(Duration(days: 1)));

  static String timeRangeString(DateTime start, DateTime end) {
    String startStr = start != null
        ? DateFormat(start.minute == 0 ? 'h a' : 'h:mm a')
            .format(start.toLocal())
        : null;
    String endStr = end != null
        ? DateFormat(end.minute == 0 ? 'h a' : 'h:mm a').format(end.toLocal())
        : null;
    return [startStr, endStr]
        .where((str) => str != null)
        .join(' - ')
        .toLowerCase();
  }
}
