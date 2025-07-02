// MyPluginPlugin.m
#import "PostekPrinterPlugin.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "PTKPrintSDK.h"
#import "MyPcxImageConverter.h"
#import "PrintFixedAssets.h"

@interface PostekPrinterPlugin() <FlutterStreamHandler, CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *discoveredPeripherals;
@property (nonatomic, strong) NSMutableArray *advertisementDatas;
@property (nonatomic, strong) NSMutableArray *RSSIs;

@property (nonatomic, strong) CBPeripheral *connectedPeripheral;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) CBCharacteristic *wrNoReCharacteristic;
@property (strong, nonatomic) PTKPrintSDK *ptkSDk;
@property (nonatomic, assign) BOOL isScanning;
@property (nonatomic, copy) FlutterEventSink eventSink;
@end

@implementation PostekPrinterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* methodChannel = [FlutterMethodChannel
      methodChannelWithName:@"postek_printer_method_channel"
            binaryMessenger:[registrar messenger]];
  FlutterEventChannel* eventChannel = [FlutterEventChannel
      eventChannelWithName:@"postek_printer_event_channel"
           binaryMessenger:[registrar messenger]];
  PostekPrinterPlugin* instance = [[PostekPrinterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:methodChannel];
  [eventChannel setStreamHandler:instance];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.discoveredPeripherals = [NSMutableArray array];
    self.advertisementDatas = [NSMutableArray array];
    self.RSSIs = [NSMutableArray array];
#if !TARGET_OS_SIMULATOR
    self.ptkSDk = [PTKPrintSDK sharedPTKPrintInstance];
#endif
    self.isScanning = NO;
  }
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {  
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([call.method isEqualToString:@"StartScan"]) {
    [self startScan];
    result(@"Scanning started");
  } else if ([call.method isEqualToString:@"StopScan"]) {
    [self stopScan];
    result(@"Scanning stopped");
  } else if ([call.method isEqualToString:@"ConnectDevices"]) {
    NSDictionary *args = call.arguments;
    NSString *deviceId = args[@"Address"];
    if (deviceId) {
      [self connectToDevice:deviceId];
      result([NSString stringWithFormat:@"Connecting to device: %@", deviceId]);
    } else {
      result([FlutterError errorWithCode:@"INVALID_ARGS" message:@"Device ID not provided" details:nil]);
    }
  } else if ([call.method isEqualToString:@"disconnected"]) {
    [self disconnectPeripheral];
    result(@"Disconnected");
  } else if ([call.method isEqualToString:@"Print"]) {
    NSDictionary *args = call.arguments;
    NSString *type = args[@"PrintType"] ?: @"";
#if TARGET_OS_SIMULATOR
    NSLog(@"PTKPrintSDK 不支持模拟器");
    result(@"PTKPrintSDK 不支持模拟器");
#else
    if ([type isEqualToString:@"FixedAssets"]) {
        [PrintFixedAssets printWithSDK:self.ptkSDk];
        result(@"Printed FixedAssets");
    } else if ([type isEqualToString:@"MaterialOrder"]) {
        // Handle MaterialOrder print type
    } else if ([type isEqualToString:@"MultipleColumn"]) {
        // Handle MultipleColumn print type
    } else {
        // Handle unknown print type
    }
#endif
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - FlutterStreamHandler
- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
  self.eventSink = events;
  return nil;
}
- (FlutterError *)onCancelWithArguments:(id)arguments {
  self.eventSink = nil;
  return nil;
}

#pragma mark - 蓝牙相关方法
- (void)startScan {
  [self disconnectPeripheral];
  [self.discoveredPeripherals removeAllObjects];
  [self.advertisementDatas removeAllObjects];
  [self.RSSIs removeAllObjects];
  self.isScanning = YES;
  [self.centralManager scanForPeripheralsWithServices:nil options:nil];
  if (self.eventSink) self.eventSink(@{ @"event": @"scan_started" });
}
- (void)stopScan {
  [self.centralManager stopScan];
  self.isScanning = NO;
  if (self.eventSink) self.eventSink(@{ @"event": @"scan_stopped" });
}
- (void)connectToDevice:(NSString *)deviceId {
  CBPeripheral *targetPeripheral = nil;
  for (NSInteger i = 0; i < self.discoveredPeripherals.count; i++) {
    CBPeripheral *peripheral = self.discoveredPeripherals[i];
    NSDictionary *advertisementData = self.advertisementDatas[i];
    NSString *localId = [[NSString alloc] initWithFormat:@"%@",[advertisementData[@"kCBAdvDataServiceUUIDs"] componentsJoinedByString:@","]];
    if ([localId isEqualToString:deviceId]) {
      targetPeripheral = peripheral;
      break;
    }
  }
  if (!targetPeripheral) {
    if (self.eventSink) self.eventSink(@{ @"type": @"blePeripheralDisconnected"});
    return;
  }
  if (self.isScanning) {
    [self stopScan];
  }
#if !TARGET_OS_SIMULATOR
  self.connectedPeripheral = targetPeripheral;
  _ptkSDk.mgr=self.centralManager;
  _ptkSDk.currPeripheral=self.connectedPeripheral;
  [_ptkSDk ConnectPreiPheral:self.centralManager andPeripheral:self.connectedPeripheral];
#else
  self.connectedPeripheral = targetPeripheral;
#endif
}
- (void)disconnectPeripheral {
  if (self.connectedPeripheral) {
    [self.centralManager cancelPeripheralConnection:self.connectedPeripheral];
  }
}
- (void)sendPrintCommandWithSDK:(NSData *)data {
  // 这里实现 SDK 打印命令的发送
}

#pragma mark - CBCentralManagerDelegate & CBPeripheralDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  if (central.state == CBManagerStatePoweredOn) {
    if (self.eventSink) self.eventSink(@{ @"event": @"bluetooth_on" });
  } else {
    if (self.eventSink) self.eventSink(@{ @"event": @"bluetooth_off", @"state": @(central.state) });
  }
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([RSSI integerValue]<-100 && [RSSI integerValue]>0) return;
    NSString *localName = advertisementData[CBAdvertisementDataLocalNameKey] ?: @"null";
    NSString *localId = [[NSString alloc] initWithFormat:@"%@",[advertisementData[@"kCBAdvDataServiceUUIDs"] componentsJoinedByString:@","]];
    NSNumber *localRSSI = RSSI;
   if ([localName hasPrefix:@"POS"]) {
    BOOL alreadyFound = NO;
    if ([self.discoveredPeripherals containsObject:peripheral]) {
        alreadyFound = YES;
    }
    if (!alreadyFound) {
        [self.discoveredPeripherals addObject:peripheral];
        [self.advertisementDatas addObject:advertisementData];
        [self.RSSIs addObject:RSSI];
        if (self.eventSink) {
//            NSMutableArray *devices = [NSMutableArray array];
//            for (NSInteger i = 0; i < self.discoveredPeripherals.count; i++) {
//                CBPeripheral *itemPeripheral = self.discoveredPeripherals[i];
//                NSDictionary *itemAdvertisementData = self.advertisementDatas[i];
//                NSString *localName = itemAdvertisementData[CBAdvertisementDataLocalNameKey] ?: @"null";
//                NSString *localId = [[NSString alloc] initWithFormat:@"%@",[itemAdvertisementData[@"kCBAdvDataServiceUUIDs"] componentsJoinedByString:@","]];
//                NSNumber *localRSSI = self.RSSIs[i];
//                [devices addObject:@{
//                    @"id": localId ?: @"null",
//                    @"name": itemPeripheral.name ?: localName,
//                    @"rssi": localRSSI
//                }];   
//            }
            self.eventSink(@{ @"type": @"DEVICES_FOUND", @"data": @{
                @"address": localId ?: @"null",
                @"name": localName ?: peripheral.name,
                @"rssi": ([localRSSI isKindOfClass:[NSNumber class]] ? @([localRSSI intValue]) : @0)
            }});
        }
    }
   }
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
  self.connectedPeripheral = peripheral;
  peripheral.delegate = self;
  [peripheral discoverServices:nil];
  if (self.eventSink) self.eventSink(@{ @"type": @"BlePeripheralConnected"});
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
  if (self.eventSink) self.eventSink(@{ @"type": @"blePeripheralDisconnected"});
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
  if (self.eventSink) self.eventSink(@{ @"type": @"blePeripheralDisconnected"});
  self.connectedPeripheral = nil;
  self.writeCharacteristic = nil;
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
  if (error) {
    if (self.eventSink) self.eventSink(@{ @"event": @"discover_services_failed", @"error": error.localizedDescription });
    return;
  }
  for (CBService *service in peripheral.services) {
    [peripheral discoverCharacteristics:nil forService:service];
  }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
  if (error) {
    if (self.eventSink) self.eventSink(@{ @"event": @"discover_characteristics_failed", @"error": error.localizedDescription });
    return;
  }
    NSLog(@"扫描到服务%@的%lu个特征", service.UUID.UUIDString, service.characteristics.count);
    NSString *services=service.UUID.UUIDString;
    // 遍历特征, 拿到需要的特征处理
    for (CBCharacteristic * characteristic in service.characteristics) {
        if (characteristic.properties & CBCharacteristicPropertyNotify || characteristic.properties & CBCharacteristicPropertyIndicate) {
            //拿到可读的特征了
            [self.connectedPeripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
#if !TARGET_OS_SIMULATOR
        if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse ){
            BOOL a=[services isEqual:@"18F0"];
            if (a) {
                //拿到可写的特征了
                if (!self.wrNoReCharacteristic)
                {
                    self.wrNoReCharacteristic = characteristic;
                    _ptkSDk.wrNoReCharacteristic=characteristic;
                }
            }
        }
#else
        if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse ){
            BOOL a=[services isEqual:@"18F0"];
            if (a) {
                if (!self.wrNoReCharacteristic)
                {
                    self.wrNoReCharacteristic = characteristic;
                }
            }
        }
#endif
        if (characteristic.properties & CBCharacteristicPropertyWrite){
            if (!self.writeCharacteristic) self.writeCharacteristic = characteristic;
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  if (error) {
    // 失败自动重试
//      [self.connectedPeripheral writeValue:self.sendData forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
  } else {
    if (self.eventSink) self.eventSink(@{ @"event": @"write_success" });
  }
}
@end
