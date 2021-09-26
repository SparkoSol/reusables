import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:reusables/reusables.dart';

typedef TimedWidgetBuilder = Function(BuildContext context, Duration time);

class TimedWidgetController extends ChangeNotifier {
  ///
  Duration get time {
    if (_isRunning) {
      return _time!;
    } else {
      throw 'Access this getter only when timer is running';
    }
  }

  ///
  bool get isRunning => _isRunning;

  ///
  void start(Duration period, [Duration? runFor]) {
    if (_timer != null) {
      throw 'a timer is active already stop the previous timer to start again';
    }

    _time = Duration();
    _isRunning = true;
    notifyListeners();

    if (runFor != null) {
      _timerFor = Timer(runFor, cancel);
    }

    _period = period;
    _timer = Timer.periodic(period, _notifyListeners);
  }

  ///
  void cancel() {
    _time = null;
    _period = null;

    if (_timerFor?.isActive == true) {
      _timerFor?.cancel();
      _timerFor = null;
    }

    if (_timer?.isActive == true) {
      _timer?.cancel();
      _timer = null;
    }

    _isRunning = false;
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

  void _notifyListeners(Timer _) {
    _time = _time! + _period!;
    notifyListeners();
  }

  Timer? _timer;
  Timer? _timerFor;
  Duration? _time;
  Duration? _period;

  var _isRunning = false;
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
      widget.builder(context, widget.controller.time);
}
