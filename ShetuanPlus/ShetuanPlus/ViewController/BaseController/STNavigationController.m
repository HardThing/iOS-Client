//
//  STNavigationController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/5/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STNavigationController.h"

@implementation STNavigationController

- (instancetype)init{
    if (self = [super init]) {
        if (IOS_VERSION > 7.0) {
            self.interactivePopGestureRecognizer.delegate = self;
        }
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        if (IOS_VERSION > 7.0) {
            self.interactivePopGestureRecognizer.delegate = self;
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (IOS_VERSION > 7.0) {
            self.interactivePopGestureRecognizer.delegate = self;
        }
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    else return YES;
}

@end
