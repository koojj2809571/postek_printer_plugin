import 'package:flutter/services.dart';

import 'postek_printer_plugin_platform_interface.dart';

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
