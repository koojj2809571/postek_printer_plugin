import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'postek_printer_plugin_method_channel.dart';

abstract class PostekPrinterPluginPlatform extends PlatformInterface {
  /// Constructs a PostekPrinterPluginPlatform.
  PostekPrinterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static PostekPrinterPluginPlatform _instance = MethodChannelPostekPrinterPlugin();

  /// The default instance of [PostekPrinterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelPostekPrinterPlugin].
  static PostekPrinterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PostekPrinterPluginPlatform] when
  /// they register themselves.
  static set instance(PostekPrinterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
