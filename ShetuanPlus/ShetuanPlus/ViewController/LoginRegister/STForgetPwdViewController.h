//
//  STForgetPwdViewController.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/28/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STForgetPwdViewController : UIViewController<UITextFieldDelegate>
{
@private
    UITextField *accountTF;
    UITextField *verifyTF;
    NSTimer *remainingTimer;
    long remainNum;
    UIButton *queryCodeBtn;
}
@end
