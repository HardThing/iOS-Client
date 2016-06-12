//
//  STUserLocation.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/28/15.
//  Copyright © 2015 Jiao Liu. All rights reserved.
//

#import "STUserLocation.h"

@interface STUserLocation()<CLLocationManagerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) CLLocationManager *locationManager;

@end
@implementation STUserLocation

+ (instancetype)sharedLocation{
    
    static STUserLocation *sharedUserLocation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedUserLocation = [[STUserLocation alloc] init];
    });
    return sharedUserLocation;
}

- (instancetype)init{
    if (self = [super init]) {
        
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
            [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
            ) {
            [_locationManager requestWhenInUseAuthorization];
        } else {
            [_locationManager startUpdatingLocation];
        }
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            
        }
            break;
        case kCLAuthorizationStatusDenied: {
            UIAlertView *deniedAlertView = [[UIAlertView alloc]
                                       initWithTitle:@"您尚未开启定位服务，现在要去开启吗?" message:@"或稍后去设置\"设置->隐私->定位服务\"中开启" delegate:self cancelButtonTitle:@"稍后开启" otherButtonTitles:@"现在开启",nil];
            [deniedAlertView show];
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [_locationManager startUpdatingLocation];
        }
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *mark = [placemarks lastObject];
        
        if (!mark.administrativeArea) {
            return ;
        }
        
        if ([self.delegate respondsToSelector:@selector(autoLoationCity:)]){
            
            [self.delegate autoLoationCity:mark.administrativeArea];
            [STUserManager setCurrentProvince:mark.administrativeArea];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //后期需要优化
    NSLog(@"%@",error);
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!buttonIndex) {
        //取消
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

}
@end
