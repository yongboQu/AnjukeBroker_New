//
//  DiscoverViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "DiscoverViewController.h"
#import "UIViewExt.h"
#import "CheckoutCommunityViewController.h"
#import "FindHomeViewController.h"
#import "RushPropertyViewController.h"
#import "BK_RTNavigationController.h"
#import "RTListCell.h"

@interface DiscoverViewController ()

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.propertyBadgeNumber = 88; //测试用
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"发现"];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    //    headView.backgroundColor = [UIColor yellowColor];
    self.tableView.tableHeaderView = headView;
    self.tableView.backgroundColor = [UIColor brokerBgPageColor];
    
    [[BrokerLogger sharedInstance] logWithActionCode:FIND_PAGE_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    
}

#pragma mark - log
//- (void)sendAppearLog {
//    [[BrokerLogger sharedInstance] logWithActionCode:FIND_PAGE_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
//}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identify = @"DiscoverViewControllerCellIdentifier";
    
    RTListCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[RTListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont ajkH2Font];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"市场分析";
        cell.imageView.image = [UIImage imageNamed:@"discover_icon_find"];
        
        [cell showTopLine];
        [cell showBottonLineWithCellHeight:46 andOffsetX:55];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"小区签到";
        cell.imageView.image = [UIImage imageNamed:@"discover_icon_check"];
        [cell showBottonLineWithCellHeight:46 andOffsetX:55];
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"抢房源委托";
        cell.imageView.image = [UIImage imageNamed:@"discover_icon_rab"];
        [cell showBottonLineWithCellHeight:46];
        
    }
    
    return cell;
}

- (void)setDiscoverBadgeValue:(NSInteger) unReadCount{
    if (unReadCount > 0 && self.badgeView) {
        self.badgeNumberLabel.text = [NSString stringWithFormat:@"%d", unReadCount];
        self.badgeView.hidden = NO;        
        
    }else if(self.badgeView){
        self.badgeView.hidden = YES;
    }
    
    [self.tableView reloadData];
    
}


#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSLog(@"市场分析");
        [[BrokerLogger sharedInstance] logWithActionCode:FIND_PAGE_003 note:nil];
        FindHomeViewController *ae = [[FindHomeViewController alloc] init];
        [ae setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:ae animated:YES];
    }else if(indexPath.row == 1){
        NSLog(@"小区签到");
        [[BrokerLogger sharedInstance] logWithActionCode:FIND_PAGE_004 note:nil];
        CheckoutCommunityViewController *communityVC = [[CheckoutCommunityViewController alloc] init];
        [communityVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:communityVC animated:YES];
    }else if(indexPath.row == 2){
        NSLog(@"抢房源委托");
        [[BrokerLogger sharedInstance] logWithActionCode:FIND_PAGE_005 note:nil];
        RushPropertyViewController* viewController = [[RushPropertyViewController alloc] init];
        [viewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}



#pragma mark -
#pragma Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
