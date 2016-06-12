//
//  STPersonSetViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/9/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STPersonSetViewController.h"
#import "STPersonSetAboutViewController.h"
#define kSetNormalCellIndentifier @"kSetNormalCellIndentifier"
#define kSetExitCellIndentifier @"kSetExitCellIndentifier"
#define kSetSwitchCellIndentifier @"kSetSwitchCellIndentifier"
#define kSetTextCellIndentifier @"kSetTextCellIndentifier"

#define kTableViewSectionHeight 20
@interface STPersonSetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *setTableView;
    NSArray *setDefaultDataArr;
    UISwitch *showImageSwitch;
    UISwitch *pushMessageSwitch;
    UISwitch *showPersonInfoSwitch;
}
@end

@implementation STPersonSetViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configureData];
    [self configureUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View

- (void)configureUI{
    
    self.title = @"设置";
    self.view.backgroundColor = BACKGROUND_COLOR;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:APPBULECOLOR forState:UIControlStateNormal];
    [backBtn setTitleColor:APPBULECOLOR forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem.tintColor = APPBULECOLOR;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    setTableView = [[UITableView alloc]initWithFrame:SCREEN_FRAME style:UITableViewStyleGrouped];
    setTableView.tableFooterView = [[UIView alloc]init];
    setTableView.backgroundColor = BACKGROUND_COLOR;
    setTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    setTableView.delegate = self;
    setTableView.dataSource = self;
    [self.view addSubview:setTableView];
    
}

#pragma mark - Data

- (void)configureData{

    setDefaultDataArr = @[@[@"非WIFI网络不显示图片",@"开启消息推送",@"是否显示个人联系方式"],
                          @[@"清理缓存",@"检测升级"],
                          @[@"关于",@"修改密码",@"意见反馈"],
                          @[@"退出当前账号"]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return setDefaultDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[setDefaultDataArr objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:kSetNormalCellIndentifier];
    UITableViewCell *exitCell = [tableView dequeueReusableCellWithIdentifier:kSetExitCellIndentifier];
    UITableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:kSetSwitchCellIndentifier];
    UITableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:kSetTextCellIndentifier];
    
    if (!normalCell) {
        
        normalCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSetNormalCellIndentifier];
        normalCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (!exitCell) {
        
        exitCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSetExitCellIndentifier];
        UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [exitBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [exitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [exitBtn setTitle:@"退出当前账号" forState:UIControlStateHighlighted];
        [exitBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [exitCell.contentView addSubview:exitBtn];
        [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.top.bottom.equalTo(exitCell);
            make.size.mas_equalTo(CGSizeMake(120, exitCell.frame.size.height));
        }];
    }
    if (!switchCell) {
        
        CGFloat swiftchOffSet_right = 4.0;
        CGFloat switchWidth = 60;
        CGFloat switchOffSet_left = SCREEN_WIDTH - swiftchOffSet_right - switchWidth;
        CGFloat switchOffSet_y = 6.5;
        switchCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSetNormalCellIndentifier];
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                {
                    showImageSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(switchOffSet_left, switchOffSet_y, switchWidth, switchCell.frame.size.height - 2 * switchOffSet_y)];
                    showImageSwitch.on = YES;
                    [showImageSwitch addTarget:self action:@selector(showImageAction:) forControlEvents:UIControlEventValueChanged];
                    [switchCell.contentView addSubview:showImageSwitch];
                }
                    break;
                case 1:
                {
                    pushMessageSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(switchOffSet_left, switchOffSet_y, switchWidth, switchCell.frame.size.height - 2 * switchOffSet_y)];
                    [pushMessageSwitch addTarget:self action:@selector(controlPushAction:) forControlEvents:UIControlEventValueChanged];
                    [switchCell.contentView addSubview:pushMessageSwitch];
                }
                    break;
                case 2:
                {
                    showPersonInfoSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(switchOffSet_left, switchOffSet_y, switchWidth, switchCell.frame.size.height - 2 * switchOffSet_y)];
                    [showPersonInfoSwitch addTarget:self action:@selector(showPersonInfoAction:) forControlEvents:UIControlEventValueChanged];
                    [switchCell.contentView addSubview:showPersonInfoSwitch];
                }
                    break;
                default:
                    break;
            }
            
        }
    }
    if (!textCell) {
        switch (indexPath.row) {
            case 0:
            {
                textCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSetExitCellIndentifier];
                textCell.detailTextLabel.text = @"10.4K";
            }
                break;
            case 1:
            {
                textCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSetExitCellIndentifier];
            }
                break;
                
            default:
                break;
        }
        
    }
    NSString *detailText = [[setDefaultDataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
        
        switchCell.textLabel.text = detailText;
        return switchCell;
    }
    if (indexPath.section == 1) {
        
        textCell.textLabel.text = detailText;
        return textCell;
    }
    if (indexPath.section == 2) {
        
        normalCell.textLabel.text = detailText;
        return normalCell;
    }
    if (indexPath.section == 3) {
        
        return exitCell;
    }
    return normalCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            
            
        }
            break;
        case 1:
        {
            
            
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    STPersonSetAboutViewController *setAboutVC = [[STPersonSetAboutViewController alloc]init];
                    [self.navigationController pushViewController:setAboutVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
  
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Handler

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper

- (void)showImageAction:(id)sender{
    NSLog(@"%s",__func__);
}

- (void)controlPushAction:(id)sender{
    NSLog(@"%s",__func__);
}

- (void)showPersonInfoAction:(id)sender{
    NSLog(@"%s",__func__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
