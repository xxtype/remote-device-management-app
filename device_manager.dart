import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'device.dart';
import 'remote_control.dart';

class DeviceManager extends StatefulWidget {
  @override
  _DeviceManagerState createState() => _DeviceManagerState();
}

class _DeviceManagerState extends State<DeviceManager> {
  List<Device> devices = [
    Device(name: "Smart Light", status: false, battery: 100, brightness: 50, ip: "192.168.1.2"),
    Device(name: "Security Camera", status: true, battery: 80, brightness: 0, ip: "192.168.1.3"),
    Device(name: "Thermostat", status: false, battery: 95, brightness: 0, ip: "192.168.1.4"),
    Device(name: "Smart Lock", status: true, battery: 90, brightness: 0, ip: "192.168.1.5"),
    Device(name: "Wi-Fi Router", status: true, battery: 60, brightness: 0, ip: "192.168.1.6"),
  ];

  Timer? _batteryTimer;

  void toggleDevice(int index) async {
    setState(() {
      devices[index].status = !devices[index].status;
    });
    await sendRemoteCommand(devices[index].ip, {"status": devices[index].status ? "on" : "off"});
  }

  void adjustBrightness(int index, double value) async {
    setState(() {
      devices[index].brightness = value.toInt();
    });
    await sendRemoteCommand(devices[index].ip, {"brightness": devices[index].brightness});
  }

  void updateBatteryLevels() {
    setState(() {
      for (var device in devices) {
        device.battery = max(0, device.battery - Random().nextInt(5));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _batteryTimer = Timer.periodic(Duration(seconds: 5), (timer) => updateBatteryLevels());
  }

  @override
  void dispose() {
    _batteryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Remote Device Manager"), backgroundColor: Colors.blueAccent),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    devices[index].status ? Icons.power : Icons.power_off,
                    color: devices[index].status ? Colors.green : Colors.red,
                  ),
                  title: Text(devices[index].name, style: TextStyle(fontSize: 18)),
                  subtitle: Text("Battery: ${devices[index].battery}%\nIP: ${devices[index].ip}"),
                  trailing: Switch(
                    value: devices[index].status,
                    onChanged: (value) => toggleDevice(index),
                  ),
                ),
                if (devices[index].name == "Smart Light")
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Text("Brightness: ${devices[index].brightness}%"),
                        Slider(
                          value: devices[index].brightness.toDouble(),
                          min: 0,
                          max: 100,
                          divisions: 10,
                          label: "${devices[index].brightness}%",
                          onChanged: (value) => adjustBrightness(index, value),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Placeholder function for sendRemoteCommand
Future<void> sendRemoteCommand(String ip, Map<String, dynamic> command) async {
  print("Sending command to $ip: $command");
}
