//
//  STPersonInforViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/6/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STPersonCenterViewController.h"
#import "STPersonInfoViewController.h"
#import "STPersonSetViewController.h"
#import "STPersonMyActivityViewController.h"

@implementation STPersonCenterViewController

- (id)init
{
    self = [super init];
    if (self) {
        listView = [[UITableView alloc] initWithFrame:SCREEN_FRAME style:UITableViewStyleGrouped];
        listView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        listView.backgroundColor = BACKGROUND_COLOR;
        listView.tableFooterView = [UIView new];
        listView.delegate = self;
        listView.dataSource = self;
        
        headImgView = [[UIImageView alloc] init];
        headImgView.image = [UIImage imageNamed:@"Default_User"];
        headImgView.layer.cornerRadius = 5;
        headImgView.clipsToBounds = YES;
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = @"安妮";
        nameLabel.font = [UIFont boldSystemFontOfSize:18.0];
        
        idLabel = [[UILabel alloc] init];
        idLabel.backgroundColor = [UIColor clearColor];
        idLabel.text = @"用户名：stp12012";
        idLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人中心";
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self.view addSubview:listView];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
            
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 80;
            break;
            
        default:
            return 44;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Personal_Cell%ld", (long)[indexPath section]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0){
        headImgView.frame = CGRectMake(10, 10, 60, 60);
        [cell.contentView addSubview:headImgView];
        
        nameLabel.frame = CGRectMake(90, 10, 200, 30);
        [cell.contentView addSubview:nameLabel];
        
        idLabel.frame = CGRectMake(90, 40, 200, 20);
        [cell.contentView addSubview:idLabel];
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"我的组织";
                cell.imageView.image = [UIImage imageNamed:@"Personal_Club"];
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"我的活动";
                cell.imageView.image = [UIImage imageNamed:@"Personal_Activity"];
            }
                break;
                
            default:
            {
                cell.textLabel.text = nil;
                cell.imageView.image = nil;
            }
                break;
        }
    }
    if (indexPath.section == 2){
        cell.textLabel.text = @"我的赞助券";
        cell.imageView.image = [UIImage imageNamed:@"Personal_Ticket"];
    }
    if (indexPath.section == 3){
        cell.textLabel.text = @"设置";
        cell.imageView.image = [UIImage imageNamed:@"Personal_Setting"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            STPersonInfoViewController *personInfoVC = [[STPersonInfoViewController alloc]init];
            [self.navigationController pushViewController:personInfoVC animated:YES];
        }
            return;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                //我的组织
                }
                    break;
                case 1:
                {
                    STPersonMyActivityViewController *myActivityVC = [[STPersonMyActivityViewController alloc]init];
                    [self.navigationController pushViewController:myActivityVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            return;
        case 3:
        {
            STPersonSetViewController *setVC = [[STPersonSetViewController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
            
        }
            return;
            
        default:
            return;
    }
}

@end
