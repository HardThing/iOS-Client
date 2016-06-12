//
//  STClubViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/6/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STClubViewController.h"
#import "STSelectSchoolViewController.h"
#import "STClubTableViewCell.h"

#define STCLUBCELLINDENTIFIER @"STCLUBCELLINDENTIFIER"

const CGFloat STCLUBSEARCHBARHEIGHT = 44.0;

@implementation STClubViewController{
@private
    UITableView *clubTableView;
    UISearchBar *clubSearchBar;
    NSString *selectedSchool;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"组织";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"学校选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectSchoolAction)];
    self.navigationItem.rightBarButtonItem.tintColor = APPBULECOLOR;
    
    [self createUIAction];
}

#pragma mark - SetView

- (void)createUIAction{
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:hideTap];
    
    clubSearchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    clubSearchBar.placeholder = @"请输入组织关键字";
    clubSearchBar.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:clubSearchBar];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    //TableViewConfigure
    clubTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    clubTableView.delegate = self;
    clubTableView.dataSource = self;
    clubTableView.showsVerticalScrollIndicator = NO;
    clubTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [clubTableView registerClass:[STClubTableViewCell class] forCellReuseIdentifier:STCLUBCELLINDENTIFIER];
    clubTableView.rowHeight = 88.0;
    
    clubTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    [self.view addSubview:clubTableView];
    
    //AutoLayout
    [clubSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(64.0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, STCLUBSEARCHBARHEIGHT));
    }];
    [clubTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(clubSearchBar.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - STCLUBSEARCHBARHEIGHT));
    }];
    
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    STClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STCLUBCELLINDENTIFIER];
    if (indexPath == 0) {
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

#pragma mark - ActionMethod

- (void)selectSchoolAction{

    STSelectSchoolViewController *selectVC = [[STSelectSchoolViewController alloc]initWithPassSchoolNameBlock:^(NSString *schoolName) {
        selectedSchool = schoolName;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:schoolName style:UIBarButtonItemStylePlain target:self action:@selector(selectSchoolAction)];
        self.navigationItem.rightBarButtonItem.tintColor = APPBULECOLOR;
    }];
    [self.navigationController pushViewController:selectVC animated:YES];
}

- (void)hideKeyBoard{
    
    [self.view endEditing:YES];
}

@end
