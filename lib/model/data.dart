class ServerStatSimple {
  int status;
  List<Data> data;
  int time;

  ServerStatSimple(
      {required this.status, required this.data, required this.time});
}

class Data {
  final String version;
  final Process process;
  final Instance instance;
  final System system;

  Data(
      {required this.version,
      required this.process,
      required this.instance,
      required this.system});
}

class Process {
  int cpu;
  int memory;
  String cwd;

  Process({required this.cpu, required this.memory, required this.cwd});
}

class Instance {
  int running;
  int total;

  Instance({required this.running, required this.total});
}

class System {
  String type;
  String hostname;
  String platform;
  String release;
  int uptime;
  String cwd;
  List<int> loadavg;
  int freemem;
  double cpuUsage;
  double memUsage;
  int totalmem;
  int processCpu;
  int processMem;

  System(
      {required this.type,
      required this.hostname,
      required this.platform,
      required this.release,
      required this.uptime,
      required this.cwd,
      required this.loadavg,
      required this.freemem,
      required this.cpuUsage,
      required this.memUsage,
      required this.totalmem,
      required this.processCpu,
      required this.processMem});
}
