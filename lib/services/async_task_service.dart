import 'dart:async';
import 'package:flutter/material.dart';

typedef AsyncTask<T> = Future<T> Function();

/// Determines how the [AsyncTaskService] will handle the execution of async
/// task i.e. Changing UI before and after execution etc.
abstract class AsyncTaskBehaviour {
  /// Creates an instance of [AsyncTaskBehaviour]
  const AsyncTaskBehaviour();

  /// This function is called before execution of async task.
  ///
  /// It can be use to change or update ui state before task execution. i.e.
  /// open dialog or start some kind of progress indicator.
  FutureOr<void> before(BuildContext context, [arguments]);

  /// This function is called if some error is occurred while execution of
  /// async task.
  ///
  /// It can be used to handle error i.e. show dialog with error message etc.
  FutureOr<void> onError(BuildContext context, error);

  /// This function is called after the async task is completed successfully.
  ///
  /// It can be used to reset the ui state to original (if changed by [before]
  /// method) i.e. closing dialog or removing waiting dialog.
  FutureOr<void> after(BuildContext context, [arguments]);
}

/// This service handle execution of an async task while updating application's
/// state at the same time, for each execution an [AsyncTaskBehaviour] is
/// required which determines how the application's state will be update during
/// execution.
///
/// If no [AsyncTaskBehaviour] is specified than a default implementation will
/// be used.
class AsyncTaskService {
  /// An instance of [AsyncTaskService] that uses [DefaultAsyncTaskBehaviour].
  static const $default = AsyncTaskService(const DefaultAsyncTaskBehaviour._());

  /// Creates an instance of [AsyncTaskService]
  const AsyncTaskService(this._behaviour);

  /// Executes [asyncTask] according to specified [AsyncTaskBehaviour].
  ///
  /// [context] is used to manipulate application's state i.e. navigating pages,
  /// using [InheritedWidget] etc.
  ///
  /// If [throwError] is set to true than error will rethrown after being handled
  /// by [AsyncTaskBehaviour.onError]
  Future<T> execute<T>(
    BuildContext context,
    AsyncTask<T> asyncTask, {
    dynamic arguments,
    bool throwError = false,
  }) async {
    late T result;

    try {
      await _behaviour.before(context);
      result = await asyncTask();
      await _behaviour.after(context);
    } catch (error) {
      await _behaviour.onError(context, error);
      if (throwError) rethrow;
    }

    return result;
  }

  final AsyncTaskBehaviour _behaviour;
}

/// A basic implementation of [AsyncTaskBehaviour] it is used by
/// [AsyncTaskService.$default].
///
/// It has setters that can be used to change default configurations for each
/// application.
class DefaultAsyncTaskBehaviour extends AsyncTaskBehaviour {
  /// Overrides the default `useSafeArea` option of [showDialog] by [value]
  set useSafeArea(bool value) => _config.useSafeArea = value;

  /// Overrides the default `barrierColor` option of [showDialog] by [value]
  set barrierColor(Color? value) => _config.barrierColor = value;

  /// Overrides the default `barrierLabel` option of [showDialog] by [value]
  set barrierLabel(String? value) => _config.barrierLabel = value;

  /// Overrides the default `useRootNavigator` option of [showDialog] by [value]
  set useRootNavigator(bool value) => _config.useRootNavigator = value;

  /// Overrides the default `barrierDismissible` option of [showDialog] by
  /// [value]
  set barrierDismissible(bool value) => _config.barrierDismissible = value;

  /// Overrides the default loadingBuilder by [builder]
  set loadingBuilder(Widget Function(BuildContext, dynamic) builder) {
    _loadingBuilder = builder;
  }

  /// Overrides the default errorBuilder by [builder]
  set errorBuilder(Widget Function(BuildContext, dynamic) builder) {
    _errorBuilder = builder;
  }

  @override
  FutureOr<void> after(BuildContext context, [arguments]) {
    Navigator.of(context).pop();
  }

  @override
  FutureOr<void> before(BuildContext context, [arguments]) {
    showDialog(
      context: context,
      useSafeArea: _config.useSafeArea,
      barrierLabel: _config.barrierLabel,
      barrierColor: _config.barrierColor,
      useRootNavigator: _config.useRootNavigator,
      barrierDismissible: _config.barrierDismissible,
      builder: (context) => _loadingBuilder(context, arguments),
    );
  }

  @override
  FutureOr<void> onError(BuildContext context, error) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => _errorBuilder(context, error),
    );
  }

  static Widget Function(BuildContext, dynamic) _errorBuilder =
      _defaultErrorViewBuilder;
  static Widget Function(BuildContext, dynamic) _loadingBuilder =
      _defaultLoadingViewBuilder;
  static final _config = _DefaultAsyncTaskBehaviourConfig();

  const DefaultAsyncTaskBehaviour._();
}

class _DefaultAsyncTaskBehaviourConfig {
  String? barrierLabel;

  bool useSafeArea = true;
  bool useRootNavigator = true;
  bool barrierDismissible = false;

  Color? barrierColor = Colors.black54;
}

Widget _defaultLoadingViewBuilder(BuildContext context, [arguments]) {
  assert(arguments is String, 'only `String` can be used as argument');

  return Dialog(
    child: Text(arguments),
  );
}

Widget _defaultErrorViewBuilder(BuildContext context, [error]) {
  return Dialog(
    child: Text(error.toString()),
  );
}
