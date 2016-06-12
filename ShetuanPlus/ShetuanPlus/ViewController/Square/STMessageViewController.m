//
//  STMessageViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/14/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STMessageViewController.h"

@interface STMessageViewController ()

@end

@implementation STMessageViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self drawUI];
    self.view.backgroundColor = BACKGROUND_COLOR;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)drawUI{
    
}

- (void)createTabButton{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
