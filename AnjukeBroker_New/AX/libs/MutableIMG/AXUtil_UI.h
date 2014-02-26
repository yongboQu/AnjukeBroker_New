//
//  Util_UI.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-29.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYSTEM_BLUE [AXUtil_UI colorWithHexString:@"2087fc"]
#define SYSTEM_BLACK [AXUtil_UI colorWithHexString:@"333333"]
#define SYSTEM_LIGHT_GRAY [AXUtil_UI colorWithHexString:@"999999"]
#define SYSTEM_LIGHT_GRAY_BG [AXUtil_UI colorWithHexString:@"EFEFF4"]
#define SYSTEM_DARK_GRAY [AXUtil_UI colorWithHexString:@"666666"]
#define SYSTEM_GREEN [AXUtil_UI colorWithHexString:@"66cc00"]
#define SYSTEM_ORANGE [AXUtil_UI colorWithHexString:@"FF6600"]
#define SYSTEM_NAVIBAR_COLOR [AXUIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1]

#define SYSTEM_ZZ_RED [AXUIColor colorWithRed:0.93 green:0.24 blue:0.25 alpha:1]

#define BIG_BTN_RED [AXUIColor colorWithRed:0.93 green:0.24 blue:0.25 alpha:1]

@interface AXUtil_UI : NSObject

//动态Lable.text自适应的frame计算
+ (CGSize)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(int)fontSize;
+ (CGSize)sizeOfBoldString:(NSString *)string maxWidth:(float)width widthBoldFontSize:(int)fontSize;

// Base Image Fitting
+ (CGSize)fitSize: (CGSize)thisSize inSize: (CGSize) aSize;
+ (CGRect)frameSize: (CGSize)thisSize inSize: (CGSize) aSize;

+ (UIColor *)colorWithHexString: (NSString *)stringToConvert;

@end