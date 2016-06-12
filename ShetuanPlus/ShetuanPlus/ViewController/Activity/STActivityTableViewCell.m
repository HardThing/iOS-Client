//
//  STActivityTableViewCell.m
//  ShetuanPlus
//
//  Created by Jiao Liu on 8/28/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STActivityTableViewCell.h"

@implementation STActivityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"标题";
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        
        imgView = [[UIImageView alloc] init];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = RGB(155, 155, 155);
        timeLabel.font = [UIFont systemFontOfSize:14.0];
        timeLabel.text = @"时间";
         
        locationLabel = [[UILabel alloc] init];
        locationLabel.textColor = RGB(230, 100, 100);
        locationLabel.font = [UIFont systemFontOfSize:14.0];
        locationLabel.text = @"地点";
        
        supportLabel = [[UILabel alloc] init];
        supportLabel.text = @"点赞";
        supportLabel.font = [UIFont systemFontOfSize:14.0];
        supportLabel.textColor = RGB(80, 210, 255);
        
        fundLabel = [[UILabel alloc] init];
        fundLabel.text = @"筹资";
        fundLabel.font = [UIFont systemFontOfSize:18.0];
        fundLabel.textColor = RGB(230, 210, 30);
        
        maxImgSize = CGSizeMake(75, 100);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    sectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:sectionView];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, sectionView.frame.size.height - 0.5, sectionView.frame.size.width, 0.5)];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    [sectionView addSubview:separatorView];
    
    titleLabel.frame = CGRectMake(maxImgSize.width + 10, 0, rect.size.width - 90, 30);
    [sectionView addSubview:titleLabel];
    
//    imgView.frame = CGRectMake(0, 0, 75, 100);
    [sectionView addSubview:imgView];
    
    timeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + 35, 15, 15)];
    timeImgView.image = [UIImage imageNamed:@"Activity_Time"];
    [sectionView addSubview:timeImgView];
    
    timeLabel.frame = CGRectMake(timeImgView.frame.origin.x + timeImgView.frame.size.width + 5, timeImgView.frame.origin.y, rect.size.width - imgView.frame.size.width - 50, 15);
    [sectionView addSubview:timeLabel];
    
    locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(timeImgView.frame.origin.x, timeImgView.frame.origin.y + timeImgView.frame.size.height + 7, 15, 15)];
    locationImgView.image = [UIImage imageNamed:@"Activity_Location"];
    [sectionView addSubview:locationImgView];
    
    locationLabel.frame = CGRectMake(locationImgView.frame.origin.x + locationImgView.frame.size.width + 5, locationImgView.frame.origin.y, timeLabel.frame.size.width, 15);
    [sectionView addSubview:locationLabel];
    
    float resizeWidth = rect.size.width - maxImgSize.width - 65;
    
    likeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(timeImgView.frame.origin.x, locationImgView.frame.origin.y + locationImgView.frame.size.height + 5, 15, 15)];
    likeImgView.image = [UIImage imageNamed:@"Activity_Like"];
    [sectionView addSubview:likeImgView];
    
    supportLabel.frame = CGRectMake(likeImgView.frame.origin.x + likeImgView.frame.size.width + 2, likeImgView.frame.origin.y, resizeWidth / 2.0, 15);
    [sectionView addSubview:supportLabel];
    
    fundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(supportLabel.frame.origin.x + supportLabel.frame.size.width + 2, likeImgView.frame.origin.y, 15, 15)];
    fundImgView.image = [UIImage imageNamed:@"Activity_Fund"];
    [sectionView addSubview:fundImgView];
    
    fundLabel.frame = CGRectMake(fundImgView.frame.origin.x + fundImgView.frame.size.width + 5, supportLabel.frame.origin.y - 5, resizeWidth / 2.0, 20);
    [sectionView addSubview:fundLabel];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title
{
    titleLabel.text = title;
}

- (void)setTime:(NSString *)time
{
    timeLabel.text = time;
}

- (void)setImage:(UIImage *)image
{
    UIImage *scaledImage = [UIImage scaleImageBySize:maxImgSize originalImage:image];
    imgView.frame = CGRectMake(0, 0, scaledImage.size.width, scaledImage.size.height);
    imgView.center = CGPointMake(maxImgSize.width / 2.0 , maxImgSize.height / 2.0);
    imgView.image = scaledImage;
}

- (void)setLocation:(NSString *)location
{
    locationLabel.text = location;
}

- (void)setSupportNum:(int)supportNum
{
//    if (supportNum >= 1000000) {
//        supportLabel.text = [NSString stringWithFormat:@"%.1fM",supportNum / 1000000.0];
//        return;
//    }
    if (supportNum >= 1000000) {
        supportLabel.text = [NSString stringWithFormat:@"%.1fK",supportNum / 1000.0];
    }
    else
    {
        supportLabel.text = [NSString stringWithFormat:@"%d",supportNum];
    }
}

- (void)setFundNum:(float)fundNum
{
//    if (fundNum >= 1000000) {
//        fundLabel.text = [NSString stringWithFormat:@"%.1fM",fundNum / 1000000.0];
//        return;
//    }
    if (fundNum >= 1000000) {
        fundLabel.text = [NSString stringWithFormat:@"%.1fK",fundNum / 1000.0];
    }
    else
    {
        fundLabel.text = [NSString stringWithFormat:@"%.2f",fundNum];
    }
}

@end
