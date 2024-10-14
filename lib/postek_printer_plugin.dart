
import 'postek_printer_plugin_platform_interface.dart';

class PostekPrinterPlugin {
  Future<String?> getPlatformVersion() {
    return PostekPrinterPluginPlatform.instance.getPlatformVersion();
  }
}
