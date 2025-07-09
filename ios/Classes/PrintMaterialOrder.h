#import <Foundation/Foundation.h>
@class PTKPrintSDK;

@interface PrintMaterialOrder : NSObject
+ (void)printWithSDK:(PTKPrintSDK *)sdk data:(NSDictionary *)data;
@end
