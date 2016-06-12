//
//  STHUD.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/20/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STHUD.h"
#import "MBProgressHUD.h"

#define kHUDSHOWDURATION 1.5f

@implementation STHUD

#pragma mark - Text

//fix me
+ (void)showText:(NSString *)text{
    
    UIWindow *keyWindow = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.labelText = text;
    [keyWindow addSubview:hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud hide:YES afterDelay:10.0];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
//    HUD.delegate = self;
}

+ (void)showText:(NSString *)text inView:(UIView *)view{
    [self showText:text withDetail:nil inView:view];
}

+ (void)showText:(NSString *)text withDetail:(NSString *)detail inView:(UIView *)view{
    [self showText:text withDetail:detail withDuration:kHUDSHOWDURATION inView:view];
}

+ (void)showText:(NSString *)text withDetail:(NSString *)detail withDuration:(NSInteger)duration inView:(UIView *)view{
    [self showText:text withDetail:detail withImage:nil withDuration:duration inView:view];
}

#pragma mark - SuccessOrError

+ (void)showErrorWithText:(NSString *)text inView:(UIView *)view{
    [self showText:text withDetail:nil withImage:@"error.png" withDuration:kHUDSHOWDURATION inView:view];
}

+ (void)showSuccessWithText:(NSString *)text inView:(UIView *)view{
    [self showText:text withDetail:nil withImage:@"success.png" withDuration:kHUDSHOWDURATION inView:view];
   
}

#pragma mark - View

+ (void)showText:(NSString *)text withDetail:(NSString *)detail withImage:(NSString *)icon withDuration:(NSInteger)duration inView:(UIView *)view{
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    if (icon) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@",icon]]];
        hud.mode = MBProgressHUDModeCustomView;
    }
    hud.userInteractionEnabled = NO;
    hud.labelText = text;
    hud.margin = 10.0;
    hud.detailsLabelText = detail;
    [hud hide:YES afterDelay:duration];
    hud.removeFromSuperViewOnHide = YES;
    
}

#pragma mark - NetWorkRequestMask

@end
