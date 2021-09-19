import 'dart:async';
import 'package:flutter/material.dart';

///
abstract class Awaiter {
  ///
  set defaultBehaviour(AwaiterBehaviour behaviour) => _default = behaviour;

  ///
  static Future<T> await<T, U>(
    BuildContext context,
    Future<T> future, {
    U? arguments,
    AwaiterBehaviour? behaviour,
  }) async {
    behaviour ??= _default;
    if (behaviour == null) {
      throw 'No [AwaiterBehaviour] was specified, either pass a '
          '[AwaiterBehaviour] to `behaviour` parameter or use '
          '[defaultBehaviour] setter to set a default [AwaiterBehaviour]';
    }

    await behaviour.before(context, arguments);
    final result = await future;
    await behaviour.after(context, arguments);

    return result;
  }

  static AwaiterBehaviour? _default;
}

///
abstract class AwaiterBehaviour<T> {
  const AwaiterBehaviour();

  ///
  FutureOr<void> after(BuildContext context, T arguments);

  ///
  FutureOr<void> before(BuildContext context, T arguments);
}
