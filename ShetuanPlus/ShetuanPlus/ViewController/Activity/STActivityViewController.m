//
//  STActivityViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/6/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STActivityViewController.h"
#import "STActivityTableViewCell.h"
#import "STSelectSchoolViewController.h"

@interface STActivityViewController()
{
    NSString *selectedSchool;
}
@end
@implementation STActivityViewController

- (id)init
{
    self = [super init];
    if (self) {
        ActivityListView = [[UITableView alloc] initWithFrame:SCREEN_FRAME];
        ActivityListView.contentInset = UIEdgeInsetsMake(44, 0, 50, 0);
        ActivityListView.backgroundColor = BACKGROUND_COLOR;
        ActivityListView.dataSource = self;
        ActivityListView.delegate = self;
        ActivityListView.tableFooterView = [UIView new];
        [ActivityListView registerClass:[STActivityTableViewCell class] forCellReuseIdentifier:@"Activity_Cell"];
        ActivityListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"活动";
    
    [self.view addSubview:ActivityListView];
    
//    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarItemClicked)];
//    searchBarItem.tintColor = RGB(80, 210, 255);
//    self.navigationItem.rightBarButtonItem = searchBarItem;
    schoolBtn = [[UIBarButtonItem alloc] initWithTitle:@"选择学校" style:UIBarButtonItemStylePlain target:self action:@selector(schoolBtnClicked)];
    schoolBtn.tintColor = RGB(80, 210, 255);
    self.navigationItem.rightBarButtonItem = schoolBtn;
    
    UISearchBar *activitySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, 44)];
    activitySearchBar.tintColor = RGB(80, 210, 255);
    activitySearchBar.placeholder = @"请输入活动关键字";
    [self.view addSubview:activitySearchBar];
    
    displayController = [[UISearchDisplayController alloc] initWithSearchBar:activitySearchBar contentsController:self];
    displayController.delegate = self;
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//    head.backgroundColor = BACKGROUND_COLOR;
//    
//    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
//    separator.backgroundColor = [UIColor lightGrayColor];
//    [head addSubview:separator];
//    
//    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"人气活动",@"最新活动"]];
//    segmentControl.frame = CGRectMake(5, 7, SCREEN_WIDTH / 3.0 * 2, 30);
//    segmentControl.tintColor = RGB(80, 210, 255);
//    [segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
//    segmentControl.selectedSegmentIndex = 0;
//    
//    schoolBtn = [[UIButton alloc] initWithFrame:CGRectMake(segmentControl.frame.origin.x + segmentControl.frame.size.width + 10, 7, SCREEN_WIDTH / 3.0 - 20, 30)];
//    schoolBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [schoolBtn setTitle:@"选择学校" forState:UIControlStateNormal];
//    [schoolBtn setTitleColor:RGB(80, 210, 255) forState:UIControlStateNormal];
//    [schoolBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [schoolBtn addTarget:self action:@selector(schoolBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//   
//    [head addSubview:schoolBtn];
//    [head addSubview:segmentControl];
//    return head;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Activity_Cell"];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SearchDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [UIView animateWithDuration:0.3 animations:^{
        controller.searchBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTabbar" object:nil];
    }];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [UIView animateWithDuration:0.3 animations:^{
        controller.searchBar.frame = CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, 44);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTabbar" object:nil];
    }];
}

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    searchBar.showsCancelButton = YES;
//}
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    searchBar.showsCancelButton = NO;
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    searchBar.text = nil;
//    [searchBar endEditing:YES];
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar endEditing:YES];
//}

#pragma mark - Action

//- (void)segmentChanged:(UISegmentedControl *)sender
//{
//    NSLog(@"%ld",(long)sender.selectedSegmentIndex);
//}

- (void)schoolBtnClicked
{
    STSelectSchoolViewController *selectVC = [[STSelectSchoolViewController alloc]initWithPassSchoolNameBlock:^(NSString *schoolName) {
        selectedSchool = schoolName;
        schoolBtn = [[UIBarButtonItem alloc] initWithTitle:schoolName style:UIBarButtonItemStylePlain target:self action:@selector(schoolBtnClicked)];
        schoolBtn.tintColor = RGB(80, 210, 255);
        self.navigationItem.rightBarButtonItem = schoolBtn;
    }];
    [self.navigationController pushViewController:selectVC animated:YES];
}

//- (void)searchBarItemClicked
//{
//    
//}

@end
