//
//  STActivityViewController.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/6/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STActivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    @private
    UITableView *ActivityListView;
    UIBarButtonItem *schoolBtn;
    UISearchDisplayController *displayController;
}

@end
