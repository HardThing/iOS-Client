//
//  STPersonAuthViewController.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/10/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPersonModel.h"

@interface STPersonAuthViewController : UIViewController

//用户默认为未认证用户
@property (nonatomic,assign) STUserAuthType authType;


@end
