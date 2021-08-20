import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:net_state_view/widgets/iwidget_state.dart';

class DefWidgetState extends IWidgetState {
  @override
  Widget buildEmpty() => _buildEmpty();

  @override
  Widget buildError() => _buildError();

  @override
  Widget buildNone() => _buildEmpty();

  @override
  Widget buildWaiting() => _buildWaiting();

  _buildError() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Icon(
              Icons.error,
              color: Colors.redAccent,
              size: 100,
            ),
          ),
          Container(
            child: Text(
              "Error View",
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

  _buildEmpty() {
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

  _buildWaiting() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
              backgroundColor: Colors.blue,
              // value: 0.2,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
          Container(
            child: Text(
              "加载中...",
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
