//
//  STTabSelectView.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/14/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STTabSelectViewDelegate <NSObject>

@optional
- (void)itemBtnClicked:(NSInteger)itemIndex;

@end
@interface STTabSelectView : UIView

#pragma mark － Property

@property (nonatomic, copy)NSArray *selectItems;
@property (nonatomic, weak)id <STTabSelectViewDelegate> delegate;

#pragma mark - initMethod

- (instancetype)initWithFrame:(CGRect)frame WithItems:(NSArray *)items WithDelegate:(id)delegate;
@end
