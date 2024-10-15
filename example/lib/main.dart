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
  bool canPrint = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    [Permission.location].request().then((result) {
      PermissionStatus? status = result[Permission.location];
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
        NotifyBean notify = NotifyBean.fromJson(event as String);
        switch (notify.type) {
          case 'DEVICES_FOUND':
            DevicesBean device = DevicesBean.fromJson(notify.data);
            bool exist = devices.any((e) => e.address == device.address);
            if (!exist) {
              devices.add(device);
              setState(() {});
            }
            break;
          case 'BlePeripheralConnected':
            print('BlePeripheralConnected: ${notify.data}');
            Fluttertoast.showToast(
              msg: "已连接打印机",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0,
            );
            setState(() {
              canPrint = true;
            });
            break;
          case 'blePeripheralDisconnected':
            print('blePeripheralDisconnected: ${notify.data}');
            break;
          case 'sendPacketProgress':
            print('sendPacketProgress: ${notify.data}');
            break;
        }
      },
      onError: (error) {
        print('error $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 1, width: double.infinity),
            Text('Running on: $_platformVersion\n'),
            _click("开始扫描", () {
              _printerPlugin.scanDevices();
            }),
            Expanded(
              flex: 1,
              child: ListView.separated(
                itemBuilder: (ctx, idx) {
                  DevicesBean item = devices[idx];
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(item.name ?? ''),
                            Text(item.address ?? ''),
                          ],
                        ),
                        const Expanded(flex: 1, child: SizedBox()),
                        _click("连接", () {
                          if (item.address == null || item.address!.isEmpty) return;
                          _printerPlugin.connectDevices(item.address!);
                        }),
                        const SizedBox(width: 20, height: 1),
                        if(canPrint)
                        _click("打印", () {
                          _printerPlugin.print("FixedAssets");
                        }),
                      ],
                    ),
                  );
                },
                separatorBuilder: (ctx, idx) {
                  return Container();
                },
                itemCount: devices.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _click(String text, void Function() click) {
    return InkWell(
      onTap: click,
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: const BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _printerPlugin.disconnected();
    super.dispose();
  }
}
