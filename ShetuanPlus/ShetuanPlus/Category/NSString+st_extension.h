//
//  NSString+STExtension.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/5/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (st_extension)

// 检测是否为合法邮箱
+ (BOOL)isValidAccount:(NSString *)account;
+ (BOOL)isValidEmailAddress:(NSString *)emailStr;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)isValidVerifyCode:(NSString *)verifyCode;

//该字符串是否为空
+ (BOOL)isEmpty:(NSString *) string;
//去掉前后的空格
- (NSString *)trim;
-(NSString *)stringByStrippingWhitespace;

//是否包含
- (BOOL)isContainsString:(NSString*)other;
-(BOOL)contains:(NSString *)string;

//编码
-(NSString *)MD5;
-(NSString *)sha1;

//字符串反转
-(NSString *)reverse;

//URL编码
-(NSString *)URLEncode;
-(NSString *)URLDecode;

//截取子串
-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;

//首字母大写
-(NSString *)CapitalizeFirst:(NSString *)source;

//添加下划线
-(NSString *)UnderscoresToCamelCase:(NSString*)underscores;

//驼峰式转换
-(NSString *)CamelCaseToUnderscores:(NSString *)input;

//统计总字符数
-(NSUInteger)countWords;



@end
