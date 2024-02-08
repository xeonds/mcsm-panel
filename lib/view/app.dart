import 'package:flutter/material.dart';
import 'package:mcsm_panel/view/home/home.dart';
import 'package:mcsm_panel/view/home/instance.dart';
import 'package:mcsm_panel/view/setting/setting.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const HomePage(),
    ProcessListPage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        height: 56,
        destinations: [
          PageInfo(
            index: 0,
            icon: Icons.home,
            iconSelected: Icons.home,
            label: '首页',
          ),
          PageInfo(
            index: 1,
            icon: Icons.task,
            iconSelected: Icons.task,
            label: '服务端',
          ),
          PageInfo(
            index: 2,
            icon: Icons.settings,
            iconSelected: Icons.settings,
            label: '设置',
          ),
        ]
            .map((e) =>
                NavigationDestination(icon: Icon(e.icon), label: e.label))
            .toList(),
        selectedIndex: _currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class PageInfo {
  final int index;
  final String label;
  final IconData icon;
  final IconData iconSelected;

  PageInfo({
    required this.index,
    required this.label,
    required this.icon,
    required this.iconSelected,
  });
}
