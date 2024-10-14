import 'package:flutter_test/flutter_test.dart';
import 'package:postek_printer_plugin/postek_printer_plugin.dart';
import 'package:postek_printer_plugin/postek_printer_plugin_platform_interface.dart';
import 'package:postek_printer_plugin/postek_printer_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPostekPrinterPluginPlatform
    with MockPlatformInterfaceMixin
    implements PostekPrinterPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PostekPrinterPluginPlatform initialPlatform = PostekPrinterPluginPlatform.instance;

  test('$MethodChannelPostekPrinterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPostekPrinterPlugin>());
  });

  test('getPlatformVersion', () async {
    PostekPrinterPlugin postekPrinterPlugin = PostekPrinterPlugin();
    MockPostekPrinterPluginPlatform fakePlatform = MockPostekPrinterPluginPlatform();
    PostekPrinterPluginPlatform.instance = fakePlatform;

    expect(await postekPrinterPlugin.getPlatformVersion(), '42');
  });
}
