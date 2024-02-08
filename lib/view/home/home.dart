import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mcsm_panel/model/data.dart';
import 'package:mcsm_panel/util/ring.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String serverUrl = '';
  TextEditingController serverUrlController = TextEditingController();
  ServerStatSimple responseData = ServerStatSimple(
      status: 200,
      data: [
        Data(
            version: "1.3.0",
            process: Process(
                cpu: 5625000,
                memory: 132437320,
                cwd: "D:\\Workspace\\MCSM\\MCSManager-Daemon"),
            instance: Instance(running: 1, total: 6),
            system: System(
                type: "type",
                hostname: "hostname",
                platform: "platform",
                release: "release",
                uptime: 1234,
                cwd: "cwd",
                loadavg: [1, 2, 3],
                freemem: 123,
                cpuUsage: 0.1243,
                memUsage: 0.1234,
                totalmem: 1234,
                processCpu: 12,
                processMem: 1234)),
        Data(
            version: "1.3.0",
            process: Process(
                cpu: 5625000,
                memory: 132437320,
                cwd: "D:\\Workspace\\MCSM\\MCSManager-Daemon"),
            instance: Instance(running: 1, total: 6),
            system: System(
                type: "type",
                hostname: "hostname",
                platform: "platform",
                release: "release",
                uptime: 1234,
                cwd: "cwd",
                loadavg: [1, 2, 3],
                freemem: 123,
                cpuUsage: 0.1243,
                memUsage: 0.1234,
                totalmem: 1234,
                processCpu: 12,
                processMem: 1234)),
        Data(
            version: "1.3.0",
            process: Process(
                cpu: 5625000,
                memory: 132437320,
                cwd: "D:\\Workspace\\MCSM\\MCSManager-Daemon"),
            instance: Instance(running: 1, total: 6),
            system: System(
                type: "type",
                hostname: "hostname",
                platform: "platform",
                release: "release",
                uptime: 1234,
                cwd: "cwd",
                loadavg: [1, 2, 3],
                freemem: 123,
                cpuUsage: 0.1243,
                memUsage: 0.1234,
                totalmem: 1234,
                processCpu: 12,
                processMem: 1234))
      ],
      time: 1643879914006);

  @override
  void initState() {
    super.initState();
    serverUrl = 'https://example.com/api/service/remote_services_system';
    fetchDataFromServer();
  }

  Future<void> fetchDataFromServer() async {
    try {
      final response = await http.get(Uri.parse(serverUrl));
      if (response.statusCode == 200) {
        setState(() {
          responseData = json.decode(response.body);
        });
      } else {
        hideResponseData();
        showErrorMessage();
      }
    } catch (e) {
      hideResponseData();
      showErrorMessage();
    }
  }

  void hideResponseData() {
    setState(() {});
  }

  void showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('数据拉取失败'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MCSM Panel'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Row(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Text(
                  '服务器信息',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: responseData.data.length,
              itemBuilder: (context, index) => _serverInfoWidget(
                  responseData.data[index].system.hostname,
                  responseData.data[index]),
            ),
          ],
        ));
  }

  Widget _serverInfoWidget(String serverName, Data data) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "服务器-$serverName",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCircularChart("CPU", data.system.cpuUsage),
                    _buildCircularChart('Memory', data.system.memUsage),
                  ],
                ),
                _buildInfoLine("守护进程版本号", data.version),
                _buildInfoLine('平台', data.system.platform),
                _buildInfoLine('启动时间', "${data.system.uptime}"),
                _buildInfoLine('可用内存', "${data.system.freemem}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularChart(String title, double value) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RingChart(
              radius: 48,
              strokeWidth: 8,
              value: value,
              ringColor: Colors.white,
              progressColor: Colors.greenAccent,
              text: "${value * 100}%",
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ));
  }

  Widget _buildInfoLine(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              )),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
