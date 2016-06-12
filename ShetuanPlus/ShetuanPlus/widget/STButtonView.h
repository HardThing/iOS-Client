//
//  STButtonView.h
//  ShetuanPlus
//
//  Created by Jiao Liu on 9/2/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STButtonViewDelegate <NSObject>

@required
- (void)buttonAction:(long)tag;

@end

@interface STButtonView : UIView
{
    @private
    UIButton *imgBtn;
    UILabel *titleLabel;
}

@property (nonatomic,assign)id<STButtonViewDelegate> delegate;

- (id)initWithImage:(UIImage *)image title:(NSString *)title;
- (void)setImage:(UIImage *)image;
- (void)setTile:(NSString *)title;

@end
