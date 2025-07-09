part of 'postek_printer_plugin.dart';

class PostekPlugin extends PostekPlatform {
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
  Future<void> print(String printType, Map<String, dynamic> printData) {
    return methodChannel.invokeMethod<void>(
      "Print",
      {'PrintType': printType, 'PrintData': printData},
    );
  }

  @override
  EventChannel get event => eventChannel;
}
