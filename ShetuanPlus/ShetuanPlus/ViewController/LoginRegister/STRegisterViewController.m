//
//  STRegisterViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/7/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STRegisterViewController.h"
#import "NSString+st_extension.h"

#define kOFFSET_FOR_KEYBOARD 80.0
#define kTabBarHeight 44.0

@implementation STRegisterViewController
@synthesize registerType;

#pragma mark - LifeCycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    //Navigation
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    regScrollView = [[UIScrollView alloc]initWithFrame:SCREEN_FRAME];
    regScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
    regScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:regScrollView];
    
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
    [self.view addGestureRecognizer:tapGesture];
    //Create Register View
    [self registerTypeDrawUI];
    //keyBoard notification register
    [self registerNotification];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - RegisterNotification
- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - KeyboardLeadAction

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    regScrollView.contentInset = contentInsets;
    regScrollView.scrollIndicatorInsets = contentInsets;

    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, accountTF.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, accountTF.frame.origin.y-kbSize.height);
        [regScrollView setContentOffset:scrollPoint animated:YES];
        NSLog(@"%f",scrollPoint.y);
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    regScrollView.contentInset = contentInsets;
    regScrollView.scrollIndicatorInsets = contentInsets;
    [regScrollView setContentOffset:CGPointMake(0, -64) animated:YES];
    
    
}
#pragma mark - CreatUIAction

