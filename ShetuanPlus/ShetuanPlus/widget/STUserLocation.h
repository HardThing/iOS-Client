//
//  STUserLocation.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/28/15.
//  Copyright © 2015 Jiao Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol STUserLocationDelegate;




@interface STUserLocation : NSObject

@property (nonatomic,weak) id<STUserLocationDelegate> delegate;

+ (instancetype)sharedLocation;

@end



@protocol STUserLocationDelegate <NSObject>

@optional
- (void)autoLoationCity:(NSString *)currentCity;

@end