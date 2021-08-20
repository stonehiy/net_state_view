library net_state_view;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  final Widget? noneView;
  final Widget? waitingView;
  final Widget? errorView;
  final Widget? emptyView;

  NetStateView({
    required this.dataView,
    required this.controller,
    this.noneView,
    this.waitingView,
    this.errorView,
    this.emptyView,
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
    // Done done = don ?? Done(DoneState.none);
    var view = widget.noneView ?? _buildEmpty(context);
    switch (done.state) {
      case DoneState.none:
        view = widget.noneView ?? _buildEmpty(context);
        break;
      case DoneState.waiting:
        view = widget.waitingView ?? _buildEmpty(context);
        break;
      case DoneState.error:
        view = widget.errorView ?? _buildEmpty(context);
        break;
      case DoneState.empty:
        view = widget.emptyView ?? _buildEmpty(context);
        break;
      default:
        view = widget.dataView;
        break;
    }
    return view;
  }

  _buildEmpty(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Icon(
              Icons.hourglass_empty,
              color: Colors.grey,
              size: 100,
            ),
          ),
          Container(
            child: Text(
              "暂无数据",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
    );
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
