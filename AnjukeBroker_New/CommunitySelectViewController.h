//
//  CommunitySelectViewController.h
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-27.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "houseSelectViewController.h"
#import "HouseSelectCommunityCell.h"
#import "AppManager.h"
#import "LoginManager.h"
#import "PropertySelectViewController.h"

#define COMMUNITYSELECTCELLHEIGHT 65.0


typedef enum {
    secondHandHouse = 0,
    rentHouse
}pageTypeFrom;

@interface CommunitySelectViewController : HouseSelectViewController
@property (nonatomic,assign) pageTypeFrom pageTypeFrom;
@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
@end
