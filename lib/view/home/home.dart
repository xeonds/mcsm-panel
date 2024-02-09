import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mcsm_panel/model/data.dart';
import 'package:mcsm_panel/util/bar.dart';
import 'package:mcsm_panel/util/ring.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String apiUrl = 'api/service/remote_services_system';
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
  final List<Tab> myTabs = <Tab>[
    const Tab(text: '概览'),
    const Tab(text: '服务器'),
    const Tab(text: '账户'),
    const Tab(text: '文件'),
  ];

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }

  Future<void> fetchDataFromServer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = prefs.getString("serverUrl") ?? "http://demo.url/";
      final response = await http.get(Uri.parse(url + apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          responseData = json.decode(response.body);
        });
      } else {
        showErrorMessage();
      }
    } catch (e) {
      showErrorMessage();
    }
  }

  void showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('数据拉取失败'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(label: '确定', onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
            appBar: AppBar(
                title: const Text('MCSM Panel'),
                bottom: TabBar(
                  tabs: myTabs,
                  isScrollable: true,
                  indicatorColor: Theme.of(context).colorScheme.inversePrimary,
                  labelColor: Theme.of(context).colorScheme.inversePrimary,
                )),
            body: TabBarView(children: [
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Row(children: [
                    Text(
                      '服务器信息',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: responseData.data.length,
                    itemBuilder: (context, index) => _serverInfoWidget(
                        responseData.data[index].system.hostname,
                        responseData.data[index]),
                  ),
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Row(children: [
                    Text(
                      '服务器信息',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                  Container(
                    alignment: Alignment.center,
                    child: const Text("开发中"),
                  )
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Row(children: [
                    Text(
                      '账户',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                  Container(
                    alignment: Alignment.center,
                    child: const Text("开发中"),
                  )
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Row(children: [
                    Text(
                      '文件',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                  Container(
                    alignment: Alignment.center,
                    child: const Text("开发中"),
                  )
                ],
              ),
            ])));
  }

  Widget _serverInfoWidget(String serverName, Data data) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "服务器-$serverName",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: RingChart(
                              radius: 48,
                              strokeWidth: 8,
                              value: data.system.cpuUsage,
                              ringColor:
                                  Theme.of(context).colorScheme.background,
                              progressColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              text:
                                  "CPU ${(data.system.cpuUsage * 100).toInt()}%",
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "内存",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ProgressBar(
                                    value: data.system.memUsage,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    progressColor: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    width: 56,
                                    height: 8,
                                  ))
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoLine("守护进程版本号", data.version),
                          _buildInfoLine('平台', data.system.platform),
                          _buildInfoLine('启动时间', "${data.system.uptime}"),
                          _buildInfoLine('可用内存', "${data.system.freemem}"),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                style: const TextStyle(fontSize: 12),
              )),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
