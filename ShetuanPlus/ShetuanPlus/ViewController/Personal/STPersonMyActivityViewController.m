//
//  STPersonMyActivityViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/22/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STPersonMyActivityViewController.h"
#import "STTabSelectView.h"
#import "STActivityTableViewCell.h"
@interface STPersonMyActivityViewController ()<STTabSelectViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *myActivityTableView;

@end

@implementation STPersonMyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initialUI{
    
    self.title = @"我的活动";
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Person_Search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchActivity)];
    self.navigationItem.rightBarButtonItem.tintColor = APPBULECOLOR;
    
    UIView *tabContainerView = [[UIView alloc]init];
    [self.view addSubview:tabContainerView];

    [tabContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.leading.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
//    tabContainerView.backgroundColor = [UIColor redColor];
    STTabSelectView *selectTabView = [[STTabSelectView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) WithItems:@[@"即将开始",@"已经结束"] WithDelegate:self];
    [tabContainerView addSubview:selectTabView];
    
    _myActivityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44) style:UITableViewStylePlain];
    _myActivityTableView.delegate = self;
    _myActivityTableView.dataSource = self;
    _myActivityTableView.backgroundColor = [UIColor clearColor];
    [_myActivityTableView registerClass:[STActivityTableViewCell class] forCellReuseIdentifier:@"Activity_Cell"];
    [self.view addSubview:_myActivityTableView];
}



#pragma mark - Data

#pragma mark - Handler

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Method

- (void)searchActivity{
    
}

#pragma mark - Delegate

- (void)itemBtnClicked:(NSInteger)itemIndex{
    NSLog(@"%d",itemIndex);
}

#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STActivityTableViewCell *cell = [self.myActivityTableView dequeueReusableCellWithIdentifier:@"Activity_Cell"];
    cell.backgroundColor = BACKGROUND_COLOR;
    if (indexPath.row == 0) {
        cell.title = @"街舞空间";
        cell.time = @"1999/2/3";
        cell.location = @"清华大学";
        cell.supportNum = 10;
        cell.fundNum = 23223332;
        //        cell.image = [UIImage imageNamed:@"Activity_Fund"];
        cell.image = [UIImage imageNamed:@"Personal_Certificatied"];
    }
    else
    {
        cell.title = @"World";
        cell.time = @"2009/12/13";
        cell.location = @"Now";
        cell.supportNum = 40222160;
        cell.fundNum = 201023.23;
        cell.image = [UIImage imageNamed:@"Default_Img"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myActivityTableView deselectRowAtIndexPath:indexPath animated:YES];
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
