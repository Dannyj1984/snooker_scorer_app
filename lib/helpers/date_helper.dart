export 'date_helper.dart';

String convertDate(String format, String date) {
  if (format == 'YYYY-MM-DD') {
    return '${date.substring(8, 10)}-${date.substring(5, 7)}-${date.substring(0, 4)}';
  }
  return date;
}
