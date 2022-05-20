import 'package:flutter/widgets.dart';

/// A utility class that contains implementations of some common validators.
abstract class InputValidator {
  static final _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  /// Creates a validator than enforces the input string to have a pattern
  /// specified by [regExp].
  ///
  /// It returns [message] as an error in case, an invalid string is provided.
  ///
  /// ```
  /// class TestPage extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Column(children: <Widget>[
  ///       TextFormField(
  ///         validator: InputValidator.match(regExp: RegExp('<any-pattern>')),
  ///       ),
  ///       TextFormField(
  ///         validator: InputValidator.email(
  ///           regExp: RegExp('<any-pattern>'),
  ///           message: 'Custom Error Message',
  ///         ),
  ///       ),
  ///     ]);
  ///   }
  /// }
  /// ```
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

  /// Creates a validator than enforces the input string to be a valid email.
  /// It returns [message] as an error in case, an invalid email in provided.
  ///
  /// ```
  /// class TestPage extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Column(children: <Widget>[
  ///       TextFormField(validator: InputValidator.email()),
  ///       TextFormField(
  ///         validator: InputValidator.email(message: 'Custom Error Message'),
  ///       ),
  ///     ]);
  ///   }
  /// }
  /// ```
  static FormFieldValidator<String>? email({
    String message = 'This is not a valid email address',
  }) {
    return (String? value) {
      if (_emailRegExp.hasMatch(value ?? '')) return null;
      return message;
    };
  }

  /// Creates a validator than enforces the input string to have length
  /// between [min] and [max].
  ///
  /// It returns [minMessage] as an error in case, length in lesser than [min].
  /// It returns [maxMessage] as an error in case, length in lesser than [max].
  ///
  /// ```
  /// class TestPage extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Column(children: <Widget>[
  ///       TextFormField(validator: InputValidator.length(min: 10)),
  ///       TextFormField(
  ///         validator: InputValidator.length(
  ///           min: 10,
  ///           message: 'Custom Error Message',
  ///         ),
  ///       ),
  ///     ]);
  ///   }
  /// }
  /// ```
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

  /// Creates a validator than enforces the input string to have [pattern] in it
  /// It returns [message] as an error in case, an invalid email in provided.
  ///
  /// ```
  /// class TestPage extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Column(children: <Widget>[
  ///       TextFormField(
  ///         validator: InputValidator.contains(patterns: '<any-pattern>'),
  ///       ),
  ///       TextFormField(
  ///         validator: InputValidator.email(
  ///           patterns: '<any-pattern>',
  ///           message: 'Custom Error Message',
  ///         ),
  ///       ),
  ///     ]);
  ///   }
  /// }
  /// ```
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

  /// Creates a validator that enforces the input string is a valid password.
  /// It returns [message] as an error in case, wrong password is provided.
  ///
  /// The execution stops if a validator fails and the failure message is
  /// returned.
  ///
  /// ```
  /// class TestPage extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return TextFormField(
  ///       validator: InputValidator.password(
  ///         message: 'Custom Error Message',
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  static FormFieldValidator<String>? password({
    String message = 'Must have uppercase, lowercase & number',
  }) {
    return (String? value) {
      if (value?.isEmpty ?? true) {
        return 'This field is required';
      }
      if (value!.length < 8) {
        return 'Must be 8 characters long';
      }
      if (!RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
         .hasMatch(value))
       return message;
     return null;
    };
  }
  
  /// Creates a validator than enforces the input string to be not empty.
  /// It returns [message] as an error in case, an empty string is provided.
  ///
  /// ```
  /// class TestPage extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Column(children[
  ///       TextFormField(validator: InputValidator.required()),
  ///       TextFormField(
  ///         validator: InputValidator.required(message: 'Custom Error Message'),
  ///       ),
  ///     ]);
  ///   }
  /// }
  /// ```
  static FormFieldValidator<String>? required({
    String message = 'This field is required',
  }) {
    return (String? value) {
      if ((value ?? '').toString().isNotEmpty) return null;
      return message;
    };
  }

  /// Creates a validator from a List of [FormFieldValidator], all the validators
  /// are executed sequentially.
  ///
  /// The execution stops if a validator fails and the failure message is
  /// returned.
  ///
  /// ```
  /// class TestPage extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return TextFormField(
  ///       validator: InputValidator.multiple([
  ///         InputValidator.required(),
  ///         InputValidator.email(),
  ///
  ///         // a custom validator.
  ///         (String? value) {
  ///           // add your logic here.
  ///         }
  ///       ]),
  ///     );
  ///   }
  /// }
  /// ```
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
