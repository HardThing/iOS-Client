//
//  STClubTableViewCell.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 9/2/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STClubTableViewCell.h"
#import "STClubModel.h"

@interface STClubTableViewCell(){
    UIImageView *logoImageView;
    UILabel *nameLabel;
    UILabel *descriptLabel;
    UILabel *groupNumLabel;
    UIImageView *groupImageView;
}
@end

@implementation STClubTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

#pragma mark - BuildUI

- (void)setUpUI{
    
//    self.translatesAutoresizingMaskIntoConstraints = NO;
    nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    logoImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    descriptLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    groupImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    groupNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    UILabel *separtorLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    separtorLabel.backgroundColor = [UIColor lightGrayColor];

    nameLabel.font = [UIFont systemFontOfSize:16.0];
    nameLabel.textColor = [UIColor lightGrayColor];
    
    logoImageView.layer.cornerRadius = 4;
    logoImageView.layer.masksToBounds = YES;
    

    descriptLabel.textColor = APPBULECOLOR;
    descriptLabel.font =[UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:logoImageView];
    [self.contentView addSubview:descriptLabel];
    [self.contentView addSubview:groupNumLabel];
    [self.contentView addSubview:groupImageView];
    [self.contentView addSubview:separtorLabel];
    
    UIView *superView = self.contentView;
    CGFloat logoWidth = SCREEN_WIDTH / 3;
 
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left);
        make.width.mas_equalTo(logoWidth);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoImageView.mas_right);
        make.top.equalTo(superView.mas_top);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@[descriptLabel.mas_height,groupNumLabel.mas_height]);
    }];
    [descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom);
        make.left.equalTo(logoImageView.mas_right);
        make.right.equalTo(superView.mas_right);
    }];
    [groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descriptLabel.mas_bottom).offset(5.0);
        make.width.mas_equalTo(groupImageView.mas_height);
        make.left.equalTo(logoImageView.mas_right);
        make.bottom.equalTo(separtorLabel.mas_top).offset(-5.0);
    }];
    [groupNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descriptLabel.mas_bottom);
        make.left.equalTo(groupImageView.mas_right).offset(10);
        make.right.equalTo(superView.mas_right);
        make.bottom.equalTo(separtorLabel.mas_top);
    }];
    [separtorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageView.mas_bottom);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.bottom.equalTo(superView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    
    nameLabel.text = @"清华大学";
    
    logoImageView.image = [UIImage imageNamed:@"Default_Img"];
    groupImageView.image = [UIImage imageNamed:@"Club_UserGroup"];
    descriptLabel.text = @"来约吧..";
    groupNumLabel.text = @"22";
}

#pragma -
#pragma mark - BindModel

- (void)setCell:(STClubModel *)model{
    nameLabel.text = model.name;
    logoImageView.image = [UIImage imageNamed:model.logo];
    descriptLabel.text = model.description;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}
@end
