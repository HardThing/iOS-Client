//
//  STButtonView.m
//  ShetuanPlus
//
//  Created by Jiao Liu on 9/2/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STButtonView.h"

@implementation STButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 1.2 + 10)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [imgBtn addTarget:self action:@selector(clickedDown) forControlEvents:UIControlEventTouchDown];
        [imgBtn addTarget:self action:@selector(clickedCancel) forControlEvents:UIControlEventTouchUpOutside];
        [imgBtn addTarget:self action:@selector(clickedBtn) forControlEvents:UIControlEventTouchUpInside];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imgBtn.frame.origin.y + imgBtn.frame.size.height + 10, frame.size.width, frame.size.height * 0.2)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor grayColor];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image title:(NSString *)title
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height * 1.2 + 10)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [imgBtn setBackgroundImage:image forState:UIControlStateNormal];
        [imgBtn addTarget:self action:@selector(clickedDown) forControlEvents:UIControlEventTouchDown];
        [imgBtn addTarget:self action:@selector(clickedCancel) forControlEvents:UIControlEventTouchUpOutside];
        [imgBtn addTarget:self action:@selector(clickedBtn) forControlEvents:UIControlEventTouchUpInside];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imgBtn.frame.origin.y + imgBtn.frame.size.height + 10, image.size.width, image.size.height * 0.2)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.text = title;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code

    [self addSubview:imgBtn];
    [self addSubview:titleLabel];
}

- (void)setImage:(UIImage *)image
{
    [imgBtn setImage:image forState:UIControlStateNormal];
}

- (void)setTile:(NSString *)title
{
    titleLabel.text = title;
}

#pragma mark - Actions

- (void)clickedDown
{
    imgBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
}

- (void)clickedCancel
{
    imgBtn.transform = CGAffineTransformIdentity;
}

- (void)clickedBtn
{
    imgBtn.transform = CGAffineTransformIdentity;
    if (_delegate != nil && [_delegate respondsToSelector:@selector(buttonAction:)]) {
        [_delegate buttonAction:self.tag];
    }
}

@end
