import 'dart:async';
import 'package:flutter/material.dart';

///
abstract class Awaiter {
  ///
  static set defaultBehaviour(AwaiterBehaviour behaviour) =>
      _default = behaviour;

  ///
  static Future<T> process<T, U>({
    U? arguments,
    required Future<T> future,
    AwaiterBehaviour? behaviour,
    required BuildContext context,
  }) async {
    behaviour ??= _default;
    if (behaviour == null) {
      throw 'No [AwaiterBehaviour] was specified, either pass a '
          '[AwaiterBehaviour] to `behaviour` parameter or use '
          '[defaultBehaviour] setter to set a default [AwaiterBehaviour]';
    }

    await behaviour.before(context, arguments);
    var result;
    try {
      result = await future;
      await behaviour.after(context);
    } catch (e) {
      await behaviour.after(context);
      rethrow;
    }

    return result;
  }

  static AwaiterBehaviour? _default;
}

///
abstract class AwaiterBehaviour<T> {
  const AwaiterBehaviour();

  ///
  FutureOr<void> after(BuildContext context);

  ///
  FutureOr<void> before(BuildContext context, T arguments);
}
