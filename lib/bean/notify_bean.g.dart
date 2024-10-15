// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../postek_printer_plugin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifyBean _$NotifyBeanFromJson(Map<String, dynamic> json) => NotifyBean(
      type: json['type'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$NotifyBeanToJson(NotifyBean instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
    };
