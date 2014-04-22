//
//  BrokerChatViewController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 2/24/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "BrokerChatViewController.h"
#import "CommunitySelectViewController.h"
#import "AXPhotoBrowser.h"
#import "ClientDetailViewController.h"
#import "AXChatWebViewController.h"
#import "AXPhoto.h"
#import "Util_UI.h"
#import "UIImage+Resize.h"
#import "NSString+RTStyle.h"
#import "ClientDetailPublicViewController.h"
#import "AXNotificationTutorialViewController.h"
#import "RTGestureBackNavigationController.h"

@interface BrokerChatViewController ()
{
    
}
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) UIImageView *brokerIcon;
@end

@implementation BrokerChatViewController
#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

- (void)didMoreBackView:(UIButton *)sender {
    [super didMoreBackView:sender];
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_004 note:nil];
}

#pragma mark - lifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.brokerIcon = [[UIImageView alloc] init];
        // Custom initialization
        self.backType = RTSelectorBackTypePopToRoot;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backType = RTSelectorBackTypePopToRoot;
    
    // 设置返回btn

    [self initRightBar];
    [self initNavTitle];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self downLoadIcon];
}

- (void)downLoadIcon {
    //保存头像
    AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[LoginManager getChatID]];
    if (person.iconPath.length < 2) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[LoginManager getUse_photo_url]]];
        [self.brokerIcon setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            //        NSString *imgName = [NSString stringWithFormat:@"%dx%d.jpg", (int)image.size.height, (int)image.size.width];
            //        NSString *imgpath = [AXPhotoManager saveImageFile:image toFolder:@"icon" whitChatId:[LoginManager getChatID] andIMGName:imgName];
            NSArray*libsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString*libPath = [libsPath objectAtIndex:0];
            NSString *userFolder = [libPath stringByAppendingPathComponent:[LoginManager getChatID]];
            if ([UIImageJPEGRepresentation(image, 0.96) writeToFile:userFolder atomically:YES]) {
                
            }else{
                
            }
            
            AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[LoginManager getChatID]];
            person.iconUrl = [LoginManager getUse_photo_url];
            person.iconPath = [LoginManager getChatID];
            person.isIconDownloaded = YES;
            [[AXChatMessageCenter defaultMessageCenter] updatePerson:person];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
    }
}

- (void)initNavTitle {
    AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:self.friendPerson.uid];
    NSString *titleString = @"noname";
    if (person.markName.length > 0) {
        titleString = [NSString stringWithFormat:@"%@", person.markName];
    }
    else {
        titleString = [NSString stringWithFormat:@"%@", self.friendPerson.name];
        if ([person.markName isEqualToString:person.phone]) {
            titleString = [Util_TEXT getChatNameWithPhoneFormat:person.phone];
        }
    }
    if (titleString.length == 0 || [titleString isEqualToString:@"(null)"]) {
        titleString = [Util_TEXT getChatNameWithPhoneFormat:person.phone];
        
    }
    [self setTitleViewWithString:titleString];
 }

