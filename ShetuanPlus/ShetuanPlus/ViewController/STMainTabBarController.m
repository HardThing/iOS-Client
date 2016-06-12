//
//  STMainTabBarController.m
//  ShetuanPlus
//
//  Created by Jiao Liu on 8/5/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STMainTabBarController.h"
#import "STViewController.h"
#import "STNavigationController.h"

#import "STSquareViewController.h"
#import "STActivityViewController.h"
#import "STAddActivityViewController.h"
#import "STPersonCenterViewController.h"
#import "STClubViewController.h"

@implementation STMainTabBarController

- (id)init
{
    self = [super init];
    if (self) {
        self.tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 50)];
        self.tabBar.delegate = self;
        self.tabBar.items = @[[[UITabBarItem alloc] initWithTitle:@"广场" image:[UIImage imageNamed:@"Tab_plaza"] tag:0],
                              [[UITabBarItem alloc] initWithTitle:@"活动" image:[UIImage imageNamed:@"Tab_activity"] tag:1],
                              [[UITabBarItem alloc] initWithTitle:nil image:nil tag:2],
                              [[UITabBarItem alloc] initWithTitle:@"组织" image:[UIImage imageNamed:@"Tab_club"] tag:3],
                              [[UITabBarItem alloc] initWithTitle:@"个人中心" image:[UIImage imageNamed:@"Tab_profile"] tag:4]];
        self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:0];
        self.tabBar.selectedImageTintColor = RGB(80, 210, 255);
        UIImageView *addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tab_add"]];
        addImage.center = CGPointMake(SCREEN_WIDTH / 2.0, 25);
        [self.tabBar addSubview:addImage];
        
        STSquareViewController *squareVC = [[STSquareViewController alloc] init];
        STNavigationController *squareNav = [[STNavigationController alloc]initWithRootViewController:squareVC];
        squareVC.hidesBottomBarWhenPushed = YES;
        squareNav.delegate = self;
        STActivityViewController *activityVC = [[STActivityViewController alloc] init];
        STNavigationController *activityNav = [[STNavigationController alloc]initWithRootViewController:activityVC];
        activityVC.hidesBottomBarWhenPushed = YES;
        activityNav.delegate = self;
        
        STClubViewController *clubVC = [[STClubViewController alloc] init];
        STNavigationController *clubNav = [[STNavigationController alloc] initWithRootViewController:clubVC];
        clubVC.hidesBottomBarWhenPushed = YES;
        clubNav.delegate = self;
        
        STAddActivityViewController *addVC = [[STAddActivityViewController alloc] init];
        
        STPersonCenterViewController *personVC = [[STPersonCenterViewController alloc] init];
        STNavigationController *personNav = [[STNavigationController alloc]initWithRootViewController:personVC];
        personVC.hidesBottomBarWhenPushed = YES;
        personNav.delegate = self;
        self.viewControllers = @[squareNav,activityNav,addVC,clubNav,personNav];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabBar) name:@"HideTabbar" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBar) name:@"ShowTabbar" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:self.tabBar];
    if (self.viewControllers.count == 0) {
        return;
    }
    UIViewController *presentingView = [self.viewControllers objectAtIndex:0];
    presentingView.view.tag = 1000;
    [self.view insertSubview:presentingView.view belowSubview:self.tabBar];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HideTabbar" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowTabbar" object:nil];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
//    if ([viewController isEqual:[viewController.navigationController.viewControllers firstObject]]) {
//        if(self.tabBar.hidden){
//            self.tabBar.hidden = NO;
//        }
//        return;
//    }
//    else{
//        [UIView animateWithDuration:0.1 animations:^{
//            self.tabBar.transform = CGAffineTransformMakeTranslation(0, 50);
//        } completion:^(BOOL finished) {
//            self.tabBar.hidden = YES;
//            self.tabBar.transform = CGAffineTransformIdentity;
//        }];
//    }
    if (!viewController.hidesBottomBarWhenPushed) {
        [UIView animateWithDuration:0.1 animations:^{
            self.tabBar.transform = CGAffineTransformMakeTranslation(0, 50);
        } completion:^(BOOL finished) {
            self.tabBar.hidden = YES;
            self.tabBar.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.hidesBottomBarWhenPushed) {
        self.tabBar.hidden = NO;
    }
}

- (void)hideTabBar
{
    self.tabBar.hidden = YES;
}

- (void)showTabBar
{
    self.tabBar.hidden = NO;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag >= self.viewControllers.count) {
        return;
    }
    UIView *presentingView = [[self.viewControllers objectAtIndex:item.tag] view];
    if (item.tag == 2) {
        [self.view addSubview:presentingView];
        presentingView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            presentingView.alpha = 1.0;
        }];
        [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:selectedIndex]];
    }
    else
    {
        UIView *presentedView = VIEWWITHTAG(self.view, 1000);
        [presentedView removeFromSuperview];
        
        presentingView.tag = 1000;
        
        [self.view insertSubview:presentingView belowSubview:self.tabBar];
        selectedIndex = item.tag;
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
