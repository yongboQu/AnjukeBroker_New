//
//  LoginManager.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-5.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_DEFAULT_KEY_AXCHATMC_USE @"anjuke_chat_login_info"
#define USER_DEFAULT_KEY_DEVICE_TOKEN @"AJKNotificationToken" //device token

@interface LoginManager : NSObject

+ (void)setBusinessType:(NSString *)bT;
+ (NSString *)getBusinessType;//获得商业模式｛1:竞选2，精选｝

+ (BOOL)isLogin; //登录状态判断
+ (void)doLogout;

+ (NSString *)getUserName;
+ (NSString *)getUse_photo_url;
+ (NSString *)getUserID;
+ (NSString *)getCity_id;
+ (NSString *)getToken;
+ (NSString *)getName;
+ (NSString *)getPhone;

+ (NSString *)getChatID;
+ (NSString *)getChatToken;

+ (NSString *)getTwoCodeIcon;
+ (NSString *)getRealName;

+ (NSArray *)getCheckTimeArr;
+ (NSString *)getSignMile;

+ (BOOL)isSeedForAJK:(BOOL)isAJK; //是否是播种城市
+ (BOOL)needFileNOWithCityID:(NSString *)cityID; //发房是否需要备案号

+ (NSDictionary *)getFuckingChatUserDicJustForAnjukeTeam;
+ (NSDictionary *)getFuckingChatUserDicJustForAnjukeTeamWithPhone:(NSString *)phone uid:(NSString *)uid token:(NSString *)token;

+ (NSArray *)getClientCountAlertArray;

@end