- (void)initRightBar {
    UIButton *brokerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    brokerButton.frame = CGRectMake(0, 0, 44, 44);
    [brokerButton setImage:[UIImage imageNamed:@"anjuke_icon_person.png"] forState:UIControlStateNormal];
    [brokerButton setImage:[UIImage imageNamed:@"anjuke_icon_person.png"] forState:UIControlStateHighlighted];
    [brokerButton addTarget:self action:@selector(viewCustomerDetailInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItems = [[UIBarButtonItem alloc] initWithCustomView:brokerButton];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10.0f;
    [self.navigationItem setRightBarButtonItems:@[spacer, buttonItems]];
}

- (void)pickIMG:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_006 note:nil];
    
    ELCAlbumPickerController *albumPicker = [[ELCAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumPicker];
    elcPicker.maximumImagesCount = 5; //(maxCount - self.roomImageArray.count);
    elcPicker.imagePickerDelegate = self;
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (void)takePic:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_005 note:nil];
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera; //拍照
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}
- (void)pickAJK:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_007 note:nil];
    CommunitySelectViewController *controller = [[CommunitySelectViewController alloc] init];
    controller.pageTypeFrom = secondHandHouse;
    HouseSelectNavigationController *nav = [[HouseSelectNavigationController alloc] initWithRootViewController:controller];
    nav.selectedHouseDelgate = self;
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)pickHZ:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_008 note:nil];
    CommunitySelectViewController *controller = [[CommunitySelectViewController alloc] init];
    controller.pageTypeFrom = rentHouse;
    HouseSelectNavigationController *nav = [[HouseSelectNavigationController alloc] initWithRootViewController:controller];
    nav.selectedHouseDelgate = self;
    [self presentViewController:nav animated:YES completion:nil];
    
}
-(void)returnSelectedHouseDic:(NSDictionary *)dic houseType:(BOOL)houseType {
    NSMutableDictionary *propDict = [NSMutableDictionary dictionary];
    //二手房单页详情url确认结果：http://m.anjuke.com/sale/x/11/204603156
    //格式：http://fp07.m.dev.anjuke.com/sale/x/{城市id}/{房源id}
    
    // 租房单页详情url确认结果：http://lvandu.dev.anjuke.com/rent/x/11/23893357-3
    //格式：http://fp07.m.dev.anjuke.com/rent/x/{城市id}/{房源id}-{租房类型}
    NSString *des = [NSString stringWithFormat:@"%@室%@厅%@卫 %d平",dic[@"roomNum"], dic[@"hallNum"], dic[@"toiletNum"], [dic[@"area"] integerValue]];
    if (houseType ) {
        NSString *price = [NSString stringWithFormat:@"%d%@", [dic[@"price"] integerValue], dic[@"priceUnit"]];
        NSString *url = nil;
        url = [NSString stringWithFormat:@"http://m.anjuke.com/sale/x/%@/%@",[LoginManager getCity_id],dic[@"id"]];
#if DEBUG
//        url = [NSString stringWithFormat:@"http://fp07.m.dev.anjuke.com/sale/x/%@/%@",[LoginManager getCity_id],dic[@"id"]];
#endif
        propDict = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dic[@"id"], @"des":des, @"img":dic[@"imgUrl"], @"name":dic[@"commName"], @"price":price, @"url":url, @"tradeType":[NSNumber numberWithInteger:AXMessagePropertySourceErShouFang]}];
    }else{
        NSString *price = [NSString stringWithFormat:@"%@%@/月", dic[@"price"], dic[@"priceUnit"]];
        NSString *url = nil;//http://lvandu.dev.anjuke.com/rent/x/11/23893357-3
        url = [NSString stringWithFormat:@"http://m.anjuke.com/rent/x/%@/%@-3",[LoginManager getCity_id],dic[@"id"]];
#if DEBUG
//        url = [NSString stringWithFormat:@"http://lvandu.dev.anjuke.com/rent/x/%@/%@-3",[LoginManager getCity_id],dic[@"id"]];
#endif
        propDict = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dic[@"id"], @"des":des, @"img":dic[@"imgUrl"], @"name":dic[@"commName"], @"price":price, @"url":url, @"tradeType":[NSNumber numberWithInteger:AXMessagePropertySourceZuFang]}];
    }
    
    AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
    mappedMessageProp.accountType = @"1";
    mappedMessageProp.content = [propDict RTJSONRepresentation];
    mappedMessageProp.to = [self checkFriendUid];
    mappedMessageProp.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessageProp.isRead = YES;
    mappedMessageProp.isRemoved = NO;
    mappedMessageProp.messageType = [NSNumber numberWithInteger:AXMessageTypeProperty];
    if (self.friendPerson && self.friendPerson.userType == AXPersonTypePublic) {
        [[AXChatMessageCenter defaultMessageCenter] sendMessageToPublic:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    } else {
        [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    }
}
#pragma mark - DataSouce Method
- (NSString *)checkFriendUid
{
    if (self.uid) {
        return self.uid;
    }
    return @"";
}
#pragma mark - AXChatMessageRootCellDelegate

- (void)didClickAvatar:(BOOL)isCurrentPerson {
    if (isCurrentPerson) {
        return;
//        AXMappedPerson *item = self.currentPerson;
//        //for test
//        ClientDetailViewController *cd = [[ClientDetailViewController alloc] init];
//        cd.person = item;
//        [cd setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:cd animated:YES];
    }else {

            AXMappedPerson *item = self.friendPerson;
            //for test
            ClientDetailViewController *cd = [[ClientDetailViewController alloc] init];
            cd.person = item;
        cd.backType = RTSelectorBackTypePopToRoot;
            [cd setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:cd animated:YES];

    }
    
}

#pragma mark - ELCImagePickerControllerDelegate
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    
    if ([info count] == 0) {
        return;
    }
    NSString *uid =[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    int tempNum = 1;
    for (NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        CGSize size = image.size;

        NSString *name = [NSString stringWithFormat:@"_%d-%dx%d", tempNum ++, (int)size.width, (int)size.width];
        NSString *path = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:uid andIMGName:name];
//        NSString *url = [AXPhotoManager getLibrary:path];
//        NSLog(@"==========url=======%@",url);
        AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
        mappedMessage.accountType = @"1";
        //        mappedMessage.content = self.messageInputView.textView.text;
//        mappedMessage.content = @"[图片]";
        mappedMessage.to = [self checkFriendUid];
        mappedMessage.from = uid;
        mappedMessage.isRead = YES;
        mappedMessage.isRemoved = NO;
        mappedMessage.messageType = [NSNumber numberWithInteger:AXMessageTypePic];
        mappedMessage.imgPath = path;
        if (self.friendPerson && self.friendPerson.userType == AXPersonTypePublic) {
            [[AXChatMessageCenter defaultMessageCenter] sendImageToPublic:mappedMessage willSendMessage:self.finishSendMessageBlock];
        } else {
            [[AXChatMessageCenter defaultMessageCenter] sendImage:mappedMessage withCompeletionBlock:self.finishSendMessageBlock];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *newSizeImage = nil;
    NSString *uid =[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
   newSizeImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(1280, 1280) interpolationQuality:kCGInterpolationHigh];
    
    CGSize size = newSizeImage.size;
    NSString *name = [NSString stringWithFormat:@"%dx%d",(int)size.width,(int)size.width];
    NSString *path = [AXPhotoManager saveImageFile:newSizeImage toFolder:AXPhotoFolderName whitChatId:uid andIMGName:name];
//    NSString *url = [AXPhotoManager getLibrary:path];
    
    AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
    mappedMessage.accountType = @"2";
    //        mappedMessage.content = self.messageInputView.textView.text;
    mappedMessage.to = [self checkFriendUid];
    mappedMessage.from = uid;
    mappedMessage.isRead = YES;
    mappedMessage.isRemoved = NO;
    mappedMessage.messageType = @(AXMessageTypePic);
    mappedMessage.imgPath = path;
    
    if (self.friendPerson && self.friendPerson.userType == AXPersonTypePublic) {
        [[AXChatMessageCenter defaultMessageCenter] sendImageToPublic:mappedMessage willSendMessage:self.finishSendMessageBlock];
    } else {
        [[AXChatMessageCenter defaultMessageCenter] sendImage:mappedMessage withCompeletionBlock:self.finishSendMessageBlock];
    }
    
    //        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
    //        NSDictionary *imageData = @{@"messageType":@"image",@"content":image,@"messageSource":@"incoming"};
    //        [self.cellData addObject:imageData];
    //        [self reloadMytableView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PrivateMethods
- (void)rightBarButtonClick:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_009 note:nil];
    [self viewCustomerDetailInfo];
}

- (void)viewCustomerDetailInfo {
    if (self.friendPerson.userType == AXPersonTypePublic) {
        
        [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_009 note:nil];
        AXMappedPerson *item = self.friendPerson;
        //for test
        ClientDetailPublicViewController *cd = [[ClientDetailPublicViewController alloc] init];
        cd.person = item;
        [cd setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cd animated:YES];
    }else if (self.friendPerson.userType == AXPersonTypeUser){
        [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_009 note:nil];
        AXMappedPerson *item = self.friendPerson;
        //for test
        ClientDetailViewController *cd = [[ClientDetailViewController alloc] init];
        cd.person = item;
        [cd setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cd animated:YES];
    }
    

}


#pragma mark -
#pragma mark LOG Method
- (void)clickLocationLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_015 note:nil];
}
- (void)switchToVoiceLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_016 note:nil];
}
- (void)switchToTextLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_017 note:nil];
}
- (void)pressForVoiceLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_018 note:nil];
}
- (void)cancelSendingVoiceLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_019 note:nil];
}

