//
//  STRegisterViewController.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/7/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STRegisterViewController : UIViewController<UITextFieldDelegate>
{
@private
    UIScrollView *regScrollView;
    UITextField *accountTF;
    UITextField *pwdText;
    UITextField *confirmPwdTF;
    UITextField *verifycodeText;
    NSTimer *remainingTimer;
    long remainNum;
    UIButton *queryCodeBtn;
    UIButton *registerBtn;
    UISegmentedControl *segmented;
}
@property(nonatomic,assign) NSInteger registerType;
@end
