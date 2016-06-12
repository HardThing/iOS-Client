//
//  STPersonInfoViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/8/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STPersonInfoViewController.h"
#import "STPersonAuthViewController.h"
#import "STPersonModifyInfoViewController.h"
#import "STPersonModel.h"
#import "STPickerView.h"
#import "STSelectSchoolViewController.h"
#define kInfoCellIndentifier @"kInfoCellIndentifier"

#define kTableViewSectionHeight 20

@interface STPersonInfoViewController()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,STPickerViewDelegate>
{
    UITableView *infoTableView;
    NSArray *infoArr;
    NSArray *defaultInfoArr;
    NSArray *otherArr;//学校或者专业数据
    UIImageView *backView;
    UIImageView *header;
    STPickerView *currentPickerView;
    STPersonModel *personInfoModel;
}
@end

@implementation STPersonInfoViewController

#pragma mark -LifeCycle

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    [self configureUI];
    [self configureData];
    
    if ([STUserManager getUserId]) {
        [self loadDataFromServer];
    }
}

#pragma mark - View

- (void)configureUI{
    
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
    
    infoTableView = [[UITableView alloc]initWithFrame:SCREEN_FRAME style:UITableViewStylePlain];
    infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    infoTableView.showsVerticalScrollIndicator = NO;
    infoTableView.delegate = self;
    infoTableView.dataSource = self;
    [self.view addSubview:infoTableView];
    
    
    //ImageHead
    backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"private_bg.jpg"]];
    backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 311 / 2 + 64);
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor orangeColor];
    header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    header.center = backView.center;
    header.backgroundColor = [UIColor grayColor];
    header.layer.cornerRadius = 75 / 2.0;
    header.layer.borderWidth = 2;
    header.layer.borderColor = RGB(0xb2, 0xb2, 0xb2).CGColor;
    header.clipsToBounds = YES;
    header.userInteractionEnabled = YES;
    UITapGestureRecognizer *setHeaderTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setHeaderImageClick)];
    [header addGestureRecognizer:setHeaderTap];
    [backView addSubview:header];
    infoTableView.tableHeaderView = backView;
    [self setHeadImage];

}

#pragma mark - Data

- (void)configureData{
    
    defaultInfoArr = @[@[@"姓名",@"用户名",@"性别",@"出生日期",@"手机号",@"邮箱"],@[@"学校",@"学历",@"院系",@"入学年份"],@[@"身份认证"]];
}

