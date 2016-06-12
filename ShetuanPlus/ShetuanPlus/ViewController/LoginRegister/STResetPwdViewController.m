
//  STResetPwdViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 9/6/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STResetPwdViewController.h"
#import "STInsetTextField.h"
@interface STResetPwdViewController ()<UITextFieldDelegate>
{
    UITextField *newPwdTF;
    UITextField *confirmPwdTF;
}
@end

@implementation STResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSet];
    [self drawUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CustomSet

- (void)customSet{
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"设置新密码";
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
    
    // add TapGes
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes addTarget:self action:@selector(endEditing)];
    [self.view addGestureRecognizer:tapGes];
}

- (void)drawUI{
    // input area
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, 88)];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    
    newPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 44)];
    newPwdTF.placeholder = @"请输入新密码";
    newPwdTF.keyboardType = UIKeyboardTypeDefault;
    newPwdTF.secureTextEntry = YES;
    newPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    newPwdTF.delegate = self;
    [inputView addSubview:newPwdTF];
    
    confirmPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 44, SCREEN_WIDTH - 30, 44)];
    confirmPwdTF.placeholder = @"请再次输入新密码";
    confirmPwdTF.secureTextEntry = YES;
    confirmPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmPwdTF.keyboardType = UIKeyboardTypeDefault;
    confirmPwdTF.delegate = self;
    [inputView addSubview:confirmPwdTF];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 1)];
    separator.backgroundColor = RGB(239, 239, 239);
    [inputView addSubview:separator];
    
    // sendBtn
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, inputView.frame.origin.y + inputView.frame.size.height + 20, SCREEN_WIDTH - 40, 44)];
    [sendBtn setTitle:@"确 认" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[[UIImage imageNamed:@"Button BackgroudColor"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]  forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(modifyPwdBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.layer.cornerRadius = 3;
    sendBtn.clipsToBounds = YES;
    [self.view addSubview:sendBtn];
}
#pragma mark - Button Action

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endEditing{
    
    [self.view endEditing:YES];
}

- (void)modifyPwdBtnClicked{
    
    [self.view endEditing:YES];
    if (newPwdTF.text.length == 0) {
        [STHUD showText:NSLocalizedString(@"STPwdIsNil", nil) inView:self.view];
        return;
    }
    if (confirmPwdTF.text.length == 0){
        [STHUD showText:NSLocalizedString(@"STPwdConfirmIsNil", nil) inView:self.view];
        return;
    }
    if (![newPwdTF.text isEqual:confirmPwdTF.text]) {
        [STHUD showText:NSLocalizedString(@"STRegPwdDifferent", nil) inView:self.view];
        return;
    }
    [[STHTTPRequest sharedClient] getPath:STRESET_PASSWORD token:nil parameters:@{@"account":[STUserManager getUsername],@"newPwd":newPwdTF.text} showProgressView:self.view showText:NSLocalizedString(@"STCommitData", nil) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode != 200) {
            return ;
        }
        if (operation.response.statusCode == 200) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[responseObject objectForKey:@"code"] integerValue] != 200) {
                    [STHUD showText:[responseObject objectForKey:@"msg"] inView:self.view];
                    return;
                }
                [STHUD showText:NSLocalizedString(@"STPwdModifySuccess", nil) inView:self.view];
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqual: @""]) {
        return YES;
    }
    if (textField == newPwdTF) {
        return textField.text.length >= 22 ? NO : YES;
    }
    if (textField == confirmPwdTF) {
        return textField.text.length >= 22 ? NO : YES;
    }
    return YES;
}

@end
