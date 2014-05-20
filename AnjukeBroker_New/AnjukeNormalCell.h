//
//  AnjukeNormalCell.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-28.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

@interface AnjukeNormalCell : RTListCell

@property (nonatomic, strong) UILabel *communityDetailLb;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLb;


- (UIView *)drawSpecView;

@end
