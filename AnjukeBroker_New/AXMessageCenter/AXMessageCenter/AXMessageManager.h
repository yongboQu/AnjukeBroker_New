//
//  AIFMessageManager.h
//  AVDemo
//
//  Created by 孟 智 on 1/22/14.
//  Copyright (c) 2014 孟 智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHttpRequest.h"
#import "ASIFormDataRequest.h"

typedef NS_ENUM(NSInteger, AIF_MESSAGE_REQUEST_REGISTER_STATUS)
{
    AIF_MESSAGE_REQUEST_REGISTER_NONE,
    AIF_MESSAGE_REQUEST_REGISTER_STARTED,
    AIF_MESSAGE_REQUEST_REGISTER_FINISHED,
    AIF_MESSAGE_REQUEST_REGISTER_FAILED
};

typedef NS_ENUM(NSInteger, AIF_MESSAGE_REQUEST_TAG_TYPE)
{
    AIF_MESSAGE_REQUEST_TYPE_TAG_REGISTER,
    AIF_MESSAGE_REQUEST_TYPE_TAG_HEARTBEAT,
    AIF_MESSAGE_REQUEST_TYPE_TAG_PUSHING
};

@class AXMessageManager;
@protocol AIFMessageManagerDelegate <NSObject>
@required
- (void)manager:(AXMessageManager *)manager didRegisterDevice:(NSString *)deviceId userId:(NSString *)userId receivedData:(NSData *)data;
- (void)manager:(AXMessageManager *)manager didHeartBeatWithDevice:(NSString *)deviceId userId:(NSString *)userId receivedData:(NSData *)data;

@end

@protocol AIFMessageSenderDelegate <NSObject>
- (void)manager:(AXMessageManager *)manager didSendMessage:(NSString *)message toUserId:(NSString *)userId receivedData:(NSData *)data;
@end

@interface AXMessageManager : NSObject<ASIHTTPRequestDelegate>

@property (nonatomic,weak) id<AIFMessageManagerDelegate> delegate;
@property (nonatomic,weak) id<AIFMessageSenderDelegate> MessageSenderDelegate;
@property (nonatomic) AIF_MESSAGE_REQUEST_REGISTER_STATUS registerStatus;

//+ (instancetype)sharedMessageManager;
- (void)bindServerHost:(NSString *)host port:(NSString *)port appName:(NSString *)appName timeout:(NSTimeInterval)timeout;
- (void)registerDevices:(NSString *)deviceId userId:(NSString *)userId;
- (void)heartBeatWithDevices:(NSString *)deviceId userId:(NSString *)userId;
- (void)sendMessageToUid:(NSString *)uid message:(NSString *)message;

//persistent connect can not be canceled, this is a experimental try。
- (void)cancelRegisterRequest;
- (void)cancelPerformRequests;

@end