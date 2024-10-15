// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../postek_printer_plugin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevicesBean _$DevicesBeanFromJson(Map<String, dynamic> json) => DevicesBean(
      address: json['address'] as String?,
      completeLocalName: json['completeLocalName'] as String?,
      device: json['device'] == null
          ? null
          : Device.fromJson(json['device'] as Map<String, dynamic>),
      incompleteServiceUuiDs16Bit:
          json['incompleteServiceUuiDs16Bit'] as String?,
      manufacturerSpecificData: json['manufacturerSpecificData'] as String?,
      mode: json['mode'] as String?,
      name: json['name'] as String?,
      rssi: (json['rssi'] as num?)?.toInt(),
      scanRecord: (json['scanRecord'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DevicesBeanToJson(DevicesBean instance) =>
    <String, dynamic>{
      'address': instance.address,
      'completeLocalName': instance.completeLocalName,
      'device': instance.device,
      'incompleteServiceUuiDs16Bit': instance.incompleteServiceUuiDs16Bit,
      'manufacturerSpecificData': instance.manufacturerSpecificData,
      'mode': instance.mode,
      'name': instance.name,
      'rssi': instance.rssi,
      'scanRecord': instance.scanRecord,
    };

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      mAddress: json['mAddress'] as String?,
      mBluetoothBondCache: json['mBluetoothBondCache'] == null
          ? null
          : MBluetoothBondCache.fromJson(
              json['mBluetoothBondCache'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'mAddress': instance.mAddress,
      'mBluetoothBondCache': instance.mBluetoothBondCache,
    };

MBluetoothBondCache _$MBluetoothBondCacheFromJson(Map<String, dynamic> json) =>
    MBluetoothBondCache(
      mDisabled: json['mDisabled'] as bool?,
      mHits: (json['mHits'] as num?)?.toInt(),
      mLastSeenNonce: (json['mLastSeenNonce'] as num?)?.toInt(),
      mMaxEntries: (json['mMaxEntries'] as num?)?.toInt(),
      mMisses: (json['mMisses'] as num?)?.toInt(),
      mPropertyName: json['mPropertyName'] as String?,
    );

Map<String, dynamic> _$MBluetoothBondCacheToJson(
        MBluetoothBondCache instance) =>
    <String, dynamic>{
      'mDisabled': instance.mDisabled,
      'mHits': instance.mHits,
      'mLastSeenNonce': instance.mLastSeenNonce,
      'mMaxEntries': instance.mMaxEntries,
      'mMisses': instance.mMisses,
      'mPropertyName': instance.mPropertyName,
    };
