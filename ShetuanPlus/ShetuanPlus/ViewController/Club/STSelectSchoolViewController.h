//
//  STSelectSchoolViewController.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 9/2/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^STSelectSchoolNmae)(NSString *schoolName);

@interface STSelectSchoolViewController : UIViewController

@property (nonatomic,strong) STSelectSchoolNmae passSchoolName;

- (instancetype)initWithPassSchoolNameBlock:(STSelectSchoolNmae)block;
@end
