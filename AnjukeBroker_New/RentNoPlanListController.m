//
//  RantNoPlanListController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/4/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentNoPlanListController.h"
#import "AnjukeEditPropertyViewController.h"
#import "SaleNoPlanListCell.h"
#import "Util_UI.h"

#define SELECT_ALL_STR @"全选"
#define UNSELECT_ALL_STR @"取消全选"

#define TOOL_BAR_HEIGHT 44

@interface RentNoPlanListController ()
{
    
}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIBarButtonItem *seleceAllItem; //全选btnItem
@property int singleSelectBtnRow; //记录最后打勾按钮所在indexPath.row
@property (nonatomic, strong) UIButton *editBtn; //编辑按钮

@end

@implementation RentNoPlanListController
@synthesize contentView;
@synthesize seleceAllItem;
@synthesize singleSelectBtnRow;
@synthesize editBtn;
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
    [self initDisplay_];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initDisplay_ {
    //全选
    UIBarButtonItem *selectBtn = [[UIBarButtonItem alloc] initWithTitle:SELECT_ALL_STR style:UIBarButtonItemStyleBordered target:self action:@selector(mutableAction:)];
    self.seleceAllItem = selectBtn;
    selectBtn.possibleTitles = [NSSet setWithObjects:UNSELECT_ALL_STR, nil];
    self.navigationItem.rightBarButtonItem = selectBtn;
    
    self.myTable.frame = FRAME_BETWEEN_NAV_TAB;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [self currentViewHeight] - TOOL_BAR_HEIGHT, [self windowWidth], TOOL_BAR_HEIGHT)];
    self.contentView.backgroundColor = SYSTEM_NAVIBAR_COLOR;
    
    //编辑、删除、定价推广btn
    UIButton *mutableSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    [mutableSelect setTitle:@"编辑" forState:UIControlStateNormal];
    [mutableSelect setTitleColor:SYSTEM_BLUE forState:UIControlStateNormal];
    mutableSelect.frame = CGRectMake(10, 0, 90, TOOL_BAR_HEIGHT);
    self.editBtn = mutableSelect;
    [mutableSelect addTarget:self action:@selector(doEdit) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:mutableSelect];
    
    UIButton *multiSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    multiSelect.frame = CGRectMake(110, 0, 90, TOOL_BAR_HEIGHT);
    [multiSelect setTitle:@"定价推广" forState:UIControlStateNormal];
    [multiSelect setTitleColor:SYSTEM_BLUE forState:UIControlStateNormal];
    [multiSelect addTarget:self action:@selector(mutableFixed) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:multiSelect];
    [self.view addSubview:self.contentView];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    delete.frame = CGRectMake(210, 0, 90, TOOL_BAR_HEIGHT);
    [delete setTitleColor:SYSTEM_BLUE forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:delete];
    
    [self setEditBtnEnableStatus];
}

#pragma mark - TableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    
    SaleNoPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[SaleNoPlanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_select@2x.png"];
        cell.clickDelegate = self;
    }
    
    [cell configureCell:nil withIndex:indexPath.row];
    
    if([self.selectedArray containsObject:[self.myArray objectAtIndex:[indexPath row]]]){
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_selected@2x.png"];
    }else{
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_select@2x.png"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self doCheckmarkAtRow:indexPath.row];
}

#pragma mark - Checkmark Btn Delegate

- (void)checkmarkBtnClickedWithRow:(int)row {
    DLog(@"row -[%d]", row);
    
    [self doCheckmarkAtRow:row];
}

#pragma mark - PrivateMethod
//***打勾操作***
- (void)doCheckmarkAtRow:(int)row {
    self.singleSelectBtnRow = row;
    
    if(![self.selectedArray containsObject:[self.myArray objectAtIndex:row]]){
        [self.selectedArray addObject:[self.myArray objectAtIndex:row]];
        
    }else{
        [self.selectedArray removeObject:[self.myArray objectAtIndex:row]];
    }
    [self.myTable reloadData];
    
    [self setEditBtnEnableStatus];
}

- (void)doEdit {
    //只有单独勾选可对房源进行编辑
    if (self.selectedArray.count != 1) {
        return;
    }
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"定价推广", @"编辑房源", @"删除房源", nil];
    [action showInView:self.view];
}

-(void)mutableAction:(id) sender{
    if (self.myArray.count == 0) { //未推广房源被清空后不可全选
        return;
    }
    
    UIBarButtonItem *tempBtn = (UIBarButtonItem *)sender;
    
    if ([tempBtn.title isEqualToString:SELECT_ALL_STR]){
        [tempBtn setTitle:UNSELECT_ALL_STR];
        
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObjectsFromArray:self.myArray];
        [self.myTable reloadData];
    }else {
        [tempBtn setTitle:SELECT_ALL_STR];
        
        [self.selectedArray removeAllObjects];
        [self.myTable reloadData];
    }
    
    [self setEditBtnEnableStatus];
}

-(void)delete{
    if ([self.selectedArray count] == 0) {
        UIAlertView *tempView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请选择房源" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tempView show];
        return ;
    }
    
    UIAlertView *tempView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"确定删除房源？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [tempView show];
    
}

-(void)mutableFixed{
    if ([self.selectedArray count] == 0) {
        UIAlertView *tempView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请选择房源" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tempView show];
        return ;
    }
    
//    SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
//    controller.backType = RTSelectorBackTypePopToRoot;
//    [self.navigationController pushViewController:controller animated:YES];
}

//编辑按钮状态更改
- (void)setEditBtnEnableStatus {
    BOOL enabled = NO;
    DLog(@"selectArr [%d]", self.selectedArray.count);
    
    if (self.selectedArray.count == 1) {
        enabled = YES;
    }
    
    if (enabled) {
        [self.editBtn setTitleColor:SYSTEM_BLUE forState:UIControlStateNormal];
        self.editBtn.enabled = YES;
    }
    else {
        [self.editBtn setTitleColor:SYSTEM_LIGHT_GRAY forState:UIControlStateNormal];
        self.editBtn.enabled = NO;
    }
}

#pragma mark --UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
//        SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
//        [self.navigationController pushViewController:controller animated:YES];
    }else if (buttonIndex == 1){
        AnjukeEditPropertyViewController *controller = [[AnjukeEditPropertyViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (buttonIndex == 2){
        //删除房源
        [self.myArray removeObjectsInArray:self.selectedArray];
        [self.selectedArray removeAllObjects];
        
        [self.myTable reloadData];
        
        DLog(@"myArr [%d]", self.myArray.count);
        
        [self setEditBtnEnableStatus];
        
    }
}

#pragma mark --UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self.myArray removeObjectsInArray:self.selectedArray];
        [self.selectedArray removeAllObjects];
        
        [self.myTable reloadData];
        
        DLog(@"myArr [%d]", self.myArray.count);
        
        [self setEditBtnEnableStatus];
        [self.seleceAllItem setTitle:SELECT_ALL_STR];
    }
}

@end
