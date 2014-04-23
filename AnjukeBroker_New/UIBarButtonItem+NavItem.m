//
//  UIBarButtonItem+NavItem.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-22.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "UIBarButtonItem+NavItem.h"
#import "Util_UI.h"

#define NAVBAR_IMG_H 24.0

@implementation UIBarButtonItem (NavItem)
+ (UIBarButtonItem *)getBackBarButtonItemForPresent:(id)taget action:(SEL)action{
    UIButton *btn = [self getButtonWithImg:nil highLightedImg:nil titleStr:@"取消" taget:taget action:action];

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return buttonItem;
}
+ (UIBarButtonItem *)getBarButtonItemWithString:(NSString *)titleStr taget:(id)taget action:(SEL)action{
    UIButton *btn = [self getButtonWithImg:nil highLightedImg:nil titleStr:titleStr taget:taget action:action];

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return buttonItem;
}
+ (UIBarButtonItem *)getBarButtonItemWithImage:(UIImage *)normalImg highLihtedImg:(UIImage *)highLihtedImg taget:(id)taget action:(SEL)action{
    UIButton *btn = [self getButtonWithImg:normalImg highLightedImg:highLihtedImg titleStr:nil taget:taget action:action];

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return buttonItem;
}
+ (UIBarButtonItem *)getBarSpace{
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10.0f;
    
    return spacer;
}

+ (UIBarButtonItem *)getBarSpaceMore{
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 10.0f;
    
    return spacer;
}

+ (UIButton *)getButtonWithImg:(UIImage *)normalImg highLightedImg:(UIImage *)highLightedImg titleStr:(NSString *)titleStr taget:(id)taget action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (normalImg) {
        CGSize size = normalImg.size;
        btn.frame = CGRectMake(0, 0, size.width, size.height);
        [btn setBackgroundImage:normalImg forState:UIControlStateNormal];
        [btn setBackgroundImage:highLightedImg forState:UIControlStateHighlighted];
    }else if (titleStr && titleStr.length > 0){
        btn.frame = CGRectMake(0, 0, 48, 24);
        [btn setTitle:titleStr forState:UIControlStateNormal];
        [btn setTitle:titleStr forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[Util_UI colorWithHexString:@"515762"] forState:UIControlStateHighlighted];
    }
    [btn addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

@end