import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:reusables/reusables.dart';

typedef TimedWidgetBuilder = Function(BuildContext context, int tick);

class TimedWidgetController extends ChangeNotifier {
  Timer? _timer;
  Timer? _timerFor;

  void start(Duration period, [Duration? runFor]) {
    if (_timer != null) {
      throw 'a timer is active already stop the previous timer to start again';
    }

    if (runFor != null) {
      _timerFor = Timer(runFor, cancel);
    }

    _timer = Timer.periodic(period, _notifyListeners);
  }

  void cancel() {
    if (_timerFor?.isActive == true) {
      _timerFor?.cancel();
      _timerFor = null;
    }

    if (_timer?.isActive == true) {
      _timer?.cancel();
      _timer = null;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
      _timer = null;
    }
    super.dispose();
  }

  void _notifyListeners(Timer _) => notifyListeners();
}

class TimedWidget extends ControlledWidget<TimedWidgetController> {
  const TimedWidget({
    Key? key,
    required this.builder,
    required TimedWidgetController controller,
  }) : super(key: key, controller: controller);

  final TimedWidgetBuilder builder;

  @override
  _TimedWidgetState createState() => _TimedWidgetState();
}

class _TimedWidgetState extends State<TimedWidget> with ControlledStateMixin {
  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.controller._timer?.tick ?? 0);
}
