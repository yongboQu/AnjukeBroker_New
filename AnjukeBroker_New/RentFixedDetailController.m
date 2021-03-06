//
//  RentFixedDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/4/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentFixedDetailController.h"
#import "PropertyEditViewController.h"
#import "RentAuctionViewController.h"
#import "ModifyFixedCostController.h"
#import "RentNoPlanController.h"
#import "ModifyRentCostController.h"
#import "RentSelectNoPlanController.h"

#import "SaleSelectNoPlanController.h"
#import "ModifyFixedCostController.h"

#import "FixedObject.h"
#import "BasePropertyObject.h"
#import "RentFixedCell.h"
#import "RentPropertyListCell.h"
#import "SaleFixedManager.h"
#import "LoginManager.h"
#import "CellHeight.h"
#import "RTGestureBackNavigationController.h"

@interface RentFixedDetailController ()
{
    int selectIndex;
}

@property (nonatomic, strong) UIActionSheet *myActionSheet;

@end

@implementation RentFixedDetailController
@synthesize tempDic;

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJ_LIST_ONVIEW page:ZF_DJ_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_FIXED_DETAIL_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectIndex = 0;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"定价房源"];
    [self addRightButton:@"操作" andPossibleTitle:nil];
	// Do any additional setup after loading the view.
}
-(void)initModel{
    [super initModel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self reloadData];
//}
//-(void)reloadData{
//
//    if(self.myArray == nil){
//        self.myArray = [NSMutableArray array];
//    }else{
//        [self.myArray removeAllObjects];
//        [self.myTable reloadData];
//    }
//
//    [self doRequest];
//}

-(void)dealloc{
    self.myTable.delegate = nil;
    self.myTable.dataSource = nil;
    self.myTable = nil;
    [self.myActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma mark - 请求定价组详情
-(void)doRequest{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }

    //planID

    NSString *planID;
    if ([self.tempDic objectForKey:@"fixId"]) {
        planID = [self.tempDic objectForKey:@"fixId"];
    }else if ([self.tempDic objectForKey:@"fixPlanId"]){
        planID = [self.tempDic objectForKey:@"fixPlanId"];
    }else if ([self.tempDic objectForKey:@"planId"]){
        planID = [self.tempDic objectForKey:@"planId"];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", planID, @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/getplandetail/" params:params target:self action:@selector(onGetFixedInfo:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onGetFixedInfo:(RTNetworkResponse *)response {
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    DLog(@"------response [%@]", [response content]);
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    if([resultFromAPI count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return ;
    }
    NSMutableDictionary *dicPlan = [[NSMutableDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"plan"]];
    self.planDic = [SaleFixedManager fixedPlanObjectFromDic:dicPlan];
    
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"propertyList"]];
    if([self.myArray count] == 0) {
        [self.myTable reloadData];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"该定价组没有房源"];
        return;
    }
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}
#pragma mark - 取消定价
-(void)doCancelFixed{
    [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJ_LIST_CANCEL_DJTG page:ZF_DJ_LIST_PAGE note:nil];
    
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    NSString *planID;
    if ([self.tempDic objectForKey:@"fixPlanId"]) {
        planID = [self.tempDic objectForKey:@"fixPlanId"];
    }else if ([self.tempDic objectForKey:@"planId"]){
        planID = [self.tempDic objectForKey:@"planId"];
    }else{
        planID = [self.tempDic objectForKey:@"fixId"];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [[self.myArray objectAtIndex:selectIndex] objectForKey:@"id"], @"propId", planID, @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/cancelplan/" params:params target:self action:@selector(onCancelSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onCancelSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    [self doRequest];
}
#pragma mark - 重新开始定价
-(void)doRestartFixed{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }

    NSString *planID;
    if ([self.tempDic objectForKey:@"fixId"]) {
        planID = [self.tempDic objectForKey:@"fixId"];
    }else if ([self.tempDic objectForKey:@"fixPlanId"]) {
        planID = [self.tempDic objectForKey:@"fixPlanId"];
    }else if ([self.tempDic objectForKey:@"planId"]) {
        planID = [self.tempDic objectForKey:@"planId"];
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", planID, @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/spreadstart/" params:params target:self action:@selector(onRestartSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onRestartSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    [self doRequest];
}

#pragma mark - 请求定价组详情
-(void)doStopFixedGroup{
    [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJ_LIST_STOP_TG page:ZF_DJ_LIST_PAGE note:nil];
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    NSString *planID;
    if ([self.tempDic objectForKey:@"fixId"]) {
        planID = [self.tempDic objectForKey:@"fixId"];
    }else if ([self.tempDic objectForKey:@"fixPlanId"]){
        planID = [self.tempDic objectForKey:@"fixPlanId"];
    }else if ([self.tempDic objectForKey:@"planId"]){
        planID = [self.tempDic objectForKey:@"planId"];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", planID, @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/spreadstop/" params:params target:self action:@selector(onStopSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onStopSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    [self doRequest];
}

#pragma mark - UITableView Delegate & DataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.navigationController.view.frame.origin.x > 0) {
        return;
    }
    selectIndex = indexPath.row -1;
    if([indexPath row] == 0){
        
    }else{
        if([[[self.myArray objectAtIndex:indexPath.row -1] objectForKey:@"isBid"] isEqualToString:@"1"]){
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"取消定价推广", @"修改房源信息", nil];
            action.tag = 102;
            if (self.myActionSheet) {
                self.myActionSheet = nil;
                self.myActionSheet.delegate = nil;
            }
            self.myActionSheet = action;
            [self.myActionSheet showInView:self.view];
        }else{
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"竞价推广本房源", @"取消定价推广", @"修改房源信息", nil];
            action.tag = 103;
            if (self.myActionSheet) {
                self.myActionSheet = nil;
                self.myActionSheet.delegate = nil;
            }
            self.myActionSheet = action;
            [self.myActionSheet showInView:self.view];
        }
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == 0){
        return 71.0f;
    }
    //    CGSize size = CGSizeMake(260, 40);
    //    CGSize si = [[[self.myArray objectAtIndex:indexPath.row -1] objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return [CellHeight getFixedCellHeight:[[self.myArray objectAtIndex:indexPath.row -1] objectForKey:@"title"]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DLog(@"[LoginManager isSeedForAJK:NO]%d",[LoginManager isSeedForAJK:NO]);
    if([indexPath row] == 0){
        static NSString *cellIdent = @"RentFixedCell";
        //            tableView.separatorColor = [UIColor lightGrayColor];
        RentFixedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"RentFixedCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RentFixedCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        [cell configureCell:self.planDic isAJK:NO];
        return cell;
    }else{
        static NSString *cellIdent = @"RentPropertyListCell";
        //            tableView.separatorColor = [UIColor lightGrayColor];
        RentPropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[NSClassFromString(@"RentPropertyListCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RentPropertyListCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell configureCell:[self.myArray objectAtIndex:[indexPath row] -1]];
        [cell showBottonLineWithCellHeight:[CellHeight getFixedCellHeight:[[self.myArray objectAtIndex:indexPath.row -1] objectForKey:@"title"]]];
        return cell;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag == 100){//正在推广中定价组
        if ([LoginManager isSeedForAJK:NO]) {
            if(buttonIndex == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要停止定价推广？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else if (buttonIndex == 1){//停止推广
                [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJ_LIST_ADD_FY page:ZF_DJ_LIST_PAGE note:nil];
                
                RentSelectNoPlanController *controller = [[RentSelectNoPlanController alloc] init];
                controller.fixedObj = self.planDic;
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *navi = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:navi animated:YES completion:nil];
                
            }else if (buttonIndex == 2){
                
            }
            
        }else{
            if(buttonIndex == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要停止定价推广？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else if (buttonIndex == 1){//停止推广
                [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_FIXED_DETAIL_004 note:nil];
                ModifyRentCostController *controller = [[ModifyRentCostController alloc] init];
                controller.fixedObject = self.planDic;
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:nav animated:YES completion:nil];
                
            }else if (buttonIndex == 2){
                [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJ_LIST_ADD_FY page:ZF_DJ_LIST_PAGE note:nil];
                
                RentSelectNoPlanController *controller = [[RentSelectNoPlanController alloc] init];
                controller.fixedObj = self.planDic;
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *navi = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:navi animated:YES completion:nil];
            }
        }
    }else if(actionSheet.tag == 101){//当推广已暂停时的操作
        if([LoginManager isSeedForAJK:NO]){
            if(buttonIndex == 0){//重新开始定价推广
                [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJ_LIST_START_TG page:ZF_DJ_LIST_PAGE note:nil];
                [self doRestartFixed];
            }else if (buttonIndex == 1){
                [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJ_LIST_ADD_FY page:ZF_DJ_LIST_PAGE note:nil];
                RentSelectNoPlanController *controller = [[RentSelectNoPlanController alloc] init];
                controller.fixedObj = self.planDic;
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *navi = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:navi animated:YES completion:nil];
            }else if (buttonIndex == 2){
                
            }
            
        }else{
            if(buttonIndex == 0){//重新开始定价推广
                [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJ_LIST_START_TG page:ZF_DJ_LIST_PAGE note:nil];
                [self doRestartFixed];
            }else if (buttonIndex == 1){
                [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_FIXED_DETAIL_004 note:nil];
                ModifyRentCostController *controller = [[ModifyRentCostController alloc] init];
                controller.fixedObject = self.planDic;
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:nav animated:YES completion:nil];
            }else if (buttonIndex == 2){
                [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJ_LIST_ADD_FY page:ZF_DJ_LIST_PAGE note:nil];
                RentSelectNoPlanController *controller = [[RentSelectNoPlanController alloc] init];
                controller.fixedObj = self.planDic;
                controller.backType = RTSelectorBackTypeDismiss;
                RTGestureBackNavigationController *navi = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:navi animated:YES completion:nil];
            }
        }
    }else if (actionSheet.tag == 102){
        if(buttonIndex == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要取消定价推广？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 105;
            [alert show];
        }else if (buttonIndex == 1){
            [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJ_LIST_EDIT_FYXX page:ZF_DJ_LIST_PAGE note:nil];
            PropertyEditViewController *controller = [[PropertyEditViewController alloc] init];
            controller.isHaozu = YES;
            controller.pdId = ZF_DJ_LIST_PAGE;
            controller.propertyID = [[self.myArray objectAtIndex:selectIndex] objectForKey:@"id"];
            controller.backType = RTSelectorBackTypeDismiss;
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
            //            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if (buttonIndex == 2){
            
        }
        
    }else if (actionSheet.tag == 103){
        if(buttonIndex == 0){
            [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJ_LIST_CLICK_TGFY page:ZF_DJ_LIST_PAGE note:nil];
            RentAuctionViewController *controller = [[RentAuctionViewController alloc] init];
            controller.proDic = [self.myArray objectAtIndex:selectIndex];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.delegateVC = self;
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:^(void){
                controller.proDic = [self.myArray objectAtIndex:selectIndex];
            }];
        }else if (buttonIndex == 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要取消定价推广？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 105;
            [alert show];
            //            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if (buttonIndex == 2){
            [[BrokerLogger sharedInstance] logWithActionCode:ZF_DJ_LIST_EDIT_FYXX page:ZF_DJ_LIST_PAGE note:nil];
            PropertyEditViewController *controller = [[PropertyEditViewController alloc] init];
            controller.isHaozu = YES;
            controller.pdId = ZF_DJ_LIST_PAGE;
            controller.propertyID = [[self.myArray objectAtIndex:selectIndex] objectForKey:@"id"];
            controller.backType = RTSelectorBackTypeDismiss;
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }
        
    }else{//对房源的操作
    }
}

