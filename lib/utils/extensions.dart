import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  /// Date Format to 05-07-2022
  String get dateFormat => DateFormat('dd-MM-yyyy').format(this);

  /// Time Format to 04:49 PM
  String get timeFormat => DateFormat('hh:mm a').format(this);

  /// Date Format to 05-07-2022 04:49 PM
  String get dateTimeFormat => DateFormat('dd-MM-yyyy, hh:mm a').format(this);

  /// Date Format to 05 Feb 2022
  String get dateMonthFormat => DateFormat('dd MMM yyyy').format(this);

  /// Date Format to only month name Jan
  String get monthFormat => DateFormat('MMM').format(this);

  /// Date Format to only day name Mon
  String get dayFormat => DateFormat('EEE').format(this);

  /// Date Format to 05-07-2022 Saturday
  String get dateDayFormat => DateFormat('dd-MM-yyyy EEEE').format(this);
}
