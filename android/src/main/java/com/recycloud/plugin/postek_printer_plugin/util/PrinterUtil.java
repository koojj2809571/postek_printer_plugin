package com.recycloud.plugin.postek_printer_plugin.util;

import static com.recycloud.plugin.postek_printer_plugin.util.BluetoothUtil.isBluetoothEnabled;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothProfile;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import com.feasycom.common.bean.ConnectType;
import com.feasycom.common.bean.FscDevice;
import com.google.gson.Gson;
import com.postek.cdfpsk.CDFPTKAndroid;
import com.postek.cdfpsk.CDFPTKAndroidImpl;
import com.postek.cdfpsk.bleCallback;
import com.postek.cdfpsk.sppCallback;
import com.recycloud.plugin.postek_printer_plugin.model.PrinterRow;
import com.recycloud.plugin.postek_printer_plugin.template.IPrintTemplate;
import com.recycloud.plugin.postek_printer_plugin.template.impl.PrintFixedAssets;
import com.recycloud.plugin.postek_printer_plugin.template.impl.PrintMaterialOrder;
import com.recycloud.plugin.postek_printer_plugin.template.impl.PrintMultipleColumn;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.os.Handler;

public class PrinterUtil {
    private final Activity activity;
    private CDFPTKAndroid cdf; // Remove final to allow reinitialization
    private final List<List<PrinterRow>> printData = new ArrayList<>();
    private final EventChannel.EventSink sink;

