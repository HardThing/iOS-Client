//
//  STInsetTextField.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/28/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STInsetTextField.h"

@implementation STInsetTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super leftViewRectForBounds:bounds];
    textRect.origin.x += 10;
    return textRect;
}
// placehold
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect textRect = [super textRectForBounds:bounds];
    textRect.origin.x += 15;
    return textRect;
}

// text
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect textRect = [super editingRectForBounds:bounds];
    textRect.origin.x += 15;
    return textRect;
}
@end
