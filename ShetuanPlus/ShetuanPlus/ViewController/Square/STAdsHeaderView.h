//
//  STAdsHeaderView.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/16/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol STSquareHeaderViewDelegate <NSObject>

- (void)handleRedirect:(NSObject *)item;

@end
@interface STAdsHeaderView : UICollectionReusableView<UIScrollViewDelegate>
{
@private
    UIScrollView *_adScrollView;
    UIPageControl *_pageScrollIndicator;
    NSTimer *_scrollTimer;
    NSArray *_imageArray;
}

@property (nonatomic, assign)id <STSquareHeaderViewDelegate> delegate;

- (void)setAdsWith:(NSArray *)imageArray defaultImage:(UIImage*)image frame:(CGRect)frame;

@end
