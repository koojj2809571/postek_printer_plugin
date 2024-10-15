part of 'postek_printer_plugin.dart';

abstract class PostekPlatform extends PlatformInterface {

  PostekPlatform() : super(token: _token);

  static final Object _token = Object();

  static PostekPlatform _instance = PostekPlugin();

  static PostekPlatform get instance => _instance;

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
