//
//  STAdsHeaderView.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/16/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STAdsHeaderView.h"

@implementation STAdsHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        UIView *btmSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
//        btmSeparator.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:btmSeparator];
    }
    return self;
}

- (void)setAdsWith:(NSArray *)imageArray defaultImage:(UIImage *)image frame:(CGRect)frame
{
    [_adScrollView removeFromSuperview];
    _adScrollView = nil;
    [_pageScrollIndicator removeFromSuperview];
    _pageScrollIndicator = nil;
    [_scrollTimer invalidate];
    _scrollTimer = nil;

    _adScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _adScrollView.pagingEnabled = YES;
    _adScrollView.delegate = self;
    _adScrollView.showsHorizontalScrollIndicator = NO;
    _adScrollView.bounces = NO;
    [self addSubview:_adScrollView];
    
    _imageArray = imageArray;
    
    for (int i = 0; i < imageArray.count; i ++) {
        UIImageView *AdView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x + (i + 1) * frame.size.width, 0, frame.size.width, frame.size.height)];
        AdView.image = imageArray[i];
        AdView.userInteractionEnabled = YES;
        [_adScrollView addSubview:AdView];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openUrl)];
        [AdView addGestureRecognizer:tapGes];
    }
    
    if (imageArray.count == 0) {
        UIImageView *AdView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height)];
        AdView.image = image;
        [_adScrollView addSubview:AdView];
    }
    else
    {
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height)];
        leftView.image = [_imageArray objectAtIndex:imageArray.count - 1];
        [_adScrollView addSubview:leftView];

        UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x + (imageArray.count + 1) * frame.size.width, 0, frame.size.width, frame.size.height)];
        rightView.image = [_imageArray objectAtIndex:0];
        [_adScrollView addSubview:rightView];
        
        _adScrollView.contentSize = CGSizeMake(frame.size.width * (imageArray.count + 2), frame.size.height);
        _adScrollView.contentOffset = CGPointMake(frame.size.width, 0);
        
        _pageScrollIndicator = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.origin.y + frame.size.height - 20, frame.size.width, 20)];
        _pageScrollIndicator.numberOfPages = imageArray.count;
        _pageScrollIndicator.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _pageScrollIndicator.userInteractionEnabled = NO;
        [self addSubview:_pageScrollIndicator];
        [self addTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int pageNum = scrollView.contentOffset.x / _adScrollView.frame.size.width;
    if (pageNum == _pageScrollIndicator.numberOfPages + 1) {
        _pageScrollIndicator.currentPage = 0;
        [_adScrollView setContentOffset:CGPointMake(_adScrollView.frame.size.width * (_pageScrollIndicator.currentPage + 1), 0) animated:NO];
        return;
    }
    _pageScrollIndicator.currentPage = scrollView.contentOffset.x / _adScrollView.frame.size.width - 1;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self removeTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self addTimer];
    int pageNum = scrollView.contentOffset.x / _adScrollView.frame.size.width;
    if (pageNum == 0) {
        _pageScrollIndicator.currentPage = _pageScrollIndicator.numberOfPages - 1;
        [_adScrollView setContentOffset:CGPointMake(_adScrollView.frame.size.width * (_pageScrollIndicator.currentPage + 1), 0) animated:NO];
        return;
    }
    if (pageNum == _pageScrollIndicator.numberOfPages + 1) {
        _pageScrollIndicator.currentPage = 0;
        [_adScrollView setContentOffset:CGPointMake(_adScrollView.frame.size.width * (_pageScrollIndicator.currentPage + 1), 0) animated:NO];
        return;
    }
}

- (void)autoScroll
{
    int currentPage = _adScrollView.contentOffset.x / _adScrollView.frame.size.width;
    [_adScrollView setContentOffset:CGPointMake(_adScrollView.frame.size.width + _adScrollView.frame.size.width * currentPage, 0) animated:YES];
}

- (void)openUrl
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(handleRedirect:)]) {
        [_delegate handleRedirect:[_imageArray objectAtIndex:_pageScrollIndicator.currentPage]];
    }
}

- (void)addTimer{
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
}

- (void)removeTimer{
    [_scrollTimer invalidate];
    _scrollTimer = nil;
}
@end
