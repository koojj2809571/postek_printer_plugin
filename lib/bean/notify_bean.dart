part of '../postek_printer_plugin.dart';

class NotifyBean{
  String? type;
  dynamic data;

  NotifyBean({this.type, this.data = const {}});

  factory NotifyBean.fromJson(String json){
    Map<String, dynamic> map = jsonDecode(json);
    return _$NotifyBeanFromJson(map);
  }

  Map<String, dynamic> toJson() => _$NotifyBeanToJson(this);
}