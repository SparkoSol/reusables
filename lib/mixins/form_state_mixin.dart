import 'dart:async';

import 'package:flutter/material.dart';

/// Add this mixin to a [Widget] or [State] to ease use of [Form].
mixin FormStateMixin<T extends StatefulWidget> on State<T> {
  /// This Key must be bound with the [Form] Widget that is to be used.
  final formKey = GlobalKey<FormState>();
  var autovalidateMode = AutovalidateMode.disabled;

  /// Pass this function as a parameter to Widget that acts as a submit button,
  ///
  /// For Example,
  /// ```dart
  /// TextButton(
  ///   child: Text('Submit'),
  ///   onPressed: submitter,
  /// )
  /// ```

  void submitter() {
    // First check if all the fields are valid or not i.e. provided validators.
    if (!formKey.currentState!.validate()) {
      autovalidateMode = AutovalidateMode.onUserInteraction;
      setState(() {});
      return;
    }
    // Save all the field values i.e. data binding.
    formKey.currentState?.save();

    // Call user defined code.
    onSubmit();
  }

  /// The user must override this method since this method will be called by
  /// [submitter] once the form is validated.
  FutureOr<void> onSubmit() {}
}
