//
//  STPersonModifyInfoViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/26/15.
//  Copyright © 2015 Jiao Liu. All rights reserved.
//

#import "STPersonModifyInfoViewController.h"

@interface STPersonModifyInfoViewController ()
{
    UITextField *modifyTextField;
}
@end

@implementation STPersonModifyInfoViewController

#pragma mark - LifeCycle

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfo)];
    self.navigationItem.rightBarButtonItem.tintColor = APPBULECOLOR;
    
    
    CGFloat inpuViewHeight = 55;
    UIView *inputView = [[UIView alloc]init];
    [self.view addSubview:inputView];
    inputView.backgroundColor = [UIColor whiteColor];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.leading.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, inpuViewHeight));
    }];
    
    modifyTextField = [[UITextField alloc]init];
    [inputView addSubview:modifyTextField];
    [modifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView);
        make.leading.equalTo(inputView).offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, inpuViewHeight));
    }];
    
    if (self.palceHolder) {
        modifyTextField.placeholder = self.palceHolder;
    }
    if (self.titleStr) {
        self.title = self.titleStr;
    }
}
#pragma mark - Handler 

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PrivateMethod

- (void)saveInfo{
    
    [self.view endEditing:YES];
    if ([modifyTextField.text isEqualToString:@""]) {
        [STHUD showErrorWithText:NSLocalizedString(@"STPersonUsernameIsNil", nil) inView:self.view];
        return;
    }
  
    //检测是否登录
    if (![STUserManager isLogin]) {
        [STHUD showErrorWithText:NSLocalizedString(@"STLoginNeed", nil) inView:self.view];
        return;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[STUserManager getUserId] forKey:@"userId"];
    [para setObject:modifyTextField.text forKey:@"userName"];
    
    [[STHTTPRequest sharedClient] putPath:PERSONAL_MODIFY_NAME token:nil parameters:para showProgressView:self.view showText:NSLocalizedString(@"STCommitData", nil) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [STHUD showSuccessWithText:NSLocalizedString(@"STCommitSuccess", nil) inView:self.view];
        self.passBackName(modifyTextField.text);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
