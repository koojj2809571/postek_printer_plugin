import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'postek_printer_plugin_method_channel.dart';

abstract class PostekPlatform extends PlatformInterface {
  /// Constructs a PostekPrinterPluginPlatform.
  PostekPlatform() : super(token: _token);

  static final Object _token = Object();

  static PostekPlatform _instance = PostekPlugin();

  /// The default instance of [PostekPlatform] to use.
  ///
  /// Defaults to [MethodChannelPostekPrinterPlugin].
  static PostekPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PostekPlatform] when
  /// they register themselves.
  static set instance(PostekPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  EventChannel get event;

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future scanDevices() {
    throw UnimplementedError('connectDevices() has not been implemented.');
  }

  Future<void> connectDevices(String printerAddress) {
    throw UnimplementedError('connectDevices() has not been implemented.');
  }

  Future<void> disconnected() {
    throw UnimplementedError('connectDevices() has not been implemented.');
  }

  Future<void> print(String printType) {
    throw UnimplementedError('connectDevices() has not been implemented.');
  }
}
