//
//  STActivityTableViewCell.h
//  ShetuanPlus
//
//  Created by Jiao Liu on 8/28/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STActivityTableViewCell : UITableViewCell
{
    @private
    UILabel *titleLabel;
    UILabel *timeLabel;
    UILabel *locationLabel;
    UILabel *supportLabel;
    UILabel *fundLabel;
    UIImageView *imgView;
    UIImageView *likeImgView;
    UIImageView *fundImgView;
    UIImageView *timeImgView;
    UIImageView *locationImgView;
    CGSize maxImgSize;
}

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *time;
@property (nonatomic, strong)NSString *location;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, assign)int supportNum;
@property (nonatomic, assign)float fundNum;


@end