- (void)creatUIAction:(NSInteger)type{
    
    CGFloat kLeftPadding = 0.0;
    CGFloat kTopPadding = 34.0;
    //kWidget
    
    CGFloat kWidgetHeight = 44.0;
    CGFloat kWidgetLeftPadding = 15.0;
    CGFloat kWidgetWidth = SCREEN_WIDTH - 2 * kWidgetLeftPadding;
    CGFloat kSepartorHeight = 1.0;
    CGFloat kAuthBtnWidth = 100.0;
    
    segmented = [[UISegmentedControl alloc]initWithItems:@[@"手机",@"邮箱"]];
    
    segmented.frame = CGRectMake(5, kTopPadding, SCREEN_WIDTH - 2 * 5, kWidgetHeight / 1.5);
    [[[segmented subviews] objectAtIndex:0] setTintColor:APPBULECOLOR];
    [[[segmented subviews] objectAtIndex:1] setTintColor:APPBULECOLOR];
    segmented.selectedSegmentIndex = 0;
    [segmented addTarget:self action:@selector(setSegmentedControlStyle) forControlEvents:UIControlEventValueChanged];
    [regScrollView addSubview:segmented];
    
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(kLeftPadding, CGRectGetMaxY(segmented.frame) + 10, SCREEN_WIDTH - 2 * kLeftPadding, kWidgetHeight * 4)];
    inputView.backgroundColor = [UIColor whiteColor];
    [regScrollView addSubview:inputView];
    
    accountTF = [[UITextField alloc] initWithFrame:CGRectMake(kWidgetLeftPadding, 0, kWidgetWidth - kAuthBtnWidth, kWidgetHeight)];
    accountTF.placeholder = @"请输入手机号";
    accountTF.keyboardType = UIKeyboardTypeEmailAddress;
    accountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTF.delegate = self;
    [accountTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [inputView addSubview:accountTF];
    
    verifycodeText = [[UITextField alloc] initWithFrame:CGRectMake(kWidgetLeftPadding, CGRectGetMaxY(accountTF.frame), SCREEN_WIDTH - kWidgetLeftPadding, kWidgetHeight)];
    verifycodeText.placeholder = @"验证码";
    verifycodeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifycodeText.keyboardType = UIKeyboardTypeNumberPad;
    verifycodeText.delegate = self;
    [verifycodeText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [inputView addSubview:verifycodeText];
    
    pwdText = [[UITextField alloc] initWithFrame:CGRectMake(kWidgetLeftPadding, CGRectGetMaxY(verifycodeText.frame), SCREEN_WIDTH - kWidgetLeftPadding, kWidgetHeight)];
    pwdText.placeholder = @"请输入密码";
    pwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdText.secureTextEntry = YES;
    pwdText.returnKeyType = UIReturnKeyDefault;
    pwdText.delegate = self;
    [pwdText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [inputView addSubview:pwdText];
    
    confirmPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(kWidgetLeftPadding, CGRectGetMaxY(pwdText.frame), SCREEN_WIDTH - kWidgetLeftPadding, kWidgetHeight)];
    confirmPwdTF.placeholder = @"请再次输入密码";
    confirmPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmPwdTF.secureTextEntry = YES;
    confirmPwdTF.returnKeyType = UIReturnKeyDefault;
    confirmPwdTF.delegate = self;
    [confirmPwdTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [inputView addSubview:confirmPwdTF];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(accountTF.frame) - 0.5, SCREEN_WIDTH, kSepartorHeight)];
    separator.backgroundColor = RGB(239, 239, 239);
    [inputView addSubview:separator];
    
    UIView *separatorT = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(verifycodeText.frame) - 0.5, SCREEN_WIDTH, kSepartorHeight)];
    separatorT.backgroundColor = RGB(239, 239, 239);
    [inputView addSubview:separatorT];
    
    UIView *separatorC = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pwdText.frame) - 0.5, SCREEN_WIDTH, kSepartorHeight)];
    separatorC.backgroundColor = RGB(239, 239, 239);
    [inputView addSubview:separatorC];
    
    // Buttons
    registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(inputView.frame) + 20.0, SCREEN_WIDTH - 2 * 20, kWidgetHeight)];
    [registerBtn setTitle:@"注 册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.backgroundColor = RGB(80, 210, 255);
    [registerBtn addTarget:self action:@selector(registerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.layer.cornerRadius = 3;
    registerBtn.clipsToBounds = YES;
    registerBtn.userInteractionEnabled = NO;
    registerBtn.alpha = 0.8;
    [regScrollView addSubview:registerBtn];
    
    queryCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kAuthBtnWidth, 0, kAuthBtnWidth - 2 * kLeftPadding, kWidgetHeight)];
    [queryCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [queryCodeBtn setTitleColor:RGB(90, 230, 280) forState:UIControlStateHighlighted];
    queryCodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    queryCodeBtn.backgroundColor = RGB(80, 210, 255);
    queryCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [queryCodeBtn addTarget:self action:@selector(checkAccount) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:queryCodeBtn];
}

- (void)registerTypeDrawUI{

    self.navigationItem.title = @"注册";
    [self creatUIAction:registerType];
    
}
#pragma mark - ActionMethod

-(void)setSegmentedControlStyle{
    
    [self.view endEditing:YES];
    for (int i=0; i<[segmented.subviews count]; i++)
    {
        if ([[segmented.subviews objectAtIndex:i]isSelected] )
        {
            [[segmented.subviews objectAtIndex:i] setTintColor: APPBULECOLOR];
            accountTF.placeholder = @"请输入手机号";
    
        }else{
            [[segmented.subviews objectAtIndex:i] setTintColor:APPBULECOLOR];
            accountTF.placeholder = @"请输入邮箱";
        }
    }
    accountTF.text = @"";
    pwdText.text = @"";
    confirmPwdTF.text = @"";
    verifycodeText.text = @"";
}

- (void)textFieldChanged:(id)sender{
    
    if (![NSString isEmpty:accountTF.text] && ![NSString isEmpty:pwdText.text] && ![NSString isEmpty:confirmPwdTF.text] && ![NSString isEmpty:verifycodeText.text]) {
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registerBtn.userInteractionEnabled = YES;
        registerBtn.alpha = 1.0;
        return;
    }
    registerBtn.userInteractionEnabled = NO;
    registerBtn.alpha = 0.8;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerBtnClicked{

    if (![pwdText.text isEqualToString:confirmPwdTF.text]) {
        [STHUD showText:NSLocalizedString(@"STRegPwdDifferent", nil) inView:self.view];
        return;
    }
    [[STHTTPRequest sharedClient] postPath:STREGISTER token:nil parameters:@{@"account":accountTF.text,@"password":pwdText.text,@"code":verifycodeText.text} showProgressView:self.view showText:@"注册中" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(operation.response.statusCode == 200){
            if ([[responseObject objectForKey:@"code"] integerValue] == 202) {
                [STHUD showText:[responseObject objectForKey:@"msg"] inView:self.view];
                return ;
            }
            if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                [STHUD showText:NSLocalizedString(@"STRegisterSuccess", nil) inView:self.view];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)checkAccount{
    
    if ([NSString isEmpty:accountTF.text]) {
        [STHUD showText:NSLocalizedString(@"STAccountIsNil", nil) inView:self.view];
        return;
    }
    
    if (![NSString isMobileNumber:accountTF.text] && ![NSString isValidEmailAddress:accountTF.text]) {
        [STHUD showText:NSLocalizedString(@"STAccountInvalid", nil) inView:self.view];
        return;
    }
    
    [[STHTTPRequest sharedClient] getPath:@"accounts/register/available" token:nil parameters:@{@"account":accountTF.text} showProgressView:self.view showText:NSLocalizedString(@"STVerifying", nil) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"] integerValue] != 200) {
        }
        if (operation.response.statusCode == 200){
            if ([[responseObject objectForKey:@"code"] integerValue] == 202) {
                
                [STHUD showText:NSLocalizedString(@"STAccountExist", nil) inView:self.view];
                return ;
            }
            
            if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
                
                [[STHTTPRequest sharedClient] getPath:@"accounts/verificationCode" token:nil  parameters:@{@"account":accountTF.text} showProgressView:self.view showText:NSLocalizedString(@"STVerifying", nil) success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)endEditing{
    
    [self.view endEditing:YES];
}

#pragma mrak - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqual: @""]) {
        return YES;
    }
    if (textField == accountTF) {
        return textField.text.length >= 22 ? NO : YES;
    }
    if (textField == verifycodeText) {
        return textField.text.length >= 6 ? NO : YES;
    }
    return YES;
}

@end
