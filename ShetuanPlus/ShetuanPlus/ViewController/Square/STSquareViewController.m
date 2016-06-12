//
//  STSquareViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/5/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STSquareViewController.h"
#import "STLoginViewController.h"
#import "STMessageViewController.h"
#import "STMainTabBarController.h"
#import "STAdsHeaderView.h"
#import "STHotActivityCollectionViewCell.h"
#import "STNavigationController.h"
#import "RFQuiltLayout.h"
#import <AVFoundation/AVFoundation.h>


#define kHotActivityCellIndentifier @"kHotActivityCellIndentifier"
#define kAdsHeadView @"kAdsHeadViewIndentifier"

@interface STSquareViewController()<UICollectionViewDataSource,UICollectionViewDelegate,STSquareHeaderViewDelegate,RFQuiltLayoutDelegate>
{
    @private
    UICollectionView *mainCollectionView;
    __block NSMutableArray *localArr;
    NSArray *testArr;
    NSMutableArray *photoArr;
}
@end
@implementation STSquareViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self adsImagesArrFromWeb];
    [self setNavLeftHeadImageItem];
    [self setBaseCollectionConfigure];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    STHotActivityCollectionViewCell *cell = (STHotActivityCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kHotActivityCellIndentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
#pragma mark - UICollectionViewDelegateFlowLayout

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 1;
//}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 1;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 0) {
//        return CGSizeMake(SCREEN_WIDTH / 2.0 - 1, 200);
//    }
//    else{
//        return CGSizeMake(SCREEN_WIDTH / 2.0 - 1, 300);
//    }
////    return CGSizeMake(SCREEN_WIDTH / 2.0 - 1, 200);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsZero;
//}
//
//- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return CGSizeMake(SCREEN_WIDTH, 100);
//    }
//    return CGSizeZero;
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    STAdsHeaderView *headerView =  [collectionView dequeueReusableSupplementaryViewOfKind:STAdsLayoutAlbumTitleKind withReuseIdentifier:kAdsHeadView forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor grayColor];
    headerView.delegate = self;
    [headerView setAdsWith:localArr defaultImage:[UIImage imageNamed:@"Default_Img"] frame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    return headerView;
}

#pragma mark - SetNavAndCollectionView

- (void)setNavLeftHeadImageItem{
    UIButton *headImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    headImageBtn.layer.cornerRadius = 18;
    headImageBtn.layer.masksToBounds = YES;
    headImageBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    headImageBtn.layer.borderWidth = 1.5;
    [headImageBtn addTarget:self action:@selector(BtnClickToLoginAction) forControlEvents:UIControlEventTouchUpInside];
        //if user set headimage before,if not ,use default logo.
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"headImage"]) {
        //has store
    }
    else{
        [headImageBtn setBackgroundImage:[UIImage imageNamed:@"Default_User"] forState:UIControlStateNormal];
        [headImageBtn setBackgroundImage:[UIImage imageNamed:@"Default_User"] forState:UIControlStateHighlighted];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:headImageBtn];
}

- (void)setBaseCollectionConfigure{
    
    self.title = @"广场";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Square_Message"] style:UIBarButtonItemStylePlain target:self action:@selector(goToMessage)];
    self.navigationItem.rightBarButtonItem.tintColor = APPBULECOLOR;
    RFQuiltLayout *layout = [[RFQuiltLayout alloc]init];
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.blockPixels = CGSizeMake(SCREEN_WIDTH / 2,144);
    layout.delegate = self;
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) collectionViewLayout:layout];
    mainCollectionView.showsVerticalScrollIndicator = NO;
    [mainCollectionView registerClass:[STHotActivityCollectionViewCell class] forCellWithReuseIdentifier:kHotActivityCellIndentifier];
    [mainCollectionView registerClass:[STAdsHeaderView class] forSupplementaryViewOfKind:STAdsLayoutAlbumTitleKind withReuseIdentifier:kAdsHeadView];
    mainCollectionView.backgroundColor = BACKGROUND_COLOR;
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    mainCollectionView.alwaysBounceVertical = YES;
    [self.view addSubview:mainCollectionView];
    [mainCollectionView reloadData];
}

#pragma mark - BtnAction

- (void)BtnClickToLoginAction{
    
    STLoginViewController *loginVC = [[STLoginViewController alloc] init];
    STNavigationController *loginNav = [[STNavigationController alloc] initWithRootViewController:loginVC];
    if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"7.1")) {
        
    }
    [self.view.window.rootViewController presentViewController:loginNav animated:YES completion:nil];

}

- (void)goToMessage{
    
    STMessageViewController *messageVC = [[STMessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
    
}

#pragma mark - STAdsHeaderDelegate

- (void)handleRedirect:(NSObject *)item{
    
}

#pragma mark - getAdsImages

- (void)adsImagesArrFromWeb{

    localArr = [NSMutableArray array];
    NSArray *imageArray = @[@"http://pic2.nipic.com/20090427/2390580_091546018_2.jpg",
                            @"http://image.tianjimedia.com/uploadImages/2012/236/5UADNJV31013.jpg",
                            @"http://pic.58pic.com/58pic/11/10/80/20X58PICzs8.jpg"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *urlStr in imageArray) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            UIImage *image = [UIImage imageWithData:data];
            if (data && image) {
                 [localArr addObject:image];
            }
            else{
                [localArr addObject:[UIImage imageNamed:@"Activity_Location"]];
            }
           
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [mainCollectionView reloadData];
        });
    });

}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.row % 2 == 0)
            return CGSizeMake(1, 2);
        if (indexPath.row % 3 == 0)
            return CGSizeMake(1, 4);
    
        return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return UIEdgeInsetsMake(2, 2, 2, 2);
}
@end
