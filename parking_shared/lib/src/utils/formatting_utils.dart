import 'package:intl/intl.dart';

String formatTime(DateTime? time) {
  if (time == null) {
    return 'No start time available';
  }
  return DateFormat('HH:mm:ss').format(time);
}

String formatDate(DateTime? date) {
  if (date == null) {
    return 'No date available';
  }
  return DateFormat('yyyy-MM-dd').format(date);
}
