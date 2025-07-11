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
import com.recycloud.plugin.postek_printer_plugin.model.PrinterRow;
import com.recycloud.plugin.postek_printer_plugin.template.IPrintTemplate;
import com.recycloud.plugin.postek_printer_plugin.template.impl.PrintFixedAssets;
import com.recycloud.plugin.postek_printer_plugin.template.impl.PrintMaterialOrder;
import com.recycloud.plugin.postek_printer_plugin.template.impl.PrintMultipleColumn;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.os.Handler;

public class PrinterUtil {
    private final Activity activity;
    private final CDFPTKAndroid cdf;
    private final List<List<PrinterRow>> printData = new ArrayList<>();
    private final EventChannel.EventSink sink;

    private final BroadcastReceiver myBroadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {

            int blueState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, 0);

            if (blueState == BluetoothAdapter.STATE_ON) {
                // 开关蓝牙后，要停止扫瞄不然会导致无法立刻扫瞄到设备
                cdf.PTK_StopScan();
            }
        }
    };

    public PrinterUtil(Activity activity, EventChannel.EventSink sink) {
        this.activity = activity;
        cdf = new CDFPTKAndroidImpl(activity);
        this.sink = sink;
        initReceive();
    }

    public void scanDevices(){
        if (!isBluetoothEnabled()) {
            sink.success(getResultStr("bluetoothIsDisabled"));
            return;
        }
        cdf.PTK_DisConnectBle();
        cdf.PTK_StartScan();
        setCallback();
    }

    public void print(String printType, Map<String, String> printData){
        if (!isBluetoothEnabled()) {
            sink.success(getResultStr("bluetoothIsDisabled"));
            return;
        }
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
            printer.print(cdf);
        }
    }

    public void connectedBLE(MethodCall call){
        if (!isBluetoothEnabled()) {
            sink.success(getResultStr("bluetoothIsDisabled"));
            return;
        }
        String address = call.argument("Address");
        if (isDeviceConnected(address)) {
//            cdf.PTK_DisConnectBle();
            sink.success(getResultStr("blePeripheralConnected"));
        }else {
            cdf.PTK_ConnectBle(address);
        }
    }

    public void disconnected(){
        cdf.PTK_DisConnectBle();
        activity.unregisterReceiver(myBroadcastReceiver);
        cdf.PTK_StopScan();
    }

    public boolean isDeviceConnected(String address) {
        BluetoothManager bluetoothManager = (BluetoothManager) activity.getSystemService(Context.BLUETOOTH_SERVICE);
        List<BluetoothDevice> connectedDevices = bluetoothManager.getConnectedDevices(BluetoothProfile.GATT);
        for (BluetoothDevice device : connectedDevices) {
            if (device.getAddress().equals(address)) {
                return true;
            }
        }
        return false;
    }

    private void initReceive() {
        IntentFilter intentFilter = new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED);
        activity.registerReceiver(myBroadcastReceiver, intentFilter);
    }

    private void setCallback() {
        cdf.setCallbacks(new bleCallback() {
            @Override
            public void blePeripheralFound(FscDevice fscDevice, int i, byte[] bytes) {
                if (fscDevice.getRssi() == 127) return;
                try {
                    if (fscDevice.getName().contains("POSTEK")) {
                        sink.success(getResultStr("DEVICES_FOUND", fscDevice));
                    }
                } catch (NullPointerException ignored) {

                }
            }

            @Override
            public void servicesFound(BluetoothGatt bluetoothGatt, String s, List<BluetoothGattService> list) {

            }

            @Override
            public void blePeripheralConnected(BluetoothGatt bluetoothGatt, String s, ConnectType connectType) {
                super.blePeripheralConnected(bluetoothGatt, s, connectType);
                sink.success(getResultStr("blePeripheralConnected", s));
            }

            @Override
            public void blePeripheralDisconnected(BluetoothGatt bluetoothGatt, String s, int i) {
                super.blePeripheralDisconnected(bluetoothGatt, s, i);
                sink.success(getResultStr("blePeripheralDisconnected", s));
            }

            @Override
            public void sendPacketProgress(String address, int percentage, byte[] data) {
                super.sendPacketProgress(address, percentage, data);
                activity.runOnUiThread(() -> {
                    sink.success(getResultStr("sendPacketProgress", percentage));
                });
            }
        });
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
}
