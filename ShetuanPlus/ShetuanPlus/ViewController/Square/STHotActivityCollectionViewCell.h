//
//  STHotActivityCollectionViewCell.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/16/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STActivityModel;
@interface STHotActivityCollectionViewCell : UICollectionViewCell


#pragma mark - BindModelToUI

@property (strong,nonatomic) STActivityModel *model;

@end
