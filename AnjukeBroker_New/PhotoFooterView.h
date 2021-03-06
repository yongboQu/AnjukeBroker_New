//
//  PhotoFooterView.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-24.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrokerLineView.h"

#define PF_EMPTY_IMAGE_HEIGHT 130
#define PF_IMAGE_WIDTH 130/2
#define PF_IMAGE_GAP_X 20/2
#define PF_IMAGE_GAP_Y 15/2
@class PhotoFooterView;
@protocol PhotoFooterImageClickDelegate <NSObject>

- (void)imageDidClickWithIndex:(int)index;
- (void)imageDidClickWithIndex:(int)index sender:(PhotoFooterView *)sender;
- (void)addImageDidClick;
- (void)addImageDidClick:(PhotoFooterView *)sender;

- (void)drawFinishedWithCurrentHeight:(CGFloat)height; //重绘结束后返回当前页面的高度

@end

@interface PhotoFooterView : UIView

@property (nonatomic, assign) id <PhotoFooterImageClickDelegate>clickDelegate;
@property (nonatomic, strong) UIButton *emptyImgBtn;
@property BOOL isHouseType; //是室内图还是房型图
@property (nonatomic, strong) NSMutableArray *imageBtnArray; //显示预览图的容器

@property (nonatomic, strong) BrokerLineView *topLine;
@property (nonatomic, strong) BrokerLineView *bottomLine;

- (void)redrawWithImageArray:(NSArray *)imageArr;
- (void)redrawWithHouseTypeImageArray:(NSArray *)imageArr andImgUrl:(NSArray *)urlImgArr;

//编辑房源-室内图
- (void)redrawWithEditRoomImageArray:(NSArray *)imageArr andImgUrl:(NSArray *)urlImgArr;
//编辑房源-户型图
- (void)redrawWithEditHouseTypeShowedImageArray:(NSArray *)showedImageArr andAddImgArr:(NSArray *)addImgArr andOnlineHouseTypeArr:(NSArray *)onlineHouseTypeArr;

//重绘线
- (void)resetLineWithHeight:(CGFloat)height;

@end