- (void)doBack:(id)sender {
    
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_013 note:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didClickTelNumber:(NSString *)telNumber {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_010 note:nil];
    NSArray *phone = [NSArray arrayWithArray:[telNumber componentsSeparatedByString:@":"]];
    
    if (phone.count == 2) {
        
            self.phoneNumber = [phone objectAtIndex:1];
        NSString *title = [NSString stringWithFormat:@"%@可能是个电话号码，你可以",self.phoneNumber];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拨打电话",@"保存到客户资料", nil];
        [sheet showInView:self.view];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_011 note:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneNumber]]];
    }else if (buttonIndex == 1){
        [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_012 note:nil];
            self.friendPerson.markPhone = self.phoneNumber;
            [[AXChatMessageCenter defaultMessageCenter] updatePerson:self.friendPerson];
        [self showInfo:@"保存成功"];
    }else {
    
    }
}
#pragma mark - AXChatMessageRootCellDelegate
- (void)didClickPropertyWithUrl:(NSString *)url withTitle:(NSString *)title;
{
    AXChatWebViewController *webViewController = [[AXChatWebViewController alloc] init];
    webViewController.webUrl = url;
    webViewController.webTitle = title;
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - AJKChatMessageSystemCellDelegate
- (void)didClickSystemButton:(AXMessageType)messageType {
    switch (messageType) {
        case AXMessageTypeSendProperty:
        {
//            [self sendPropMessage];
        }
            break;
            
        case AXMessageTypeSettingNotifycation:
        {
            AXNotificationTutorialViewController *controller = [[AXNotificationTutorialViewController alloc] initWithNibName:@"AXNotificationTutorialViewController" bundle:nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
            controller.navigationController.navigationBar.translucent = NO;
            [self presentViewController:navController animated:YES completion:nil];
        }
            break;
        case AXMessageTypeAddNote:
        {
            ClientEditViewController *controller = [[ClientEditViewController alloc] init];
            controller.person = self.friendPerson;
            controller.backType = RTSelectorBackTypeDismiss;
            RTGestureBackNavigationController *navController = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            controller.navigationController.navigationBar.translucent = NO;
            [self presentViewController:navController animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)didMessageRetry:(AXChatMessageRootCell *)axCell
{
    if (self.friendPerson.userType == AXPersonTypePublic) {
        if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeText)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendMessageToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeProperty)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendMessageToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeLocation)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendMessageToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeVoice)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendVoiceToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypePic)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendImageToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else {
            
        }
        // 之后必改
    } else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypePic)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendImage:axCell.identifyString withCompeletionBlock:self.finishReSendMessageBlock];
    }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeText)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendMessage:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
    }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeLocation)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendMessage:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
    }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeProperty)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendMessage:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
    }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeVoice)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendVoice:axCell.identifyString withCompeletionBlock:self.finishReSendMessageBlock];
    }else {
        
    }
}

