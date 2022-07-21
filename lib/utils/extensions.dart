import 'dart:developer' as devtool show log;
import 'dart:math';

import 'package:flutter/material.dart';
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

extension RandomElement<T> on Iterable<T> {
  /// This will give you a random element from list
  T getRandomElement() => elementAt(Random().nextInt(length));
}

extension Log on Object {
  /// Directly call log() on any object to print at console
  /// i.e. 'abc'.log() = log('abc')
  void log() => devtool.log(toString());
}

extension Navigation on BuildContext {
  /// extension on BuildContext to make navigation easier
  ///
  /// Usage
  ///
  /// context.showSnackbar('This is a snackbar')
  /// context.push(HomePage())
  /// context.navigateRemoveUntil(HomePage())
  /// context.pop()
  /// context.unFocus() instead of [FocusScope.of(context).unfocus()];

  void showSnackbar(String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(this);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<dynamic> push(Widget page) async {
    return await Navigator.of(this).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  navigateRemoveUntil(Widget page) async {
    Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute<dynamic>(builder: (BuildContext con) => page),
      (route) => false,
    );
  }

  pop() => Navigator.of(this).pop();

  void unFocus() => FocusScope.of(this).unfocus();
}
