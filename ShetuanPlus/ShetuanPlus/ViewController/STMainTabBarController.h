//
//  STMainTabBarController.h
//  ShetuanPlus
//
//  Created by Jiao Liu on 8/5/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STMainTabBarController : UIViewController<UITabBarDelegate,UINavigationControllerDelegate>
{
@private
    NSInteger selectedIndex;
}

@property (nonatomic, strong)NSArray *viewControllers;
@property (nonatomic, strong)UITabBar *tabBar;

@end
