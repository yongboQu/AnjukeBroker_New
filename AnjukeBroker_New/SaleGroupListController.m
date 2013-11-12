//
//  SaleGroupListController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/12/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleGroupListController.h"
#import "SaleFixedDetailController.h"
#import "SalePropertyObject.h"
#import "LoginManager.h"
#import "PPCGroupCell.h"

@interface SaleGroupListController ()
{
    int selectedIndex;
}
@end

@implementation SaleGroupListController
@synthesize myArray;
@synthesize myTable;
@synthesize propertyArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initModel_];
        // Custom initialization
    }
    return self;
}
-(void)initModel_{
    self.propertyArray = [NSMutableArray array];
    selectedIndex = 0;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"选择定价组"];
    
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doFixedGroupList];
}
-(void)initDisplay{
    self.myTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];
}
#pragma mark - Request 定价推广
-(void)doFixed{
    if(![self isNetworkOkay]){
        return;
    }
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  @"187275101", @"proIds", @"388666", @"planId", nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  [self getStringFromArray:self.propertyArray], @"propIds", [[self.myArray objectAtIndex:selectedIndex] objectForKey:@"fixPlanId"], @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/addpropstoplan/" params:params target:self action:@selector(onFixedSuccess:)];
    [self showLoadingActivity:YES];
}

- (void)onFixedSuccess:(RTNetworkResponse *)response {
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }
    [self hideLoadWithAnimated:YES];
    DLog(@"------response [%@]", [response content]);

    SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
    controller.backType = RTSelectorBackTypePopToRoot;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[[self.myArray objectAtIndex:selectedIndex] objectForKey:@"fixPlanId"] forKey:@"fixPlanId"];
    controller.tempDic = dic;
    [self.navigationController pushViewController:controller animated:YES];
}
-(NSString *)getStringFromArray:(NSArray *) array{
    NSMutableString *tempStr = [NSMutableString string];
    for (int i=0;i<[array count];i++) {
        SalePropertyObject *pro = (SalePropertyObject *)[array objectAtIndex:i];
        if(tempStr.length == 0){
            [tempStr appendString:[NSString stringWithFormat:@"%@",pro.propertyId]];
        }else{
            [tempStr appendString:@","];
            [tempStr appendString:[NSString stringWithFormat:@"%@",pro.propertyId]];
        }
    }

    DLog(@"====%@",tempStr);
    return tempStr;
}

#pragma mark - Request 获取定价推广组列表
-(void)doFixedGroupList{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/getplans/" params:params target:self action:@selector(onFixedGroupSuccess:)];
    [self showLoadingActivity:YES];
}

- (void)onFixedGroupSuccess:(RTNetworkResponse *)response {
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        return;
    }
    [self hideLoadWithAnimated:YES];
    DLog(@"------response [%@]", [response content]);
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    [self.myArray removeAllObjects];
    [self.myArray addObjectsFromArray:[resultFromAPI objectForKey:@"planList"]];
    [self.myTable reloadData];
}
-(void)dealloc{
    self.myTable.delegate = nil;
}
- (void)initModel {
    self.myArray = [NSMutableArray array];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = indexPath.row;
    [self doFixed];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    
    PPCGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[NSClassFromString(@"PPCGroupCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
    }
    [cell setFixedGroupValueForCellByData:self.myArray index:indexPath.row];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end