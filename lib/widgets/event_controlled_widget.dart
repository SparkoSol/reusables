import 'package:flutter/widgets.dart';

///
typedef EventListener<T> = Function(T event);

///
class EventNotifier<T> {
  ///
  void emit(T event) {
    for (final listener in _listeners) {
      listener(event);
    }
  }

  ///
  void addListener(EventListener<T> listener) => _listeners.add(listener);

  ///
  void removeListener(EventListener<T> listener) => _listeners.remove(listener);

  ///
  void dispose() => _listeners.clear();

  final _listeners = <EventListener<T>>[];
}

abstract class EventControlledWidget<T> extends StatefulWidget {
  const EventControlledWidget({Key? key, required this.notifier})
      : super(key: key);

  final EventNotifier<T> notifier;
}

mixin EventControlledState<T, U extends EventControlledWidget<T>> on State<U> {
  void onEvent(T event) {
  }

  /// This method is called whenever a notification is received from the
  /// `controller`. by default widget rebuilds itself on every notification.
  ///
  /// To get a conditional rebuild, override this method and call
  /// `super.rebuild()` to allow rebuild.
  @mustCallSuper
  void rebuild() => setState(() {});

  /// Registers [rebuild] as a notification listener to [widget.controller]
  /// before initializing widget state.
  @override
  @mustCallSuper
  void initState() {
    widget.notifier.addListener(onEvent);
    super.initState();
  }

  /// It will be called whenever the parent widget is rebuilt, it is necessary
  /// because sometimes [widget.controller] might change whenever the parent
  /// widget is rebuilt.
  @override
  void didUpdateWidget(covariant U oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update listeners if the controller is changed.
    if (oldWidget.notifier != widget.notifier) {
      widget.notifier.addListener(onEvent);
      oldWidget.notifier.removeListener(onEvent);
    }
  }

  /// Unregisters [rebuild] as a notification listener from [widget.controller]
  /// before disposing-off widget state.
  @override
  @mustCallSuper
  void dispose() {
    widget.notifier.removeListener(onEvent);
    super.dispose();
  }
}