    private final BroadcastReceiver myBroadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            try {
                int blueState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, 0);
                handleBluetoothStateChange(blueState);
            } catch (Exception e) {
                Log.e("PrinterUtil", "Error in broadcast receiver: " + e.getMessage());
            }
        }
    };

    public PrinterUtil(Activity activity, EventChannel.EventSink sink) {
        this.activity = activity;
        this.sink = sink;
        this.cdf = null; // Initialize to null first
        
        try {
            if (activity != null) {
                this.cdf = new CDFPTKAndroidImpl(activity);
                initReceive();
            } else {
                Log.e("PrinterUtil", "Activity is null, cannot initialize printer");
            }
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error initializing printer: " + e.getMessage());
            this.cdf = null; // Ensure it's null on error
        }
    }

    public void scanDevices(){
        if (!isBluetoothEnabled()) {
            safeSendResult("bluetoothIsDisabled");
            return;
        }
        if (this.cdf == null) {
            safeSendResult("printerNotInitialized");
            return;
        }
        try {
            this.cdf.PTK_DisConnectBle();
            setCallback();
            this.cdf.PTK_StartScan();
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error scanning devices: " + e.getMessage());
            safeSendResult("scanError", e.getMessage());
        }
    }

    public void print(String printType, Map<String, String> printData){
        if (!isBluetoothEnabled()) {
            safeSendResult("bluetoothIsDisabled");
            return;
        }
        if (this.cdf == null) {
            safeSendResult("printerNotInitialized");
            return;
        }
        try {
            IPrintTemplate printer = null;
            switch (printType){
                case "FixedAssets":
                    printer = new PrintFixedAssets();
                    break;
                case "MaterialOrder":
                    printer = new PrintMaterialOrder(printData);
                    break;
                case "MultipleColumn":
                    printer = new PrintMultipleColumn();
                    break;
            }
            if (printer != null) {
                printer.print(this.cdf);
            }
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error printing: " + e.getMessage());
            safeSendResult("printError", e.getMessage());
        }
    }

    public void connectedBLE(MethodCall call){
        if (!isBluetoothEnabled()) {
            safeSendResult("bluetoothIsDisabled");
            return;
        }
        if (this.cdf == null) {
            safeSendResult("printerNotInitialized");
            return;
        }
        try {
            String address = call.argument("Address");
            if (isDeviceConnected(address)) {
//            cdf.PTK_DisConnectBle();
                safeSendResult("blePeripheralConnected");
            }else {
                this.cdf.PTK_ConnectBle(address);
            }
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error connecting to BLE: " + e.getMessage());
            safeSendResult("connectionError", e.getMessage());
        }
    }

    public void cleanup() {
        try {
            if (this.cdf != null) {
                this.cdf.PTK_DisConnectBle();
                this.cdf.PTK_StopScan();
            }
            if (activity != null) {
                try {
                    activity.unregisterReceiver(myBroadcastReceiver);
                } catch (IllegalArgumentException e) {
                    // Receiver was not registered, ignore
                }
            }
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error during cleanup: " + e.getMessage());
        }
    }

    public void disconnected(){
        try {
            if (this.cdf != null) {
                this.cdf.PTK_DisConnectBle();
                this.cdf.PTK_StopScan();
            }
            if (activity != null) {
                activity.unregisterReceiver(myBroadcastReceiver);
            }
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error disconnecting: " + e.getMessage());
        }
    }

    public boolean isDeviceConnected(String address) {
        try {
            if (activity == null) {
                return false;
            }
            BluetoothManager bluetoothManager = (BluetoothManager) activity.getSystemService(Context.BLUETOOTH_SERVICE);
            if (bluetoothManager == null) {
                return false;
            }
            List<BluetoothDevice> connectedDevices = bluetoothManager.getConnectedDevices(BluetoothProfile.GATT);
            for (BluetoothDevice device : connectedDevices) {
                if (device.getAddress().equals(address)) {
                    return true;
                }
            }
            return false;
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error checking device connection: " + e.getMessage());
            return false;
        }
    }

    public boolean isPrinterInitialized() {
        return this.cdf != null && activity != null;
    }

    public boolean reinitializePrinter() {
        try {
            if (activity != null) {
                // Clean up old instance if it exists
                if (this.cdf != null) {
                    try {
                        this.cdf.PTK_DisConnectBle();
                        this.cdf.PTK_StopScan();
                    } catch (Exception e) {
                        Log.e("PrinterUtil", "Error cleaning up old printer instance: " + e.getMessage());
                    }
                }
                
                // Create new instance
                this.cdf = new CDFPTKAndroidImpl(activity);
                initReceive();
                return true;
            }
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error reinitializing printer: " + e.getMessage());
            this.cdf = null; // Ensure it's null on error
        }
        return false;
    }

    public void handlePrinterUnavailable() {
        safeSendResult("printerUnavailable", "Printer is not available. Please check Bluetooth connection and try again.");
    }

    public boolean isBluetoothAvailable() {
        try {
            if (activity == null) {
                return false;
            }
            BluetoothManager bluetoothManager = (BluetoothManager) activity.getSystemService(Context.BLUETOOTH_SERVICE);
            return bluetoothManager != null && bluetoothManager.getAdapter() != null;
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error checking Bluetooth availability: " + e.getMessage());
            return false;
        }
    }

    public void handleBluetoothStateChange(int state) {
        try {
            if (state == BluetoothAdapter.STATE_ON) {
                // 开关蓝牙后，要停止扫瞄不然会导致无法立刻扫瞄到设备
                if (this.cdf != null) {
                    try {
                        this.cdf.PTK_StopScan();
                    } catch (Exception e) {
                        Log.e("PrinterUtil", "Error stopping scan: " + e.getMessage());
                    }
                }
                // Try to reinitialize if needed
                if (this.cdf == null && activity != null) {
                    reinitializePrinter();
                }
                
                // 蓝牙重新打开后，延迟一段时间自动开始扫描
                if (this.cdf != null && activity != null) {
                    new Handler().postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                if (isBluetoothEnabled() && isPrinterInitialized()) {
                                    Log.d("PrinterUtil", "Auto-starting scan after Bluetooth reconnection");
                                    // 先断开之前的连接
                                    cdf.PTK_DisConnectBle();
                                    // 设置回调
                                    setCallback();
                                    // 开始扫描
                                    cdf.PTK_StartScan();
                                    safeSendResult("autoScanStarted", "Auto scan started after Bluetooth reconnection");
                                }
                            } catch (Exception e) {
                                Log.e("PrinterUtil", "Error during auto scan: " + e.getMessage());
                            }
                        }
                    }, 2000); // 延迟2秒后开始扫描，确保蓝牙完全初始化
                }
            } else if (state == BluetoothAdapter.STATE_OFF) {
                // Bluetooth turned off, cleanup
                if (this.cdf != null) {
                    try {
                        this.cdf.PTK_DisConnectBle();
                        this.cdf.PTK_StopScan();
                    } catch (Exception e) {
                        Log.e("PrinterUtil", "Error during Bluetooth off cleanup: " + e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error handling Bluetooth state change: " + e.getMessage());
        }
    }

    private void initReceive() {
        try {
            if (activity != null) {
                IntentFilter intentFilter = new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED);
                activity.registerReceiver(myBroadcastReceiver, intentFilter);
            }
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error initializing receiver: " + e.getMessage());
        }
    }

    private void setCallback() {
        if (this.cdf == null) {
            Log.e("PrinterUtil", "CDF object is null, cannot set callbacks");
            return;
        }
        try {
            // Double-check cdf is not null before using it
            if (this.cdf == null) {
                Log.e("PrinterUtil", "CDF object became null, cannot set callbacks");
                return;
            }
            
            this.cdf.setCallbacks_BLE(new bleCallback() {
                @Override
                public void blePeripheralFound(FscDevice fscDevice, int i, byte[] bytes) {
                    if (fscDevice.getRssi() == 127) return;
                    try {
                        if (fscDevice.getName().contains("POSTEK") && fscDevice.getAddress().contains("DC:0D:30") || fscDevice.getAddress().contains("DD:0D:30")) {
                            activity.runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    Log.e("Tag","-------"+fscDevice.getName());
                                    Log.e("Tag","-------"+getResultStr("DEVICES_FOUND", fscDevice));
                                    safeSendResult("DEVICES_FOUND", fscDevice);
                                }
                            });

                        }
                    } catch (NullPointerException ignored) {

                    }
//                try {
//                    //Log.e("Tag",fscDevice.getName());
//                    if (fscDevice.getAddress().contains("DC:0D:30") || fscDevice.getAddress().contains("DD:0D:30")) {
//                Log.e("Tag","-------"+fscDevice.getName());
////                        AddDevice(fscDevice);
////                        sink.success(getResultStr("DEVICES_FOUND", fscDevice));
//
//                    }
//                } catch (NullPointerException ignored) {
//
//                }
                }

                @Override
                public void servicesFound(BluetoothGatt bluetoothGatt, String s, List<BluetoothGattService> list) {

                }

                @Override
                public void blePeripheralConnected(BluetoothGatt bluetoothGatt, String s, ConnectType connectType) {
                    super.blePeripheralConnected(bluetoothGatt, s, connectType);
                    safeSendResult("blePeripheralConnected", s);
                }

                @Override
                public void blePeripheralDisconnected(BluetoothGatt bluetoothGatt, String s, int i) {
                    super.blePeripheralDisconnected(bluetoothGatt, s, i);
                    safeSendResult("blePeripheralDisconnected", s);
                }

                @Override
                public void sendPacketProgress(String address, int percentage, byte[] data) {
                    super.sendPacketProgress(address, percentage, data);
                    activity.runOnUiThread(() -> {
                        safeSendResult("sendPacketProgress", percentage);
                    });
                }
            });

            this.cdf.setCallbacks_SPP(new sppCallback() {
                @Override
                public void sppPeripheralFound(FscDevice fscDevice, int i) {
//                uiFoundDevice(fscDevice);
                    try {
                        //Log.e("Tag",fscDevice.getName());
                        if (fscDevice.getAddress().contains("DC:0D:30") || fscDevice.getAddress().contains("DD:0D:30")) {
                            Log.e("Tag","1-------"+fscDevice.getName());
//                        AddDevice(fscDevice);
//                        sink.success(getResultStr("DEVICES_FOUND", fscDevice));

                        }
                    } catch (NullPointerException ignored) {

                    }
                }
            });
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error setting callbacks: " + e.getMessage());
        }
    }

    private String getResultStr(String type){
        return getResultStr(type, null);
    }
    private String getResultStr(String type, Object data){
        Map<String, Object> result = new HashMap<>();
        result.put("type", type);
        if (data != null) {
            result.put("data", data);
        }
        return new Gson().toJson(result);
    }

    private void safeSendResult(String type, Object data) {
        try {
            if (sink != null) {
                sink.success(getResultStr(type, data));
            }
        } catch (Exception e) {
            Log.e("PrinterUtil", "Error sending result: " + e.getMessage());
        }
    }

    private void safeSendResult(String type) {
        safeSendResult(type, null);
    }
}

