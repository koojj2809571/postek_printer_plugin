#import <Foundation/Foundation.h>
@class PTKPrintSDK;

@interface PrintFixedAssets : NSObject
+ (void)printWithSDK:(PTKPrintSDK *)sdk data:(NSDictionary *)data;
@end