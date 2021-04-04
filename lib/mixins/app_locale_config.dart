import 'dart:ui';
import 'package:flutter/widgets.dart';

/// Adds capability to change application's localization at runtime.
///
/// It can be added as a mixin to AppConfig class which has to be a
/// [ChangeNotifier].
mixin AppLocaleConfigMixin on ChangeNotifier {
  var _locale = PlatformDispatcher.instance.locale;

  /// Returns the current Locale of application.
  /// If none is specified than system's locale is returned.
  ///
  /// Must See:
  /// [PlatformDispatcher.locale]
  Locale get locale => _locale;

  /// Changes the application's Locale to [locale].
  ///
  /// If [locale] is different from current Locale than the new [locale] is
  /// marked as current an a notification is sent to application to rebuild
  /// itself.
  ///
  /// No Changes take place if the same locale is reassigned.
  set locale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;

      // notify application to rebuild
      notifyListeners();
    }
  }
}
