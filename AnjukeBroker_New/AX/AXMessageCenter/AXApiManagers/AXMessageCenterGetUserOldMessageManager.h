//
//  AXMessageCenterGetUserOldMessageManager.h
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-18.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "RTAPIBaseManager.h"

@interface AXMessageCenterGetUserOldMessageManager : RTAPIBaseManager<RTAPIManagerParamSourceDelegate,RTAPIManagerValidator>
@property (nonatomic, strong) NSDictionary *apiParams;
@end
