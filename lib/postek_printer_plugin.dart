library postek_printer_plugin;

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'dart:convert';

part 'postek_printer_plugin_method_channel.dart';
part 'postek_printer_plugin_platform_interface.dart';
part 'bean/notify_bean.dart';
part 'bean/notify_bean.g.dart';
part 'bean/devices_bean.dart';
part 'bean/devices_bean.g.dart';

class PostekPrinterPlugin {

  EventChannel get event => PostekPlatform.instance.event;

  Future<String?> getPlatformVersion() {
    return PostekPlatform.instance.getPlatformVersion();
  }

  Future scanDevices() {
    return PostekPlatform.instance.scanDevices();
  }

  Future<void> connectDevices(String printerAddress) {
    return PostekPlatform.instance.connectDevices(printerAddress);
  }

  Future<void> disconnected() {
    return PostekPlatform.instance.disconnected();
  }

  Future<void> print(String printType) {
    return PostekPlatform.instance.print(printType);
  }
}
