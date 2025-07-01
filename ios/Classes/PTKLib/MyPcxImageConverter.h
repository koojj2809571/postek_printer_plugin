//
//  PcxImageConverter.h
//  ptkDemo
//
//  Created by SDP-MAC on 2017/9/30.
//  Copyright © 2017年 Postek. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PcxImageConverter : NSObject
+(NSData* )convertToPcx:(NSArray*) arrContent withFont: (UIFont *)font andShowStyle:(BOOL)bShowStyle;
@end
