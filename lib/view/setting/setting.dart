import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _followSystemDark = false;
  final TextEditingController _controllerServerUrl = TextEditingController();
  final TextEditingController _controllerAPIKey = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _followSystemDark = prefs.getBool("followSystemDark") ?? false;
      _controllerServerUrl.text = prefs.getString("serverUrl") ?? '';
      _controllerAPIKey.text = prefs.getString("apiKey") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("关于"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'MCSM Panel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('基于MCSManager的Minecraft服务器管理工具'),
            // 功能1
            const SizedBox(height: 20),
            Card(
                child: Column(
              children: [
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: Text(
                        '设置',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                ListTile(
                    title: const Text('服务器地址'),
                    subtitle: const Text('例如：http://demo.url:23333/'),
                    onTap: () => showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              title: const Text("输入服务器地址"),
                              content: TextField(
                                controller: _controllerServerUrl,
                                onChanged: (value) {},
                                decoration: const InputDecoration(
                                  hintText: '务必完整输入端口和最后的/',
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('取消'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    setState(() {
                                      prefs.setString("serverUrl",
                                          _controllerServerUrl.text);
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: const Text('保存'),
                                ),
                              ],
                            )))),
                ListTile(
                    title: const Text('APIKey'),
                    subtitle: const Text('请向管理员索取，妥善保管'),
                    onTap: () => showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              title: const Text("输入APIKey"),
                              content: TextField(
                                controller: _controllerAPIKey,
                                onChanged: (value) {},
                                decoration: const InputDecoration(
                                  hintText: '妥善保管，防止泄漏',
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('取消'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    setState(() {
                                      prefs.setString(
                                          "apiKey", _controllerAPIKey.text);
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: const Text('保存'),
                                ),
                              ],
                            )))),
              ],
            )),
            const SizedBox(height: 20),
            Card(
                child: Column(
              children: [
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: Text(
                        '界面',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                ListTile(
                  title: const Text('跟随系统夜间模式'),
                  trailing: Switch(
                      value: _followSystemDark,
                      onChanged: (value) async {
                        final prefs = await SharedPreferences.getInstance();
                        setState(() {
                          _followSystemDark = value;
                          prefs.setBool('followSystemDark', value);
                        });
                      }),
                ),
              ],
            )),
            const SizedBox(height: 20),
            Card(
                child: Column(
              children: [
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: Text(
                        '其他',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const ListTile(
                  title: Text('版本'),
                  subtitle: Text('1.0.5'),
                ),
                ListTile(
                  title: const Text('关于'),
                  subtitle: const Text('摸了'),
                  onTap: () => showMessageDialog(context, "关于",
                      "使用Flutter重新构建的MCSM Panel\n\n换了Flutter之后摸的快多了（赞赏"),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

void showMessageDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('确定'),
          ),
        ],
      );
    },
  );
}
