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
  String apiOverview = 'api/overview';
  String apiRemoteServices = 'api/service/remote_services_system';
  String apiSettings = '/api/overview/setting';
  String apiUserCreate = 'api/auth';
  String apiUsers = 'api/overview';
  String apiUserSearch = 'api/auth/search';
  String apiUserUpdateSelf = 'api/auth/update';
  String apiRemoteServicesNew = 'api/service/remote_services';
  String apiRemoteServicesList = 'api/service/remote_services_list';
  String apiLinkRemoteService = 'api/service/link_remote_service';
  String apiInstance = 'api/instance';
  String apiRemoteServiceInstance = 'api/service/remote_service_instances';
  String apiStartInstance = 'api/protected_instance/open';
  String apiStopInstance = 'api/protected_instance/stop';
  String apiKillInstance = 'api/protected_instance/kill';
  String apiRestartInstance = 'api/protected_instance/restart';
  String apiSendCommandInstance = 'api/protected_instance/command';
  String apiGetInstanceLog = 'api/protected_instance/outputlog';
  String apiGetInstanceConfig = 'api/protected_instance/process_config/list';
  String apiUpdateInstanceConfig = 'api/protected_instance/process_config/file';
  String apiInstanceFileList = 'api/files/list';
  String apiInstanceFile = 'api/files';
  String apiInstanceFileCompress = 'api/files/compress';
  String apiInstanceFileCopy = 'api/files/copy';
  String apiInstanceMkdir = 'api/files/mkdir';
  String apiInstanceMoveFile = 'api/files/move';
  String apiInstanceUploadFile = 'api/files/upload';
  String apiInstanceDownloadFile = 'api/files/download';
  String apiCreateSchedule = 'api/protected_schedule';
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
    const Tab(text: '进程'),
    const Tab(text: '账户'),
  ];
  List<Map<String, dynamic>> instanceData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }

  Future<void> fetchDataFromServer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = prefs.getString("serverUrl") ?? "http://demo.url/";
      final apiKey = prefs.getString("apiKey") ?? "";
      final response = await http
          .get(Uri.parse(url + apiRemoteServices), headers: {'apikey': apiKey});
      final response2 =
          await http.get(Uri.parse('$url$apiOverview?apikey=$apiKey'));
      if (response.statusCode == 200 && response2.statusCode == 200) {
        setState(() {
          responseData = json.decode(response.body);
          instanceData = json.decode(response2.body);
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
                      '服务器',
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
                  const Row(children: [
                    Text(
                      '进程',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: instanceData.length,
                    itemBuilder: (context, index) =>
                        _instanceInfoWidget(instanceData),
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

  Widget _instanceInfoWidget(List<Map<String, dynamic>> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.map((info) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info['title'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info['value'] ?? '',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
