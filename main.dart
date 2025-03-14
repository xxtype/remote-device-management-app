import 'package:flutter/material.dart';
import 'package:ararj/device_manager.dart'; // Ensure this path is correct




void main() {
  runApp(RemoteDeviceApp());
}

class RemoteDeviceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DeviceManager(),
    );
  }
}
