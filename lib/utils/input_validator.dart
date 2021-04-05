import 'package:flutter/widgets.dart';

///
abstract class InputValidator {
  static final _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static FormFieldValidator<String>? match({
    required RegExp regExp,
    String? message,
  }) {
    message ??= 'Input must match $regExp pattern';
    return (String? value) {
      if (!regExp.hasMatch(value ?? '')) return message;
      return null;
    };
  }

  static FormFieldValidator<String>? email({
    String message = 'This is not a valid email address'
  }) {
    return (String? value) {
      if (_emailRegExp.hasMatch(value ?? '')) return null;
      return message;
    };
  }

  static FormFieldValidator<String>? length({
    int? max,
    int min = 0,
    String? minMessage,
    String? maxMessage,
  }) {
    max ??= double.maxFinite.toInt();

    maxMessage ??= '$max characters are allowed at max';
    minMessage ??= 'Minimum length of $min characters is required';

    return (String? value) {
      if (value == null) return minMessage;
      if (value.length < min) return minMessage;
      if (value.length > max!) return maxMessage;

      return null;
    };
  }

  ///
  static FormFieldValidator<String>? contains({
    required String pattern,
    String? message,
  }) {
    assert(pattern.isNotEmpty, '`pattern` must not be empty');
    message ??= 'Input must include `$pattern` inside it';

    return (String? value) {
      if (!(value ?? '').contains(pattern)) return message;
      return null;
    };
  }

  ///
  static FormFieldValidator<T>? required<T>({
    String message = 'This field is required',
  }) {
    return (T? value) {
      if ((value ?? '').toString().isNotEmpty) return null;
      return message;
    };
  }

  ///
  static FormFieldValidator<T> multiple<T>(
    List<FormFieldValidator<T>> validators,
  ) {
    return (T? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }

      return null;
    };
  }
}
