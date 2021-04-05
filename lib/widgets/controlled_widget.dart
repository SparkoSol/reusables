import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A widget that gets bound to a [controller] of type [T] and rebuilds itself
/// everytime the [controller] triggers an event.
///
/// See Also,
/// * [Listenable] - A notifier that notifies each of its listener clients.
/// * [ValueListenable] - A notifier that notifies changes in single value.
/// * [ValueNotifier] - A concrete implementation of [ValueNotifier].
/// * [ChangeNotifier] - A concrete implementation of [Listenable].
///
/// ```dart
/// class DemoController extends ChangeNotifier {
///   String _name;
///   String get name;
///
///   set name(String value) {
///     _name = value;
///     notifyListener();
///   }
/// }
///
/// class DemoControlledWidget extends ControlledWidget<DemoController> {
///   /// User [controller] to trigger notification anywhere in application.
///   final controller = DemoController();
///
///   DemoControlledWidget() : super(controller);
///
///   DemoControllerWidgetState<DemoController> createState() =>
///       DemoControllerWidgetState<DemoController>();
/// }
///
/// class DemoControllerWidgetState
///     extends ControlledWidgetState<DemoController> {
///   @override
///   Widget build(BuildContext context) {
///     /// controller can be accessed form `widget`
///     return Text(widget.controller.text);
///   }
/// }
/// ```
abstract class ControlledWidget<T extends Listenable> extends StatefulWidget {
  final T controller;

  const ControlledWidget({Key? key, required this.controller})
      : super(key: key);

  /// Creates an instance of [ControlledWidgetState].
  @override
  ControlledWidgetState<ControlledWidget<T>> createState();
}

/// A state for [ControlledWidget].
///
/// It registers [rebuild] callback at initialization and unregisters it before
/// disposing-off.
abstract class ControlledWidgetState<T extends ControlledWidget>
    extends State<ControlledWidget> {
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
    widget.controller.addListener(rebuild);
    super.initState();
  }

  /// Unregisters [rebuild] as a notification listener from [widget.controller]
  /// before disposing-off widget state.
  @override
  @mustCallSuper
  void dispose() {
    widget.controller.removeListener(rebuild);
    super.dispose();
  }
}
