import 'package:intl/intl.dart';

class DateTimeFormatter {
  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd - HH:mm');
    return formatter.format(dateTime);
  }
}
