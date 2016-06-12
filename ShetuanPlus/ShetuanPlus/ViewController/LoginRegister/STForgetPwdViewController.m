//
//  STForgetPwdViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/28/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STForgetPwdViewController.h"
#import "STResetPwdViewController.h"
#import "NSString+st_extension.h"
@implementation STForgetPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"找回密码";
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
    
    // input area
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, 88)];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    
    accountTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 130, 44)];
    accountTF.placeholder = @"请输入账号";
    accountTF.keyboardType = UIKeyboardTypeEmailAddress;
    accountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTF.delegate = self;
    [inputView addSubview:accountTF];
    
    verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 44, SCREEN_WIDTH - 30, 44)];
    verifyTF.placeholder = @"验证码";
    verifyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyTF.keyboardType = UIKeyboardTypeNumberPad;
    verifyTF.delegate = self;
    [inputView addSubview:verifyTF];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 1)];
    separator.backgroundColor = RGB(239, 239, 239);
    [inputView addSubview:separator];
    
    // sendBtn
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, inputView.frame.origin.y + inputView.frame.size.height + 20, SCREEN_WIDTH - 40, 44)];
    [sendBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[[UIImage imageNamed:@"Button BackgroudColor"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]  forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.layer.cornerRadius = 3;
    sendBtn.clipsToBounds = YES;
    [self.view addSubview:sendBtn];
    
    queryCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 44)];
    [queryCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [queryCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    queryCodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    queryCodeBtn.backgroundColor = APPBULECOLOR;
    queryCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [queryCodeBtn addTarget:self action:@selector(queryVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:queryCodeBtn];
}

- (void)dealloc
{
    accountTF = nil;
    verifyTF = nil;
    queryCodeBtn = nil;
    [remainingTimer invalidate];
    remainingTimer = nil;
}

- (void)endEditing
{
    [self.view endEditing:YES];
}

#pragma mark - Button Action

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendBtnClicked
{
    [self.view endEditing:YES];
    if (accountTF.text.length == 0) {
        [STHUD showText:NSLocalizedString(@"STAccountIsNil", nil) inView:self.view];
        return;
    }
    if (verifyTF.text.length == 0){
        [STHUD showText:NSLocalizedString(@"STVerifyIsNil", nil) inView:self.view];
        return;
    }
    if (![NSString isMobileNumber:accountTF.text] && ![NSString isValidEmailAddress:accountTF.text]) {
        [STHUD showText:NSLocalizedString(@"STAccountInvalid", nil) inView:self.view];
        return;
    }
    if (![NSString isValidVerifyCode:verifyTF.text]){
        [STHUD showText:NSLocalizedString(@"STVerifyIsvaild", nil) inView:self.view];
        return;
    }
    [[STHTTPRequest sharedClient] getPath:STVERIFIED_CODE token:nil parameters:@{@"account":accountTF.text,@"code":verifyTF.text} showProgressView:self.view showText:NSLocalizedString(@"STCommitData", nil) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (operation.response.statusCode == 200) {
            if ([[responseObject objectForKey:@"code"] integerValue] != 200) {
                [STHUD showText:[responseObject objectForKey:@"msg"] inView:self.view];
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                STResetPwdViewController *resetPwdVC = [[STResetPwdViewController alloc]init];
                [self.navigationController pushViewController:resetPwdVC animated:YES];
            });
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)queryVerifyCode
{
    [self.view endEditing:YES];
    if (accountTF.text.length == 0) {
        [STHUD showText:NSLocalizedString(@"STAccountIsNil", nil) inView:self.view];
        return;
    }
    
    if (![NSString isMobileNumber:accountTF.text] && ![NSString isValidEmailAddress:accountTF.text]) {
        [STHUD showText:NSLocalizedString(@"STAccountInvalid", nil) inView:self.view];
        return;
    }
    [[STHTTPRequest sharedClient] getPath:STREGISTER_AVAILABLE token:nil parameters:@{@"account":accountTF.text} showProgressView:self.view showText:NSLocalizedString(@"STVerifying", nil) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"] integerValue] != 200) {
        }
        if (operation.response.statusCode == 200){
            if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
                [STHUD showText:NSLocalizedString(@"STAccountNoExist", nil) inView:self.view];
                return ;
            }
            if ([[responseObject objectForKey:@"code"] integerValue] == 202) {
                
                [[STHTTPRequest sharedClient] getPath:STVERIFIED_CODE token:nil parameters:@{@"account":accountTF.text} showProgressView:self.view showText:NSLocalizedString(@"STVerifying", nil) success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [STHUD showText:NSLocalizedString(@"STGetVerifyCodeSuccess", nil) inView:self.view];
                        queryCodeBtn.enabled = NO;
                        queryCodeBtn.alpha = 1.0;
                        remainNum = 59;
                        remainingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(decreaseTime) userInfo:nil repeats:YES];
                    });
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
                }];
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == 0) {
            [STHUD showText:error.domain inView:self.view];
            return ;
        }
    
    }];

}

- (void)decreaseTime
{
    if (remainNum != 0) {
        [queryCodeBtn setTitle:[NSString stringWithFormat:@"(%ld秒)重新获取",remainNum] forState:UIControlStateDisabled];
        queryCodeBtn.alpha = 0.7;
        remainNum--;
    }
    else
    {
        [queryCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [queryCodeBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
        queryCodeBtn.enabled = YES;
        queryCodeBtn.alpha = 1.0;
        [remainingTimer invalidate];
        remainingTimer = nil;
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqual: @""]) {
        return YES;
    }
    if (textField == accountTF) {
        return textField.text.length >= 22 ? NO : YES;
    }
    if (textField == verifyTF) {
        return textField.text.length >= 6 ? NO : YES;
    }
    return YES;
}


@end
