import 'package:flutter/src/services/platform_channel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postek_printer_plugin/postek_printer_plugin.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPostekPrinterPluginPlatform
    with MockPlatformInterfaceMixin
    implements PostekPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> connectDevices(String printerAddress) {
    // TODO: implement connectDevices
    throw UnimplementedError();
  }

  @override
  Future<void> disconnected() {
    // TODO: implement disconnected
    throw UnimplementedError();
  }

  @override
  Future<void> print(String printType, Map<String, dynamic> printData) {
    // TODO: implement print
    throw UnimplementedError();
  }

  @override
  // TODO: implement event
  EventChannel get event => throw UnimplementedError();

  @override
  Future<void> scanDevices() {
    // TODO: implement scanDevices
    throw UnimplementedError();
  }
}

void main() {
  final PostekPlatform initialPlatform = PostekPlatform.instance;

  test('$PostekPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<PostekPlugin>());
  });

  test('getPlatformVersion', () async {
    PostekPrinterPlugin postekPrinterPlugin = PostekPrinterPlugin();
    MockPostekPrinterPluginPlatform fakePlatform =
        MockPostekPrinterPluginPlatform();
    PostekPlatform.instance = fakePlatform;

    expect(await postekPrinterPlugin.getPlatformVersion(), '42');
  });
}
