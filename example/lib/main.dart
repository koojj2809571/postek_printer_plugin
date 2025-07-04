import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:postek_printer_plugin/postek_printer_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _printerPlugin = PostekPrinterPlugin();
  List<DevicesBean> devices = [];
  // bool canPrint = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect
    ].request().then((result) {
      // Handle permissions result
      bool allGranted = result.values.every((status) => status.isGranted);
      if (allGranted) {
        // Start scanning when permissions are granted
        // _printerPlugin.scanDevices();
      } else {
        Fluttertoast.showToast(
          msg: "需要蓝牙权限来扫描设备",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    });
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _printerPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    _printerPlugin.event.receiveBroadcastStream().listen(
      (event) {
        if (event is String) {
          NotifyBean notify = NotifyBean.fromJson(event);
          switch (notify.type) {
            case 'DEVICES_FOUND':
              DevicesBean device = DevicesBean.fromJson(notify.data);
              bool exist = devices.any((e) => e.address == device.address);
              if (!exist) {
                setState(() {
                  devices.add(device);
                });
              }
              break;
            case 'blePeripheralConnected':
              print('blePeripheralConnected: ${notify.data}');
              setState(() {
                devices
                    .firstWhere((e) => e.address == notify.data)
                    .isConnected = true;
              });
              Fluttertoast.showToast(
                msg: "打印机已连接",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
              break;
            case 'blePeripheralDisconnected':
              print('blePeripheralDisconnected: ${notify.data}');
              setState(() {
                devices
                    .firstWhere((e) => e.address == notify.data)
                    .isConnected = false;
              });
              Fluttertoast.showToast(
                msg: "打印机已断开连接",
                toastLength: Toast.LENGTH_SHORT,
              );
              break;
            case 'sendPacketProgress':
              print('sendPacketProgress: ${notify.data}');
              break;
            case 'bluetoothIsDisabled':
              Fluttertoast.showToast(
                msg: "蓝牙已关闭,请打开蓝牙",
                toastLength: Toast.LENGTH_SHORT,
              );
              break;
          }
        }
      },
      onError: (error) {
        print('Error: $error');
        Fluttertoast.showToast(
          msg: "发生错误: $error",
          toastLength: Toast.LENGTH_SHORT,
        );
      },
    );
  }

  void _printSampleText() {
    bool canPrint = devices.any((e) => e.isConnected);
    if (!canPrint) {
      Fluttertoast.showToast(
        msg: "请先连接打印机",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    // 打印示例文本
    _printerPlugin.print("FixedAssets");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Postek打印机示例'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Text('运行平台: $_platformVersion\n'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton("扫描设备", () {
                  setState(() {
                    devices.clear();
                  });
                  _printerPlugin.scanDevices();
                }),
                if (devices.any((e) => e.isConnected))
                  _buildButton("打印测试", _printSampleText),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(device.name ?? "未知设备"),
                      subtitle: Text(device.address ?? "无地址"),
                      trailing: ElevatedButton(
                        onPressed: () {
                          if (device.address != null) {
                            _printerPlugin.connectDevices(device.address!);
                          }
                        },
                        child: Text(device.isConnected ? "已连接" : "连接"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  @override
  void dispose() {
    _printerPlugin.disconnected();
    super.dispose();
  }
}
