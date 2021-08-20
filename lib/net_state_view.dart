library net_state_view;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:net_state_view/widgets/def_widget_state.dart';

import 'widgets/iwidget_state.dart';

///
///自定义状态布局
///```
///StateView(
///      Container(
///        color: whiteColor,
///      ),
///      controller: StateViewController(),
///    );
///
///```
///
class NetStateView extends StatefulWidget {
  final Widget dataView;

  NetStateViewController controller = NetStateViewController.defalut();

  // final Widget? noneView;
  // final Widget? waitingView;
  // final Widget? errorView;
  // final Widget? emptyView;
  final IWidgetState? widgetState;

  NetStateView({
    required this.dataView,
    required this.controller,
    this.widgetState,
  });

  @override
  State<NetStateView> createState() => _NetStateViewState();
}

enum DoneState {
  none,
  error,
  empty,
  waiting,
  done,
}

class Done {
  final DoneState state;
  Done(this.state);

  static doneStateNone() => Done(DoneState.none);
  static doneStateWaiting() => Done(DoneState.waiting);
  static doneStateError() => Done(DoneState.error);
  static doneStateEmpty() => Done(DoneState.empty);
  static doneStateDone() => Done(DoneState.done);
}

class _NetStateViewState extends State<NetStateView> {
  @override
  void initState() {
    widget.controller._bindState(this);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Done>(
      builder: (BuildContext context, value, Widget? child) {
        return _rootView(context, value);
      },
      valueListenable: widget.controller._svn,
    );
  }

  _rootView(BuildContext context, Done done) {
    IWidgetState widgetState = widget.widgetState ?? DefWidgetState();
    var view = widgetState.buildEmpty();
    switch (done.state) {
      case DoneState.none:
        view = widgetState.buildNone();
        break;
      case DoneState.waiting:
        view = widgetState.buildWaiting();
        break;
      case DoneState.error:
        view = widgetState.buildError();
        break;
      case DoneState.empty:
        view = widgetState.buildEmpty();
        break;
      default:
        view = widget.dataView;
        break;
    }
    return view;
  }

}

class NetStateViewNotifier extends ValueNotifier<Done> {
  NetStateViewNotifier(Done? initDone)
      : super(initDone ?? Done.doneStateNone());

  // static defalut() => NetStateViewNotifier(null);
  static empty() => NetStateViewNotifier(Done(DoneState.empty));

  doneStateNone() => value = Done(DoneState.none);
  doneStateWaiting() => value = Done(DoneState.waiting);
  doneStateError() => value = Done(DoneState.error);
  doneStateEmpty() => value = Done(DoneState.empty);
  doneStateDone() => value = Done(DoneState.done);
}

class NetStateViewController {
  NetStateViewNotifier _svn = NetStateViewNotifier.empty();

  NetStateViewController({NetStateViewNotifier? def}) {
    if (null != def) {
      this._svn = def;
    }
  }

  static defalut() => NetStateViewController();

  _NetStateViewState? _netStateViewstate;

  _bindState(_NetStateViewState state) {
    assert(_netStateViewstate == null,
        "Don't use one StateViewController to multiple StateView,It will cause some unexpected bugs mostly in TabBarView");
    this._netStateViewstate = state;
  }

  void _dispose() {
    _netStateViewstate = null;
  }

  doneStateNone() => _svn.doneStateNone();
  doneStateWaiting() => _svn.doneStateWaiting();
  doneStateError() => _svn.doneStateError();
  doneStateEmpty() => _svn.doneStateEmpty();
  doneStateDone() => _svn.doneStateDone();
}
