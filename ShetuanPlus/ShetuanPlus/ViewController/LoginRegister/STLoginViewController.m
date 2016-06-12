//
//  STLoginViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/6/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STLoginViewController.h"
#import "STRegisterViewController.h"
#import "STForgetPwdViewController.h"
#import "NSString+st_extension.h"

#import "STInsetTextField.h"
@interface STLoginViewController()<UITextFieldDelegate>{
@private
    UIImageView *headImageView;
    UITextField *usernameTF;
    UITextField *passwordTF;
    UIButton *loginInButton;
    NSInteger loginType; //tele : 0 , email : 1
}
@end
@implementation STLoginViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self creatUIAction];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark - CreatUIAction

- (void)creatUIAction{
   
    //quit login page
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    outButton.frame = CGRectMake(16, 24, 28, 28);

    [outButton setBackgroundImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    [outButton setBackgroundImage:[UIImage imageNamed:@"×_selected"] forState:UIControlStateHighlighted];
    [outButton addTarget:self action:@selector(quitLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outButton];
    //head
    NSInteger headTopPadding = 40;
    NSInteger headWidth = 80;
    NSInteger headLeftPadding = (SCREEN_WIDTH - headWidth) / 2;
    NSInteger loginBtnLeftPadding = 0.0;
    
    //judge iphone 6
    if (iPhone6) {
        headTopPadding = 64.0;
    }
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(headLeftPadding, headTopPadding * 2, headWidth, headWidth)];
    headImageView.image = [UIImage imageNamed:@"Default_User"];
    headImageView.layer.cornerRadius = headWidth/2;
    headImageView.layer.masksToBounds = YES;
    [self.view addSubview:headImageView];
    NSInteger loginFrameY = CGRectGetMaxY(headImageView.frame) + 38;
    NSInteger textFieldHeight = 41;
    
    //middle
    usernameTF = [self loginCustomTextFieldWithFrame:CGRectMake(loginBtnLeftPadding, loginFrameY, SCREEN_WIDTH - 2 * loginBtnLeftPadding, textFieldHeight)];
    usernameTF.placeholder = @"请输入手机或邮箱账号";
    usernameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [usernameTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:usernameTF];
    passwordTF = [self loginCustomTextFieldWithFrame:CGRectMake(loginBtnLeftPadding, CGRectGetMaxY(usernameTF.frame) + 1.0, SCREEN_WIDTH - 2 * loginBtnLeftPadding, textFieldHeight)];
    passwordTF.secureTextEntry = YES;
    passwordTF.placeholder = @"请输入密码";
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordTF];
    
    
    NSInteger loginBtnFrameY = CGRectGetMaxY(passwordTF.frame) + 35;
    
    loginInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginInButton.frame = CGRectMake(20, loginBtnFrameY, SCREEN_WIDTH - 2 * 20, textFieldHeight);
    [loginInButton setBackgroundImage:[[UIImage imageNamed:@"Button BackgroudColor"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [loginInButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginInButton.userInteractionEnabled = NO;
    loginInButton.layer.cornerRadius = 3;
    loginInButton.layer.masksToBounds = YES;
    loginInButton.alpha = 0.8;
    [self.view addSubview:loginInButton];
    [loginInButton addTarget:self action:@selector(loginInAction) forControlEvents:UIControlEventTouchUpInside];
    //bottom
    
    NSInteger regForBtnFrameY = CGRectGetMaxY(loginInButton.frame) + 16;
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(SCREEN_WIDTH - (loginBtnLeftPadding + 100), regForBtnFrameY, 100, 20);
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [forgetBtn setTitleColor:RGB(80, 210, 255) forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetPwdClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.frame = CGRectMake(loginBtnLeftPadding, regForBtnFrameY, 100, 20);
    [regBtn setTitleColor:RGB(80, 210, 255) forState:UIControlStateNormal];
    regBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [regBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
    [self.view addGestureRecognizer:tapGesture];
}


#pragma mark - BtnAction

- (void)quitLoginAction{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)loginInAction{
    
    [self.view endEditing:YES];
    if (![NSString isMobileNumber:usernameTF.text] && ![NSString isValidEmailAddress:usernameTF.text]) {
        [STHUD showText:NSLocalizedString(@"STAccountInvalid", nil) inView:self.view];
        return;
    }
    
    [[STHTTPRequest sharedClient] postPath:STLOGIN token:nil parameters:@{@"account":usernameTF.text,@"password":passwordTF.text} showProgressView:self.view showText:NSLocalizedString(@"STLogining", nil) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 204) {
            [STHUD showText:[responseObject objectForKey:@"msg"] inView:self.view];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [STHUD showText:[responseObject objectForKey:@"msg"] inView:self.view];
            [STUserManager setUsername:usernameTF.text];
            [STUserManager setToken:[[responseObject objectForKey:@"data"] objectForKey:@"token"]];
            [STUserManager setUserId:[[responseObject objectForKey:@"data"] objectForKey:@"userId"]];
            [STUserManager setIsLogin:YES];
            [self quitLoginAction];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)forgetPwdClicked{
    STForgetPwdViewController *forgetPwdVC = [[STForgetPwdViewController alloc]init];
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}

- (void)endEditing{
    [self.view endEditing:YES];
}

#pragma mark - ControlLoginBtn
- (void)textFieldChanged:(id)sender{
    if (![NSString isEmpty:usernameTF.text] && ![NSString isEmpty:passwordTF.text]) {
        [loginInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginInButton.userInteractionEnabled = YES;
        loginInButton.alpha = 1.0;
        return;
    }
    loginInButton.userInteractionEnabled = NO;
    loginInButton.alpha = 0.8;
}
- (void)registerAction{
    [self.view endEditing:YES];
    STRegisterViewController *regVC = [[STRegisterViewController alloc]init];
    [self.navigationController pushViewController:regVC animated:YES];
    
}
#pragma mark - CustomTextField

- (UITextField *)loginCustomTextFieldWithFrame:(CGRect)rect{
    STInsetTextField *textField = [[STInsetTextField alloc]initWithFrame:rect];
    textField.backgroundColor = [UIColor whiteColor];
    textField.delegate = self;
    return textField;
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIKeyboardChangeMethod

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -44; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? movementDistance : -movementDistance);
    int viewHeight = up ? self.view.frame.size.height + 44 : self.view.frame.size.height - 44;
    CGRect frame = self.view.frame;
    frame.size.height = viewHeight;
    self.view.frame = frame;
    [UIView beginAnimations:@"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
