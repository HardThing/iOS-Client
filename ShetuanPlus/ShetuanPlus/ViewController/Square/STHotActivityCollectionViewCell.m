//
//  STHotActivityCollectionViewCell.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/16/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STHotActivityCollectionViewCell.h"
@interface STHotActivityCollectionViewCell(){
    
@private
    UIImageView *activityImageView;

    UIView *bottomView;
    UILabel *activityTitleLable;
    UIImageView *organizerImgView;
    UILabel *organizerLabel;
    UIImageView *likeImgView;
    UILabel *likeLabel;
    UIImageView *fundImgView;
    UILabel *fundLable;
    
    UILabel *separtorLine;
}
@end

@implementation STHotActivityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self setUpViews];
    }
    return self;
}

#pragma -
#pragma mark - Build UI

- (void)setUpViews{

    //init view
    activityImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    organizerImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    organizerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    likeImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    likeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    fundImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    fundLable = [[UILabel alloc]initWithFrame:CGRectZero];
    activityTitleLable = [[UILabel alloc]initWithFrame:CGRectZero];
    
    separtorLine = [[UILabel alloc]initWithFrame:CGRectZero];
    activityTitleLable.font = [UIFont systemFontOfSize:16.0];
    activityTitleLable.textColor = [UIColor lightGrayColor];
    activityTitleLable.textAlignment = NSTextAlignmentCenter;
    
    activityImageView.layer.cornerRadius = 4;
    activityImageView.layer.masksToBounds = YES;
    
    organizerImgView.image = [UIImage imageNamed:@"Add_Join"];
    organizerLabel.textColor = APPBULECOLOR;
    organizerLabel.font =[UIFont systemFontOfSize:13.0];
    
    separtorLine.backgroundColor = [UIColor lightGrayColor];
    
    likeImgView.image = [UIImage imageNamed:@"Activity_Like"];
    fundImgView.image = [UIImage imageNamed:@"Activity_Fund"];
    [bottomView addSubview:activityTitleLable];
    [bottomView addSubview:organizerLabel];
    [bottomView addSubview:organizerImgView];
    [bottomView addSubview:likeImgView];
    [bottomView addSubview:likeLabel];
    [bottomView addSubview:fundImgView];
    [bottomView addSubview:fundLable];
    [bottomView addSubview:separtorLine];

    [self.contentView addSubview:activityImageView];
    [self.contentView addSubview:bottomView];
    
    
    bottomView.backgroundColor = [UIColor whiteColor];
    activityTitleLable.text = @"爱心捐助活动";
    activityImageView.image = [UIImage imageNamed:@"Default_Img"];
    likeLabel.text = @"1111";
    fundLable.text = @"2.0W";
    organizerLabel.text = @"学生会";
//    bottomView.backgroundColor = [UIColor redColor];
//    likeLabel.backgroundColor = [UIColor grayColor];
//    activityTitleLable.backgroundColor = [UIColor orangeColor];
    
    
    CGFloat kPadding = 6.0;
    CGFloat kLabelWidth = 40;
    CGFloat lableHeight = 39.0;
    CGFloat bottomHeight = 100.0;
    CGSize imgSize = CGSizeMake(24.0, 24.0);
    
    [activityImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(bottomHeight);
        make.bottom.equalTo(@[self.contentView.mas_bottom,likeImgView.mas_bottom,likeLabel.mas_bottom,fundImgView.mas_bottom,fundLable.mas_bottom]);
    }];
    
    [activityTitleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lableHeight);
        make.leading.trailing.top.width.equalTo(bottomView);
    }];
    
    [separtorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(bottomView.mas_leading).offset(11);
        make.trailing.equalTo(bottomView.mas_trailing).offset(-11);
        make.height.mas_equalTo(@1);
        make.top.equalTo(activityTitleLable.mas_bottom);
    }];
    
    
    [organizerImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(separtorLine.mas_leading);
        make.top.equalTo(separtorLine.mas_bottom).offset(kPadding);
        make.bottom.equalTo(organizerLabel.mas_bottom);
        make.size.mas_equalTo(imgSize);
    }];
    [organizerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(organizerImgView.mas_trailing);
        make.trailing.equalTo(separtorLine);
        make.height.equalTo(organizerImgView);
    }];
    
    
    [likeImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(separtorLine.mas_leading);
        make.size.mas_equalTo(imgSize);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.top.equalTo(organizerImgView.mas_bottom).offset(kPadding);
        make.top.equalTo(@[likeLabel.mas_top,fundImgView.mas_top,fundLable.mas_top]);
    }];
    [likeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(likeImgView.mas_trailing);
        make.width.mas_equalTo(kLabelWidth);
        make.height.equalTo(@[likeImgView,fundImgView,fundLable]);
    }];
    [fundImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(fundLable.mas_leading);
        make.size.mas_equalTo(imgSize);
    }];
    [fundLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(separtorLine.mas_trailing);
        make.width.mas_equalTo(kLabelWidth);
    }];
    
    UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeNumIncreaseOne)];
    likeImgView.userInteractionEnabled = YES;
    [likeImgView addGestureRecognizer:likeTap];
}

#pragma mark - 

- (void)layoutSubviews{
    
    [super layoutSubviews];
}

#pragma -
#pragma mark - BindModel

- (void)setCell:(STActivityModel *)model{
    self.model = model;
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

#pragma - 
#pragma mark - RefreshHandler

- (void)refreshLikeOrFundNum{
    likeLabel.text = @"1";
    fundLable.text = @"22";
}

- (void)likeNumIncreaseOne{
    [self refreshLikeOrFundNum];
}
@end
    