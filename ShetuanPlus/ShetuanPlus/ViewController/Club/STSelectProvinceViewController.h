//
//  STSelectProvinceViewController.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/28/15.
//  Copyright © 2015 Jiao Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface STSelectProvinceViewController : UIViewController
//若有定位省份，则在
@property (nonatomic,copy) NSString *autoLocationProvinceName;
@property (nonatomic,assign) NSInteger autoLocationProviceId;
@end
