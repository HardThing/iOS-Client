//
//  STClubTableViewCell.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 9/2/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STClubModel;

@interface STClubTableViewCell : UITableViewCell

#pragma mark -BindModel

- (void)setCell:(STClubModel *)model;

@end