#pragma mark -- privateMethod
-(void)rightButtonAction:(id)sender{
    if(self.isLoading){
        return ;
    }
    
    if (self.planDic == nil) {
        return;
    }
    FixedObject *fix = [[FixedObject alloc] init];
    fix = self.planDic;
    
    if([fix.fixedStatus isEqualToString:@"1"]){
        if ([LoginManager isSeedForAJK:NO]) {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"停止推广", @"添加房源", nil];
            action.tag = 100;
            if (self.myActionSheet) {
                self.myActionSheet = nil;
                self.myActionSheet.delegate = nil;
            }
            self.myActionSheet = action;
            [self.myActionSheet showInView:self.view];
        }else{
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"停止推广", @"修改限额", @"添加房源", nil];
            action.tag = 100;
            if (self.myActionSheet) {
                self.myActionSheet = nil;
                self.myActionSheet.delegate = nil;
            }
            self.myActionSheet = action;
            [self.myActionSheet showInView:self.view];
        }
        
        
    }else{
        if([LoginManager isSeedForAJK:NO]){
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"开始推广", @"添加房源", nil];
            action.tag = 101;
            if (self.myActionSheet) {
                self.myActionSheet = nil;
                self.myActionSheet.delegate = nil;
            }
            self.myActionSheet = action;
            [self.myActionSheet showInView:self.view];
        }else{
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"开始推广", @"修改限额", @"添加房源", nil];
            action.tag = 101;
            if (self.myActionSheet) {
                self.myActionSheet = nil;
                self.myActionSheet.delegate = nil;
            }
            self.myActionSheet = action;
            [self.myActionSheet showInView:self.view];
        }
        
        
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 105){
        if(buttonIndex == 1){
            [self doCancelFixed];
        }
    }else{
        
        if(buttonIndex == 1){
            [self doStopFixedGroup];
        }else{
            
        }
        
    }
}

@end
