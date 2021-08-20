import 'package:flutter/cupertino.dart';

abstract class IWidgetState {
  Widget buildNone();
  Widget buildWaiting();
  Widget buildError();
  Widget buildEmpty();
}
