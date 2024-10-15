part of '../postek_printer_plugin.dart';

class DevicesBean {
  String? address;
  String? completeLocalName;
  Device? device;
  String? incompleteServiceUuiDs16Bit;
  String? manufacturerSpecificData;
  String? mode;
  String? name;
  int? rssi;
  List<int> scanRecord;

  DevicesBean({
    this.address,
    this.completeLocalName,
    this.device,
    this.incompleteServiceUuiDs16Bit,
    this.manufacturerSpecificData,
    this.mode,
    this.name,
    this.rssi,
    this.scanRecord = const [],
  });

  factory DevicesBean.fromJson(dynamic json){
    return _$DevicesBeanFromJson(json as Map<String, dynamic>? ?? {});
  }

  Map<String, dynamic> toJson() => _$DevicesBeanToJson(this);
}

class Device {
  String? mAddress;
  MBluetoothBondCache? mBluetoothBondCache;

  Device({
    this.mAddress,
    this.mBluetoothBondCache,
  });

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}

class MBluetoothBondCache {
  bool? mDisabled;
  int? mHits;
  int? mLastSeenNonce;
  int? mMaxEntries;
  int? mMisses;
  String? mPropertyName;

  MBluetoothBondCache({
    this.mDisabled,
    this.mHits,
    this.mLastSeenNonce,
    this.mMaxEntries,
    this.mMisses,
    this.mPropertyName,
  });

  factory MBluetoothBondCache.fromJson(Map<String, dynamic> json) => _$MBluetoothBondCacheFromJson(json);

  Map<String, dynamic> toJson() => _$MBluetoothBondCacheToJson(this);
}
