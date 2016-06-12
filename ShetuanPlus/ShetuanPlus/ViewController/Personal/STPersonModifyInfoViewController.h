//
//  STPersonModifyInfoViewController.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/26/15.
//  Copyright © 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^passBackStrBlock)(NSString *modifiedValue);

@interface STPersonModifyInfoViewController : UIViewController

@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy)NSString *palceHolder;
@property(nonatomic,strong) passBackStrBlock passBackName;

@end
