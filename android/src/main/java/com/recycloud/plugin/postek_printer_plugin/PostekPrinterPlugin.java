package com.recycloud.plugin.postek_printer_plugin;

import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;

import com.recycloud.plugin.postek_printer_plugin.util.BluetoothUtil;
import com.recycloud.plugin.postek_printer_plugin.util.PrinterUtil;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** PostekPrinterPlugin */
public class PostekPrinterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel methodChannel;
  private EventChannel eventChannel;
  private PrinterUtil printerUtil;
  private Activity activity;
  private EventChannel.EventSink sink;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    methodChannel = new MethodChannel(binding.getBinaryMessenger(), "postek_printer_method_channel");
    methodChannel.setMethodCallHandler(this);
    eventChannel = new EventChannel(binding.getBinaryMessenger(), "postek_printer_event_channel");
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    Log.e("打印插件", "onMethodCall: " + call.method);

    if (printerUtil == null || !printerUtil.isPrinterInitialized()) {
      result.success("{\"type\":\"error\",\"data\":\"Printer not initialized\"}");
      return;
    }

//    if (!BluetoothUtil.isBluetoothSupported()){
//      result.success("Bluetooth not supported");
//      return;
//    }
//
//    if (!BluetoothUtil.isBluetoothEnabled()){
//      boolean success = BluetoothUtil.turnOnBluetooth();
//      if (!success){
//        result.success("Bluetooth not supported");
//        return;
//      }
//    }

//    Log.e("打印插件", "onMethodCall: 蓝牙检查通过");

    try {
      switch (call.method){
        case "getPlatformVersion":
          result.success("Android " + android.os.Build.VERSION.RELEASE);
          break;
        case "StartScan":
          printerUtil.scanDevices();
          break;
        case "ConnectDevices":
          printerUtil.connectedBLE(call);
          break;
        case "Disconnected":
          printerUtil.disconnected();
          break;
        case "Print":
          Map<String, String> printData = (Map<String, String>)call.argument("PrintData");
          printerUtil.print(call.argument("PrintType"), printData);
          break;
        case "Reinitialize":
          if (printerUtil.reinitializePrinter()) {
            result.success("{\"type\":\"success\",\"data\":\"Printer reinitialized\"}");
          } else {
            result.success("{\"type\":\"error\",\"data\":\"Failed to reinitialize printer\"}");
          }
          break;
        case "GetStatus":
          if (printerUtil.isPrinterInitialized()) {
            result.success("{\"type\":\"success\",\"data\":\"Printer is initialized\"}");
          } else {
            result.success("{\"type\":\"error\",\"data\":\"Printer is not initialized\"}");
          }
          break;
        default:
          result.notImplemented();
          break;
      }
    } catch (Exception e) {
      Log.e("PostekPrinterPlugin", "Error in method call: " + e.getMessage());
      result.success("{\"type\":\"error\",\"data\":\"" + e.getMessage() + "\"}");
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    methodChannel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, EventChannel.EventSink events) {
        sink = events;
        printerUtil = new PrinterUtil(activity, sink);
      }

      @Override
      public void onCancel(Object arguments) {
        if (printerUtil != null) {
          printerUtil.cleanup();
        }
        sink = null;
        printerUtil = null;
      }
    });
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    if (printerUtil != null && !printerUtil.isPrinterInitialized()) {
      printerUtil.reinitializePrinter();
    }
  }

  @Override
  public void onDetachedFromActivity() {
    if (printerUtil != null) {
      printerUtil.cleanup();
    }
    printerUtil = null;
    activity = null;
  }
}