- (void)loadDataFromServer{

    [[STHTTPRequest sharedClient] getPath:[NSString stringWithFormat:@"userInfos/%@",[STUserManager getUserId]] token:nil parameters:nil showProgressView:self.view showText:NSLocalizedString(@"STPersonLoading", nil) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 204) {
            [STHUD showText:[responseObject objectForKey:@"msg"] inView:self.view];
            return;
        }
        NSError *error;
        personInfoModel = [[STPersonModel alloc]initWithDictionary:[responseObject objectForKey:@"data"] error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [infoTableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

- (void)updateServerData:(NSString *)changedStr pickerViewType:(STPickerViewType)type pickerViewRow:(NSInteger)row{
    
    if (![STUserManager isLogin]) {
        [STHUD showErrorWithText:NSLocalizedString(@"STLoginNeed", nil) inView:self.view];
        return;
    }
    
    NSString *urlStr;
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    switch (type) {
        case STPickerViewTypeGender:
        {
            urlStr = @"userInfos/gender";
            [para setObject:[NSNumber numberWithInteger:row] forKey:@"gender"];
            [para setObject:[STUserManager getUserId] forKey:@"userId"];
        }
            break;
        case STPickerViewTypeEducation:
        {
            urlStr = [NSString stringWithFormat:@"userInfos/%@/educations",[STUserManager getUserId]];
            //需要接口修改

        }
            break;
        case STPickerViewTypeEnterSchoolYear:
        {
           //接口未给出
        }
            break;
            
        default:
            break;
    }
    
    [[STHTTPRequest sharedClient] putPath:urlStr token:nil parameters:para showProgressView:self.view showText:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 204) {
            [STHUD showText:[responseObject objectForKey:@"msg"] inView:self.view];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            personInfoModel.gender = row;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [infoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return defaultInfoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [defaultInfoArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kInfoCellIndentifier];

    if (!infoCell) {
        infoCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kInfoCellIndentifier];
        UILabel *separtorLine = [[UILabel alloc]initWithFrame:CGRectMake(0, infoCell.frame.size.height - 0.5, infoCell.frame.size.width, 0.5)];
        infoCell.textLabel.text = [defaultInfoArr[indexPath.section] objectAtIndex:indexPath.row];
        separtorLine.backgroundColor = BACKGROUND_COLOR;
        [infoCell.contentView addSubview:separtorLine];
    }
    if (indexPath.section == 0 &&indexPath.row == 1) {
        infoCell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        infoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    infoCell.detailTextLabel.text = personInfoModel.userName;
                }
                    break;
                case 1:
                {
                    infoCell.detailTextLabel.text = @"stp111111";
                }
                    break;
                case 2:
                {
                    NSString *gender;
                    if (!personInfoModel.gender) {
                        gender = @"女";
                    }
                    else{
                        gender = @"男";
                    }
                    infoCell.detailTextLabel.text = gender;
                }
                    break;
                case 3:
                {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
                    if (personInfoModel.birthday) {
                        [dateFormat setDateFormat: @"yyyy/MM/dd"];
                        infoCell.detailTextLabel.text = [dateFormat stringFromDate:personInfoModel.birthday];
                    }
                    else{
                        infoCell.detailTextLabel.text = @"1990/2/2";
                    }
                }
                    break;
                case 4:
                {
                    infoCell.detailTextLabel.text = personInfoModel.phone;
                }
                    break;
                case 5:
                {
                    infoCell.detailTextLabel.text = @"support@shetuanplus.com";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    infoCell.detailTextLabel.text = personInfoModel.schoolName;
                }
                    break;
                case 1:
                {
                    NSString *education;
                    switch (personInfoModel.education) {
                        case STEducationTypeBK:
                            education = @"本科";
                            break;
                            
                        case STEducationTypeZK:
                            education = @"专科";
                            break;
                           
                        case STEducationTypeBS:
                            education = @"博士";
                            break;
                           
                        case STEducationTypeSS:
                            education = @"硕士";
                            break;
                            
                        default:
                            break;
                    }
                    infoCell.detailTextLabel.text = education;
                }
                    break;
                case 2:
                {
                    infoCell.detailTextLabel.text = personInfoModel.collegeName;
                }
                    break;
                case 3:
                {
                    infoCell.detailTextLabel.text = [NSString stringWithFormat:@"%d",personInfoModel.beginTime];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
           infoCell.detailTextLabel.text = @"已认证";
        }
            break;
        default:
            break;
    }
    return infoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return kTableViewSectionHeight;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    STPersonModifyInfoViewController *personModifyVC = [[STPersonModifyInfoViewController alloc]init];
                    personModifyVC.titleStr = @"姓名修改";
                    personModifyVC.palceHolder = @"请输入姓名";
                    
                    personModifyVC.passBackName = ^(NSString *str){
                        personInfoModel.userName = str;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        [infoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [self.navigationController pushViewController:personModifyVC animated:YES];
                    
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                case 2:
                {
                    currentPickerView = [[STPickerView shardPickerView] initCommonPickerView:self.view scrollView:infoTableView type:STPickerViewTypeGender otherArr:nil appear:^(BOOL isShow) {
                    }];
                    currentPickerView.delegate = self;
                }
                    break;
                case 3:
                {
                    STPickerView *pickView = [[STPickerView shardPickerView] initDatePickerOfBirthday:self.view scrollView:infoTableView appear:^(BOOL isShow) {
                        
                        __weak typeof(self) weakSelf = self;
                        if (isShow) {
                            [weakSelf setViewMovedUp:YES WithMoveHeight:80];
                        }
                        else{
                            [weakSelf setViewMovedUp:NO WithMoveHeight:80];
                        }
                    }];
                    
                    pickView.delegate = self;
                
                }
                    break;
                case 4:
                {
                    
                }
                    break;
                case 5:
                {
                    
                }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
//                    STSelectSchoolViewController *selectSchoolVC = [[STSelectSchoolViewController alloc]init];
//                    [self.navigationController pushViewController:selectSchoolVC animated:YES];
                }
                    break;
                case 1:
                {
                    currentPickerView = [[STPickerView shardPickerView] initCommonPickerView:self.view scrollView:infoTableView type:STPickerViewTypeEducation otherArr:nil appear:^(BOOL isShow) {
                        __weak typeof(self) weakSelf = self;
                        if (isShow) {
                            [weakSelf setViewMovedUp:YES WithMoveHeight:380];
                        }
                        else{
                            [weakSelf setViewMovedUp:NO WithMoveHeight:380];
                        }
                    }];
                    currentPickerView.delegate = self;
                    
                }
                    break;
                case 2:
                {
                    
                    
                }
                    break;
                case 3:
                {
                    currentPickerView = [[STPickerView shardPickerView] initCommonPickerView:self.view scrollView:infoTableView type:STPickerViewTypeEnterSchoolYear otherArr:nil appear:^(BOOL isShow) {
                        __weak typeof(self) weakSelf = self;
                        if (isShow) {
                            [weakSelf setViewMovedUp:YES WithMoveHeight:400];
                        }
                        else{
                            [weakSelf setViewMovedUp:NO WithMoveHeight:400];
                        }
                    }];
                    currentPickerView.delegate = self;
                    
                }
                    break;
                default:
                    break;
            }
            break;
            
        case 2:
        {
            STPersonAuthViewController *authVC = [[STPersonAuthViewController alloc]init];
            [self.navigationController pushViewController:authVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Handler

- (void)setHeadImage{
    
    [header setImage:[UIImage imageNamed:@"Default_User"]];
}

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = kTableViewSectionHeight;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark PrivateMethod

- (void)setHeaderImageClick{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
            pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickController.allowsEditing = YES;
            pickController.delegate = self;
            [self presentViewController:pickController animated:YES completion:^{
                
            }];
        }
            break;
        case 1:
        {
            UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
            pickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickController.allowsEditing = YES;
            pickController.delegate = self;
            [self presentViewController:pickController animated:YES completion:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!originImage) {
            originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        UIGraphicsBeginImageContext(CGSizeMake(120, 120));
        [originImage drawInRect:CGRectMake(0, 0, 120, 120)];
        header.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }];
}

#pragma mark -STPickerViewDelegate

- (void)pickerView:(STPickerView *)pickerView didSelectDate:(NSDate *)date{
    
    NSLog(@"%@",date);
}

- (void)pickerView:(STPickerView *)pickerView didSelectRow:(NSInteger)row WithSelectedString:(NSString *)selectedStr{
   
    STPickerViewType type = currentPickerView.currentPickerViewType;
    switch (type) {
        case STPickerViewTypeGender:
        {
            [self updateServerData:nil pickerViewType:type pickerViewRow:row];
        }
            break;
        case STPickerViewTypeEducation:
        {
            NSLog(@"%@",selectedStr);
        }
            break;
        case STPickerViewTypeEnterSchoolYear:
        {
            NSLog(@"%@",selectedStr);
        }
            break;
    
        default:
            break;
    }
}

-(void)setViewMovedUp:(BOOL)movedUp WithMoveHeight:(CGFloat)moveHeight
{
    if (movedUp)
    {
        [infoTableView setContentOffset:CGPointMake(0, moveHeight) animated:YES];
    }
    else
    {
       [infoTableView setContentOffset:CGPointMake(0, -moveHeight) animated:YES];
    }

}
@end
