//
//  STPersonInforViewController.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/6/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STPersonCenterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    @private
    UITableView *listView;
    UIImageView *headImgView;
    UILabel *nameLabel;
    UILabel *idLabel;
}

@end
