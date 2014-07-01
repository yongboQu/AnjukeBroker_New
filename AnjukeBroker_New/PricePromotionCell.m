//
//  PricePromotionCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PricePromotionCell.h"

@interface PricePromotionCell ()

@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) UILabel* todayClickNumber; //今日点击
@property (nonatomic, strong) UILabel* todayClick;
@property (nonatomic, strong) UILabel* totalClickNumber; //总点击
@property (nonatomic, strong) UILabel* totalClick;
@property (nonatomic, strong) UILabel* unitNumber; //点击单价
@property (nonatomic, strong) UILabel* unit;

@end


@implementation PricePromotionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

#pragma mark -
#pragma mark UI相关

- (void)initCell {
    
    //房源图像
//    _propertyIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
//    _propertyIcon.backgroundColor = [UIColor clearColor];
//    _propertyIcon.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:_propertyIcon];
//    
//    //房源标题
//    _propertyTitle = [[UILabel alloc] initWithFrame:CGRectZero];
//    _propertyTitle.backgroundColor = [UIColor clearColor];
//    _propertyTitle.font = [UIFont ajkH2Font];
//    [_propertyTitle setTextColor:[UIColor brokerBlackColor]];
//    [self.contentView addSubview:_propertyTitle];
//    
//    //小区名称
//    _community = [[UILabel alloc] initWithFrame:CGRectZero];
//    _community.backgroundColor = [UIColor clearColor];
//    _community.font = [UIFont ajkH4Font];
//    _community.textColor = [UIColor brokerLightGrayColor];
//    [self.contentView addSubview:_community];
//    
//    //户型
//    _houseType = [[UILabel alloc] initWithFrame:CGRectZero];
//    _houseType.backgroundColor = [UIColor clearColor];
//    _houseType.font = [UIFont ajkH4Font];
//    [_houseType setTextColor:[UIColor brokerLightGrayColor]];
//    [self.contentView addSubview:_houseType];
//    
//    //面积
//    _area = [[UILabel alloc] initWithFrame:CGRectZero];
//    _area.backgroundColor = [UIColor clearColor];
//    _area.font = [UIFont ajkH4Font];
//    _area.textColor = [UIColor brokerLightGrayColor];
//    [self.contentView addSubview:_area];
//    
//    //租金或售价
//    _price = [[UILabel alloc] initWithFrame:CGRectZero];
//    _price.backgroundColor = [UIColor clearColor];
//    _price.font = [UIFont ajkH2Font];
//    [_price setTextColor:[UIColor brokerBlackColor]];
//    [self.contentView addSubview:_price];
    
    //cell的背景视图, 默认选中是蓝色
    //    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    //    backgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    //    self.selectedBackgroundView = backgroundView;
    
    self.contentView.backgroundColor = [UIColor brokerWhiteColor];
    
}


//加载数据
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //房源图片
//    _propertyIcon.frame = CGRectMake(15, 15, 80, 60);
//    NSString* iconPath = self.propertyDetailTableViewCellModel.imgURL;
//    if (iconPath != nil && ![@"" isEqualToString:iconPath]) {
//        //加载图片
//        [_propertyIcon setImageWithURL:[NSURL URLWithString:iconPath] placeholderImage:[UIImage imageNamed:@"anjuke61_bg4"]];
//    }else{
//        _propertyIcon.image = [UIImage imageNamed:@"anjuke61_bg4"]; //默认图片
//    }
//    
//    //房源标题
//    _propertyTitle.frame = CGRectMake(_propertyIcon.right + 12, 15, 190, 20);
//    _propertyTitle.text = self.propertyDetailTableViewCellModel.title;
//    //    _userName.backgroundColor = [UIColor redColor];
//    
//    
//    //小区名称
//    _community.frame = CGRectMake(_propertyIcon.right + 12, _propertyTitle.bottom + GAP_V, 100, 16);
//    _community.text = self.propertyDetailTableViewCellModel.commName;
//    //    _community.backgroundColor = [UIColor redColor];
//    //    [_community sizeToFit];
//    
//    //户型
//    _houseType.frame = CGRectMake(_propertyIcon.right + 12, _community.bottom + GAP_V, 100, 20);
//    _houseType.text = [NSString stringWithFormat:@"%@室%@厅%@卫", self.propertyDetailTableViewCellModel.roomNum, self.propertyDetailTableViewCellModel.hallNum, self.propertyDetailTableViewCellModel.toiletNum];
//    [_houseType sizeToFit];
//    
//    //面积
//    _area.frame = CGRectMake(_houseType.right + GAP_H, _community.bottom + GAP_V, 100, 20);
//    _area.text = self.propertyDetailTableViewCellModel.area;
//    [_area sizeToFit];
//    
//    //租金或售价
//    _price.frame = CGRectMake(_area.right + GAP_H, _community.bottom + GAP_V - 1, 70, 20);
//    _price.textAlignment = NSTextAlignmentRight;
//    _price.text = self.propertyDetailTableViewCellModel.price;
//    //    [_price sizeToFit];
//    //    _price.backgroundColor = [UIColor redColor];
    
}

@end
