//
//  MoreHeaderView.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "UserHeaderView.h"
#import "BrokerLineView.h"
#import "WebImageView.h"
#import "LoginManager.h"

@interface UserHeaderView () {
    
}
@property(nonatomic, strong) UIView *bannerView;
@property(nonatomic, strong) UIImageView *bannerImg;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;
@property(nonatomic, strong) UIView *wchatView;
@property(nonatomic, strong) UILabel *propertyLab;
@property(nonatomic, strong) UILabel *responseTimeLab;
@property(nonatomic, strong) UILabel *totalCustomNumLab;
@property(nonatomic, strong) UILabel *totalLoginNumLab;
@property(nonatomic, strong) UIView *userHeaderView;
@property(nonatomic ,strong) UILabel *userName;
@property(nonatomic ,strong) UIImageView *userLevel;
@end

@implementation UserHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}
- (void)createView{
    float maxStretch = 50;
    
    _bannerView = [[UIView alloc] initWithFrame:self.bounds];
    _bannerView.clipsToBounds = YES;
    
    _bannerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -maxStretch, CGRectGetWidth(_bannerView.frame), CGRectGetHeight(_bannerView.frame) + 2*maxStretch)];
    _bannerImg.contentMode = UIViewContentModeScaleToFill;
    [_bannerView addSubview:self.bannerImg];
    
    [self addSubview:self.bannerView];
    
    self.userHeaderView = [[UIView alloc] initWithFrame:CGRectMake(60, (CGRectGetHeight(_bannerView.frame)-80)/2, 200, 80)];
    self.userHeaderView.backgroundColor = [UIColor clearColor];
    [_bannerView addSubview:self.userHeaderView];
    
    WebImageView *userAvatar = [[WebImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    userAvatar.imageUrl = [LoginManager getUse_photo_url];
    userAvatar.contentMode = UIViewContentModeScaleAspectFill;
    userAvatar.layer.masksToBounds = YES;
    [self.userHeaderView addSubview:userAvatar];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.frame.origin.x+userAvatar.frame.size.width + 10, 10, 100, 20)];
    self.userName.backgroundColor = [UIColor clearColor];
    self.userName.text = @"";
    self.userName.font = [UIFont systemFontOfSize:16];
    self.userName.textColor = [UIColor whiteColor];
    [self.userHeaderView addSubview:self.userName];
    
    self.userLevel = [[UIImageView alloc] initWithFrame:CGRectMake(userAvatar.frame.origin.x+userAvatar.frame.size.width + 10, self.userName.frame.origin.y + self.userName.frame.size.height + 10, 100, 25)];
    [self.userLevel setImage:nil];
    [self.userHeaderView addSubview:self.userLevel];
    
    self.wchatView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bannerView.frame) - 60, [self windowWidth], 60)];
    self.wchatView.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    [self addSubview:self.wchatView];
    
    NSArray *desStrArr = @[@"5分钟回复率",@"平均响应",@"累计客户",@"累计登录"];
    
    for (int i = 0; i < 4; i++) {
        if (i != 0) {
            BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(1+i*80, 10, 1, 40)];
            line.horizontalLine = NO;
            [self.wchatView addSubview:line];
        }

        UILabel *dataLab = [[UILabel alloc] initWithFrame:CGRectMake(10+i*80, 10, 60, 15)];
        dataLab.backgroundColor = [UIColor clearColor];
        dataLab.font = [UIFont systemFontOfSize:16];
        dataLab.textColor = [UIColor whiteColor];
        if (i == 0) {
            self.propertyLab = dataLab;
            self.propertyLab.text = @"-%";
        }else if (i == 1){
            self.responseTimeLab = dataLab;
            self.responseTimeLab.text = @"-分钟";
        }else if (i == 2){
            self.totalCustomNumLab = dataLab;
            self.totalCustomNumLab.text = @"-个";
        }else if (i == 3){
            self.totalLoginNumLab = dataLab;
            self.totalLoginNumLab.text = @"-天";
        }
        [self.wchatView addSubview:dataLab];
        
        UILabel *dataDesLab = [[UILabel alloc] init];
        if (i == 0) {
            dataDesLab = [[UILabel alloc] initWithFrame:CGRectMake(10+i*80, 30, 75, 20)];
        }else{
            dataDesLab = [[UILabel alloc] initWithFrame:CGRectMake(10+i*80, 30, 60, 20)];
        }
        dataDesLab.backgroundColor = [UIColor clearColor];
        dataDesLab.font = [UIFont systemFontOfSize:12];
        dataDesLab.textColor = [UIColor whiteColor];
        dataDesLab.text = [desStrArr objectAtIndex:i];
        [self.wchatView addSubview:dataDesLab];
    }
}
- (void)setImageView:(UIImage *)img{
    [_bannerImg setImage:img];
}
- (void)updateUserHeaderInfo:(NSDictionary *)dic{
    self.userName.text = [dic objectForKey:@"brokerName"];
}
- (void)updateWchatData:(NSDictionary *)dic{
    self.propertyLab.text = @"60%";
    self.responseTimeLab.text = @"6分钟";
    self.totalCustomNumLab.text = @"22个";
    self.totalLoginNumLab.text = @"30天";
}

- (void)scrollViewDrag:(UIScrollView *)scrollView{
    float y = scrollView.contentOffset.y;
    [self changeHeader:y];
}

- (void)changeHeader:(float)y{
    UIView *headerView = _bannerView;
    CGRect headerFrame = _bannerView.frame;
    if (y < 0) {
        headerFrame.origin.y = y;
        headerFrame.size.height = -y + headerView.superview.frame.size.height;
        headerView.frame = headerFrame;
        
        CGPoint center = _bannerImg.center;
        center.y = headerView.frame.size.height/2;
        _bannerImg.center = center;
        
        self.userHeaderView.center = center;
    }else{
        if (headerFrame.origin.y != 0) {
            headerFrame.origin.y = 0;
            headerFrame.size.height = headerView.superview.frame.size.height;
            headerView.frame = headerFrame;
        }
        if (y < headerFrame.size.height) {
            CGPoint center = _bannerImg.center;
            center.y = headerView.frame.size.height/2 + y/2;
            _bannerImg.center = center;
            self.userHeaderView.center = center;
        }
    }
}
- (void)setLoading{
    if (self.activityView) {
        [self.activityView removeFromSuperview];
    }
    self.activityView= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center=CGPointMake(280, 40);
    [self.activityView startAnimating];
    [self.window addSubview:self.activityView];
}
- (void)hideLoading{
    if (self.activityView) {
        [self.activityView removeFromSuperview];
    }
}
- (NSInteger)windowWidth {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
