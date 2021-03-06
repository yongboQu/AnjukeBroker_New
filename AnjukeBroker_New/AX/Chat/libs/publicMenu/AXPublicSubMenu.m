//
//  AXPublicSubMenu.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-13.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "AXPublicSubMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "BrokerLineView.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const axPublicSubMenuHeight = 45.0f;

@implementation AXPublicSubMenu
@synthesize publicSubMenuDelegate;
@synthesize subMenuindex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)configPublicSubMenu:(AXPublicMenuButton *)button menu:(NSArray *)menus{
    NSInteger menuCount = MIN(5, menus.count);
    
    CGRect rect = CGRectMake(0, 0, 100, 45*menuCount);
    self.frame = rect;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    view.backgroundColor = [UIColor brokerBgPageColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor brokerLineColor].CGColor;
    view.frame = rect;
    [self addSubview:view];
    
    CGPoint buttonPoint = CGPointMake(button.center.x, ScreenHeight - 20 -44 - 49 + 45*menuCount/2);
    self.center = buttonPoint;
    
    UIImageView *cornerView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 10, self.frame.size.height - 1, 19, 7)];
    [cornerView setImage:[UIImage imageNamed:@"wl_map_icon_4"]];
    [self addSubview:cornerView];
    
    //最后一项子菜单,定位调整
    if (button.center.x + self.frame.size.width/2 >= ScreenWidth) {
        CGPoint buttonPoint = CGPointMake(ScreenWidth - 58, ScreenHeight - 20 -44 - 49 + 45*menuCount/2);
        self.center = buttonPoint;
    }
    
    
    for (int i = 0; i < menuCount; i++) {
        AXPublicMenuButton *btn = [AXPublicMenuButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(subMenuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, i*axPublicSubMenuHeight, 100, axPublicSubMenuHeight);
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor brokerBgPageColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor brokerBgSelectColor  ]] forState:UIControlStateHighlighted];
        [btn setTitle:[menus objectAtIndex:i][@"menu_title"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor brokerBlackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont ajkH3Font];
        btn.index = i;
        btn.btnInfo = menus[i];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:btn];
    }
    
    for (int i = 0; i < menuCount; i++) {
        if (menuCount == 1 || i == menuCount -1 ) {
        }else{
            BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(8, (i+1)*axPublicSubMenuHeight, 84, 1)];
            line.horizontalLine = YES;
            [view addSubview:line];
        }
    }
}

- (void)subMenuBtnClick:(id)sender{
    AXPublicMenuButton *btn = (AXPublicMenuButton *)sender;
    
    if (!btn.btnInfo[@"menu_type"]) {
        return;
    }
    //api查询
    if ([btn.btnInfo[@"menu_type"] integerValue] == AXPublicSubMenuTypeAPI) {
        if (self.publicSubMenuDelegate && [self.publicSubMenuDelegate respondsToSelector:@selector(publicSubMenuWithAPI:actionStr:)]) {
            [self.publicSubMenuDelegate publicSubMenuWithAPI:btn actionStr:btn.btnInfo[@"action_id"]];
        }
    }
    //打开webView
    if ([btn.btnInfo[@"menu_type"] integerValue] == AXPublicSubMenuTypeWebView) {
        if (self.publicSubMenuDelegate && [self.publicSubMenuDelegate respondsToSelector:@selector(publicSubMenuWithURL:webURL:)]) {
            [self.publicSubMenuDelegate publicSubMenuWithURL:btn webURL:btn.btnInfo[@"webview_url"]];
        }
    }
    return;
}


@end
