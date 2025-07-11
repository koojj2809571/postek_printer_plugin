import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postek_printer_plugin/postek_printer_plugin.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  PostekPlugin platform = PostekPlugin();
  const MethodChannel channel = MethodChannel('postek_printer_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
