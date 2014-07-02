//
//  NoPlanPromotionPropertySingleViewController.m
//  AnjukeBroker_New
//
//  Created by jason on 7/1/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "NoPlanPromotionPropertySingleViewController.h"
#import "PropertyDetailTableViewCell.h"
#import "PropertyDetailTableViewCellModel.h"
#import "PropertyDetailTableViewFooter.h"

@interface NoPlanPromotionPropertySingleViewController ()

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *priceUnit;
@property (nonatomic,strong) NSString *publishDay;
@property (nonatomic,strong) PropertyDetailTableViewCellModel  *model;


@end

@implementation NoPlanPromotionPropertySingleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"房源详情"];
    self.tableView                     = [[UITableView alloc] initWithFrame:[UIView navigationControllerBound] style:UITableViewStylePlain];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.delegate            = self;
    self.tableView.dataSource          = self;
    self.tableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor     = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    
    
    PropertyDetailTableViewFooter *footer = [[PropertyDetailTableViewFooter alloc] initWithFrame:self.view.frame];
    [self.view addSubview:footer];
#warning hardCode测试数据
    self.price      = @"1.2";
    self.priceUnit  = @"元";
    self.publishDay = @"30";
    [self loadDataWithPropId:@"168783092" brokerId:@"858573"];
    // Do any additional setup after loading the view.
}


- (void)loadDataWithPropId:(NSString *)propId brokerId:(NSString *)brokerId
{
#warning 含有hardCode测试数据
    NSString     *method = @"anjuke/prop/summary/";
    NSDictionary *params = @{@"token":[LoginManager getToken],@"brokerId":brokerId,@"propId":propId,@"is_nocheck":@"1"};
    [[RTRequestProxy sharedInstance]asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleRequestData:)];
}

- (void)handleRequestData:(RTNetworkResponse *)response
{
    
    NSDictionary *dic = [response.content objectForKey:@"data"];
    self.model        = [[PropertyDetailTableViewCellModel alloc] initWithDataDic:dic];
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat cellHeight = 0.0;
    if (indexPath.row == 0 || indexPath.row == 2) {
        cellHeight = 15;
    } else if (indexPath.row == 1) {
        cellHeight = 99;
    } else if (indexPath.row == 3){
        cellHeight = 121;
    } else if (indexPath.row == 4) {
        cellHeight = 10;
    } else if (indexPath.row == 5) {
        cellHeight = 15;
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"identifier";
    if (indexPath.row == 1) {
        
        PropertyDetailTableViewCell *cell     = [[PropertyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.propertyDetailTableViewCellModel = self.model;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
        
    } else if (indexPath.row == 3) {
        
        UITableViewCell *cell     = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *promotionLable   = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 305, 20)];
        promotionLable.text       = @"定价推广";
        promotionLable.font       = [UIFont systemFontOfSize:17];
        UILabel *priceLable       = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 305, 15)];
        priceLable.text           = [NSString stringWithFormat:@"点击单价：%@%@",self.price,self.priceUnit];
        priceLable.textColor      = [UIColor brokerLightGrayColor];
        priceLable.font           = [UIFont systemFontOfSize:15];
        UIButton *promotionButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 65, 290, 42)];
        promotionButton.backgroundColor    = [UIColor brokerBabyBlueColor];
        promotionButton.layer.borderColor  = [UIColor brokerBabyBlueColor].CGColor;
        promotionButton.layer.borderWidth  = 1;
        promotionButton.layer.cornerRadius = 3;
        [promotionButton setTitle:@"立即推广" forState:UIControlStateNormal];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:promotionLable];
        [cell addSubview:priceLable];
        [cell addSubview:promotionButton];
        
        return cell;
    } else if (indexPath.row == 5) {
        
        UITableViewCell *cell          = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *publishDataLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 305, 15)];
        publishDataLabel.text          = [NSString stringWithFormat:@"%@天前发布",self.publishDay];
        publishDataLabel.textColor     = [UIColor brokerLightGrayColor];
        publishDataLabel.font          = [UIFont systemFontOfSize:14];
        publishDataLabel.textAlignment = UITextAlignmentRight;
        
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell addSubview:publishDataLabel];
        return cell;
        
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.backgroundColor  = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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
