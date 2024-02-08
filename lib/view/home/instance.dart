import 'package:flutter/material.dart';

class ProcessListPage extends StatelessWidget {
  final List<Process> processes = [
    Process(name: 'Process 1', resourceUsage: '30%'),
    Process(name: 'Process 2', resourceUsage: '20%'),
    Process(name: 'Process 3', resourceUsage: '10%'),
    // Add more processes as needed
  ];

  ProcessListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('进程列表'),
      ),
      body: ListView.builder(
        itemCount: processes.length,
        itemBuilder: (BuildContext context, int index) {
          return LongPressMenu(
            process: processes[index],
            onTap: () {
              // Navigate to process detail page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProcessDetailPage(process: processes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Process {
  final String name;
  final String resourceUsage;

  Process({required this.name, required this.resourceUsage});
}

class LongPressMenu extends StatelessWidget {
  final Process process;
  final VoidCallback onTap;

  const LongPressMenu({super.key, required this.process, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(0, 0, 0, 0),
          items: [
            PopupMenuItem(
              child: const Text('重启'),
              onTap: () {
                // Handle restart action
              },
            ),
            PopupMenuItem(
              child: const Text('启动'),
              onTap: () {
                // Handle start action
              },
            ),
            PopupMenuItem(
              child: const Text('停止'),
              onTap: () {
                // Handle stop action
              },
            ),
            PopupMenuItem(
              child: const Text('强制结束'),
              onTap: () {
                // Handle kill action
              },
            ),
          ],
        );
      },
      onTap: onTap,
      child: ListTile(
        title: Text(process.name),
        subtitle: Text('Resource Usage: ${process.resourceUsage}'),
      ),
    );
  }
}

class ProcessDetailPage extends StatelessWidget {
  final Process process;

  const ProcessDetailPage({super.key, required this.process});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('进程详情'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Process Name: ${process.name}'),
            Text('Resource Usage: ${process.resourceUsage}'),
            // Add more details about the process
          ],
        ),
      ),
    );
  }
}
