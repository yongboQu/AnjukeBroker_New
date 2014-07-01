//
//  PropertyDetailTableViewCellModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseModel.h"

@interface PropertyDetailTableViewCellModel : BaseModel

@property (nonatomic, copy) NSString* title; //房源标题
@property (nonatomic, copy) NSString* commId; //小区id
@property (nonatomic, copy) NSString* commName; //小区名称
@property (nonatomic, copy) NSString* roomNum; //室
@property (nonatomic, copy) NSString* hallNum; //厅
@property (nonatomic, copy) NSString* toiletNum; //卫生间
@property (nonatomic, copy) NSString* area; //面积
@property (nonatomic, copy) NSString* price; //价格
@property (nonatomic, copy) NSString* priceUnit; //价格单位
@property (nonatomic, copy) NSString* isMoreImg; //是否多图
@property (nonatomic, copy) NSString* isPhonePub; //是否手机发房
@property (nonatomic, copy) NSString* isVisible; //是否可见
@property (nonatomic, copy) NSString* publishMsg; //发布时间
@property (nonatomic, copy) NSString* imgURL;  //房源图片




@end
