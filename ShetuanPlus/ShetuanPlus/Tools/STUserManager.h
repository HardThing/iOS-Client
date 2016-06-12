//
//  STUserManager.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/31/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STUserManager : NSObject
//set
+ (void)setUsername:(NSString *)userName;
+ (void)setToken:(NSString *)token;
+ (void)setUserId:(NSString *)userId;
+ (void)setPassword:(NSString *)password;
+ (void)setIsLogin:(BOOL)isLogin;
+ (void)setCurrentProvince:(NSString *)province;

//get
+ (NSString *)getUsername;
+ (NSString *)getToken;
+ (NSString *)getUserId;
+ (NSString *)getPassword;
+ (BOOL)isLogin;
+ (NSString *)getCurrentProvince;
@end
