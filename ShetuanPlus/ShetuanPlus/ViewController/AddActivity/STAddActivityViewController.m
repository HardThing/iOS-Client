//
//  STAddActivityViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/6/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STAddActivityViewController.h"

@implementation STAddActivityViewController

- (id)init
{
    self = [super init];
    if (self) {
        createActView = [[STButtonView alloc] initWithImage:[UIImage imageNamed:@"Add_Activity"] title:@"创建活动"];
        createActView.tag = 101;
        createActView.delegate = self;
        
        createOrgView = [[STButtonView alloc] initWithImage:[UIImage imageNamed:@"Add_Org"] title:@"创建组织"];
        createOrgView.tag = 102;
        createOrgView.delegate = self;
        
        joinOrgView = [[STButtonView alloc] initWithImage:[UIImage imageNamed:@"Add_Join"] title:@"加入组织"];
        joinOrgView.tag = 103;
        joinOrgView.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    createActView.transform = CGAffineTransformTranslate(createActView.transform, 0, 100);
    [self.view addSubview:createActView];
    [UIView animateWithDuration:0.1 animations:^{
        createActView.transform = CGAffineTransformTranslate(createActView.transform, 0, -100);
    }];
    
    createOrgView.transform = CGAffineTransformTranslate(createOrgView.transform, 0, 100);
    [self.view addSubview:createOrgView];
    [UIView animateWithDuration:0.2 animations:^{
        createOrgView.transform = CGAffineTransformTranslate(createOrgView.transform, 0, -100);
    }];
    
    joinOrgView.transform = CGAffineTransformTranslate(joinOrgView.transform, 0, 100);
    [self.view addSubview:joinOrgView];
    [UIView animateWithDuration:0.3 animations:^{
        joinOrgView.transform = CGAffineTransformTranslate(joinOrgView.transform, 0, -100);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOS_VERSION > 7.0) {
        UIToolbar *backView = [[UIToolbar alloc] initWithFrame:SCREEN_FRAME];
        self.view = backView;
    }
    else
    {
        UIView *backView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
        backView.backgroundColor= [UIColor colorWithWhite:1.0 alpha:0.97];
        self.view = backView;
        
        UIView *hideNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT)];
        hideNavView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:hideNavView];
    }
    
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Add_Slogan"]];
    sloganView.center = CGPointMake(SCREEN_WIDTH / 2.0, 100);
    [self.view addSubview:sloganView];
    
    float offsetX = (SCREEN_WIDTH - createActView.frame.size.width - createOrgView.frame.size.width) / 3.0;
    float offsetY = (SCREEN_HEIGHT - sloganView.frame.size.height - sloganView.frame.origin.y - 44 - createActView.frame.size.height - joinOrgView.frame.size.height) / 3.0;
    
    createActView.center = CGPointMake(offsetX + createActView.frame.size.width / 2.0, sloganView.frame.origin.y + sloganView.frame.size.height + createActView.frame.size.height / 2.0 + offsetY);
    createOrgView.center = CGPointMake(createActView.frame.origin.x + createActView.frame.size.width + offsetX + createOrgView.frame.size.width / 2.0, createActView.center.y);
    joinOrgView.center = CGPointMake(SCREEN_WIDTH / 2.0, createActView.frame.origin.y + createActView.frame.size.height + joinOrgView.frame.size.height / 2.0 + offsetY);
    
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    [dismissBtn setTitle:@"取    消" forState:UIControlStateNormal];
    [dismissBtn setBackgroundImage:[[UIImage imageNamed:@"Button BackgroudColor"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [dismissBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dismissBtn.alpha = 1;
    [dismissBtn addTarget:self action:@selector(dismissBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissBtn];
}

#pragma mark - Actions

- (void)dismissBtnClicked
{    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)buttonAction:(long)tag
{
    NSLog(@"%ld",tag);
}

@end
