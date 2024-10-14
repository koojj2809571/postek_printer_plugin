import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'postek_printer_plugin_platform_interface.dart';

/// An implementation of [PostekPlatform] that uses method channels.
class PostekPlugin extends PostekPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('postek_printer_method_channel');
  final eventChannel = const EventChannel("postek_printer_event_channel");

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future scanDevices() {
    return methodChannel.invokeMethod("StartScan");
  }

  @override
  Future<void> connectDevices(String printerAddress) {
    return methodChannel.invokeMethod<void>(
      "ConnectDevices",
      {'Address': printerAddress},
    );
  }

  @override
  Future<void> disconnected() {
    return methodChannel.invokeMethod<void>("Disconnected");
  }

  @override
  Future<void> print(String printType) {
    return methodChannel.invokeMethod<void>(
      "Print",
      {'PrintType': printType},
    );
  }

  @override
  EventChannel get event => eventChannel;
}
