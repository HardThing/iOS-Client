//
//  STUserManager.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/31/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STUserManager.h"
#import "KeychainItemWrapper.h"

@implementation STUserManager

//set

+ (void)setUsername:(NSString *)userName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"ST_USERNAME"];
    [defaults synchronize];
}

+ (void)setToken:(NSString *)token{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"ST_TOKEN"];
    [defaults synchronize];
}

+ (void)setUserId:(NSString *)userId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userId forKey:@"ST_USERID"];
    [defaults synchronize];
}

+ (void)setPassword:(NSString *)password{
    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc]initWithIdentifier:@"SheTuan" accessGroup:nil];
    [keyChain setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    [keyChain setObject:@"ST_Password" forKey:(__bridge id)kSecAttrAccount];
    [keyChain setObject:password forKey:(__bridge id)kSecValueData];
}

+ (void)setIsLogin:(BOOL)isLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:isLogin] forKey:@"ST_ISLOGIN"];
    [defaults synchronize];
}

+ (void)setCurrentProvince:(NSString *)province{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:province forKey:@"ST_CURRENTPROVINCE"];
    [defaults synchronize];
}
//get

+ (NSString *)getUsername{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"ST_USERNAME"];
}

+ (NSString *)getToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"ST_TOKEN"];
}

+ (NSString *)getUserId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"ST_USERID"];
}

+ (NSString *)getPassword{
    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc]initWithIdentifier:@"SheTuan" accessGroup:nil];
    return [keyChain objectForKey:(__bridge id)kSecValueData];
}

+ (BOOL)isLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:@"ST_ISLOGIN"] boolValue];
}

+ (NSString *)getCurrentProvince{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"ST_CURRENTPROVINCE"];
}
@end