#pragma mark - NSNotificationCenter
- (void)connectionStatusDidChangeNotification:(NSNotification *)notification
{
    if (self.navigationController.presentedViewController) {
        [self.navigationController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (self.navigationController.viewControllers) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index > 0) {
            NSArray *vcArray = [self.navigationController.viewControllers objectsAtIndexes:[[NSIndexSet alloc] initWithIndex:index - 1]];
            [self.navigationController setViewControllers:vcArray animated:YES];
        }
    }
}
#pragma mark - 
#pragma cellDelegate
- (void)didClickMapCell:(NSDictionary *) dic {
    MapViewController *mv = [[MapViewController alloc] init];
    [mv setHidesBottomBarWhenPushed:YES];
    mv.mapType = RegionNavi;
    mv.navDic = dic;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:mv animated:YES];
    
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_020 note:nil];
}

#pragma mark -
#pragma MapViewControllerDelegate
- (void)loadMapSiteMessage:(NSDictionary *)mapSiteDic {
    
    NSDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"google_lat":mapSiteDic[@"google_lat"], @"google_lng":mapSiteDic[@"google_lng"], @"city":mapSiteDic[@"city"], @"region":mapSiteDic[@"region"], @"address":mapSiteDic[@"address"],@"from_map_type":mapSiteDic[@"from_map_type"], @"jsonVersion":@"1", @"tradeType":[NSNumber numberWithInteger:AXMessageTypeLocation]}];
    
    AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
    mappedMessageProp.accountType = @"2";
    mappedMessageProp.content = [dic RTJSONRepresentation];
    mappedMessageProp.to = [self checkFriendUid];
    mappedMessageProp.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessageProp.isRead = YES;
    mappedMessageProp.isRemoved = NO;
    mappedMessageProp.messageType = [NSNumber numberWithInteger:AXMessageTypeLocation];
    if (self.friendPerson && self.friendPerson.userType == AXPersonTypePublic) {
        [[AXChatMessageCenter defaultMessageCenter] sendMessageToPublic:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    }else {
        [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    }
}

@end
