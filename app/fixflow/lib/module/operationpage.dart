// ignore_for_file: prefer_const_constructors

import 'package:fixflow/component/operationpage/current_candidateTaskList.dart';
import 'package:fixflow/component/operationpage/current_operationlist.dart';
import 'package:fixflow/component/operationpage/history_operationlist.dart';
import 'package:flutter/material.dart';

class OperatorPage extends StatefulWidget {
  const OperatorPage({super.key});

  @override
  State<OperatorPage> createState() => _OperatorPageState();
}

class _OperatorPageState extends State<OperatorPage> {
  int _selectedIndex = 0; // 默认选中第一个选项

  // 选项名称
  final List<String> _options = ['我的运维', '历史运维', '任务申领'];

  // 页面组件列表
  final List<Widget> _pages = [
    CurrentOperationListWidget(),
    HistoryOperationListWidget(),
    CurrentCandidateTaskList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_options[_selectedIndex]), // 显示选项名称
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Show popup menu
            showMenu<int>(
              context: context,
              position: RelativeRect.fromLTRB(0, kToolbarHeight, 0, 0),
              elevation: 8, // 菜单的阴影
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // 菜单的边角
              ),
              items: [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text('当前运维'),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text('历史运维'),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text('任务申领'),
                ),
              ],
            ).then((value) {
              if (value != null) {
                setState(() {
                  _selectedIndex = value;
                });
              }
            });
          },
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
