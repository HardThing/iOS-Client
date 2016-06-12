//
//  STPersonSetAboutViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/22/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STPersonSetAboutViewController.h"

NSString * const kSetAboutCellIndentifier = @"kSetAboutCellIndentifier";

@interface STPersonSetAboutViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *defaultDataArr;
}
@property (nonatomic,strong)UITableView *aboutTableView;

@end

@implementation STPersonSetAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialUI];
    [self initialData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initialUI{
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.title = @"关于";
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
    
    
    _aboutTableView = [[UITableView alloc]initWithFrame:SCREEN_FRAME style:UITableViewStyleGrouped];
    _aboutTableView.delegate = self;
    _aboutTableView.dataSource = self;
    _aboutTableView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_aboutTableView];
    
    
    //ContentView
    //headView
//    UIView *tableHeadView = [[UIView alloc]init];
//    _aboutTableView.tableHeaderView = tableHeadView;
//    tableHeadView.translatesAutoresizingMaskIntoConstraints = NO;
//    [tableHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 188));
//    }];
    UIView *tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 158)];
    _aboutTableView.tableHeaderView = tableHeadView;
    
    UIImageView *stLogoImageView = [[UIImageView alloc]init];
    stLogoImageView.image = [UIImage imageNamed:@"Person_Set_About_Logo"];
    [tableHeadView addSubview:stLogoImageView];
    [stLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableHeadView).offset(34);
        make.leading.equalTo(tableHeadView).offset((SCREEN_WIDTH - 60) / 2);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UILabel *stVersionLabel = [[UILabel alloc]init];
    [tableHeadView addSubview:stVersionLabel];
    [stVersionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stLogoImageView.mas_bottom).offset(10);
        make.leading.equalTo(tableHeadView).offset((SCREEN_WIDTH - 80) / 2);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    stVersionLabel.text = @"版本号 1.0";
    stVersionLabel.textColor = [UIColor lightGrayColor];
    
    
    //footView
    UIView *tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    _aboutTableView.tableFooterView = tableFootView;
    UILabel *copyRightLabel = [[UILabel alloc] init];
    copyRightLabel.textColor = [UIColor lightGrayColor];
    copyRightLabel.text = @"社团Plus 版权所有";
    copyRightLabel.textAlignment = NSTextAlignmentCenter;
    copyRightLabel.font = [UIFont systemFontOfSize:15.0];
    [tableFootView addSubview:copyRightLabel];
    
    [copyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableFootView.mas_top).offset(20);
        make.leading.equalTo(tableFootView.mas_leading);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];
    UILabel *copyRightEnglish = [[UILabel alloc]init];
    copyRightEnglish.textColor = [UIColor lightGrayColor];
    copyRightEnglish.text = @"  Copyright 2015 ShetuanPlus. All Rights Reserved ";
    copyRightEnglish.textAlignment = NSTextAlignmentCenter;
    copyRightEnglish.font = [UIFont systemFontOfSize:13.0];
    [tableFootView addSubview:copyRightEnglish];
    [copyRightEnglish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(copyRightLabel.mas_bottom);
        make.leading.equalTo(tableFootView.mas_leading);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];

}

#pragma mark - Handler

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Data

- (void)initialData{
    
    defaultDataArr = @[@[@"推荐给好友",@"给我们评分"],@[@"功能介绍",@"联系我们"]];
    
}
#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return defaultDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[defaultDataArr objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *aboutCell = [tableView dequeueReusableCellWithIdentifier:kSetAboutCellIndentifier];
    if (!aboutCell) {
        aboutCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSetAboutCellIndentifier];
        aboutCell.textLabel.text = [[defaultDataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        aboutCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return aboutCell;
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
