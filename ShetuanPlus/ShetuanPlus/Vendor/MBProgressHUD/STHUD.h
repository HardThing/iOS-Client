//
//  STHUD.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/20/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//


#import <Foundation/Foundation.h>
@class MBProgressHUD;
@interface STHUD : NSObject
{
    MBProgressHUD *maskHud;
}
#pragma mark - Text

+ (void)showText:(NSString *)text;
+ (void)showText:(NSString *)text inView:(UIView *)view;
+ (void)showText:(NSString *)text withDetail:(NSString *)detail inView:(UIView *)view;
+ (void)showText:(NSString *)text withDetail:(NSString *)detail withDuration:(NSInteger)duration inView:(UIView *)view;

#pragma mark - SuccessOrError

+ (void)showErrorWithText:(NSString *)text inView:(UIView *)view;
+ (void)showSuccessWithText:(NSString *)text inView:(UIView *)view;

#pragma mark - NetWorkRequestMask

//+ (void)showMaskText:(NSString *)text inView:(UIView *)view;
//+ (void)hideMask;

@end
