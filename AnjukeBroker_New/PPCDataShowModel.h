//
//  PPCDataPricingModel.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPCDataShowModel : NSObject
@property(nonatomic, strong) NSNumber *todayClickNum;
@property(nonatomic, strong) NSString *todayCostFee;
@property(nonatomic, strong) NSNumber *houseNum;

+ (PPCDataShowModel *)convertToMappedObject:(NSDictionary *)dic;

@end
