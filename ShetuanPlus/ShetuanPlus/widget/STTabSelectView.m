//
//  STTabSelectView.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/14/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STTabSelectView.h"

@interface STTabSelectView(){

    NSMutableDictionary *buttonDict;
    UIButton *selectedBtn;
}
@end

@implementation STTabSelectView

- (instancetype)initWithFrame:(CGRect)frame WithItems:(NSArray *)items WithDelegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.delegate = delegate;
        [self configureTabWithItems:items];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UI

- (void)configureTabWithItems:(NSArray *)itemStr{

    CGFloat buttonWidth = self.frame.size.width / itemStr.count;
    for (int itemIndex = 0; itemIndex < itemStr.count; itemIndex ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(itemIndex * buttonWidth, 0, buttonWidth, self.frame.size.height);
        [btn setTitle:[itemStr objectAtIndex:itemIndex] forState:UIControlStateNormal];
        [btn setTitle:[itemStr objectAtIndex:itemIndex] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (itemIndex == 0) {
            selectedBtn = btn;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"Square_Message_Vertical_line"] forState:UIControlStateNormal];
        }
        btn.tag = itemIndex + 500;
        [self addSubview:btn];
    }
}

#pragma mark - Handler

- (void)itemButtonClicked:(UIButton *)sender{
    if (sender == selectedBtn) {
        return;
    }
    [selectedBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [selectedBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage imageNamed:@"Square_Message_Vertical_line"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    selectedBtn = sender;
    if ([self.delegate respondsToSelector:@selector(itemBtnClicked:)]) {
        [self.delegate itemBtnClicked:sender.tag];
    }
}

@end
