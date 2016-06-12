//
//  STAddActivityViewController.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/6/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STButtonView.h"

@interface STAddActivityViewController : UIViewController<STButtonViewDelegate>
{
    @private
    STButtonView *createActView,*createOrgView,*joinOrgView;
}

@end
