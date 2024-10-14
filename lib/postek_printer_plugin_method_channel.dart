import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'postek_printer_plugin_platform_interface.dart';

/// An implementation of [PostekPrinterPluginPlatform] that uses method channels.
class MethodChannelPostekPrinterPlugin extends PostekPrinterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('postek_printer_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
