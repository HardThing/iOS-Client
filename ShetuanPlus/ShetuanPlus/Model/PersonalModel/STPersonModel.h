//
//  STPersonModel.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/9/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

//学历
typedef NS_ENUM(NSInteger, STEducationType){
    STEducationTypeZK,//专科
    STEducationTypeBK,//本科
    STEducationTypeSS,//硕士
    STEducationTypeBS //博士
};

//用户是否认证
typedef NS_ENUM(NSInteger, STUserAuthType){
    STUserAuthTypeNone,
    STUserAuthTypeAlready
};

typedef NS_ENUM(NSInteger, STPaymentType) {
    STPaymentTypeAliPay,
    STPaymentTypeWXPay
};

#import "JSONModel.h"

@interface STPersonModel : JSONModel

//ID has
@property (assign, nonatomic) NSInteger id;

//头像 has
@property (strong,nonatomic) NSString<Optional> *avatar;

//姓名
@property (strong, nonatomic) NSString *userName;

//用户名 ---- 系统随机生成，不为空
//@property (strong, nonatomic) NSString *account;

//性别   1: female 0: male 默认为0
@property (assign, nonatomic) NSInteger gender;

//出生日期
@property (strong, nonatomic) NSDate<Optional> *birthday;

//手机号
@property (strong, nonatomic) NSString/*<Optional>*/ *phone;

//邮箱
@property (strong, nonatomic) NSString<Optional> *email;

//学校
@property (strong, nonatomic) NSString<Optional> *schoolName;

//学历 //默认为0专科
@property (assign, nonatomic) STEducationType education;

//院系
@property (strong, nonatomic) NSString<Optional> *collegeName;

//入学年份
@property (assign, nonatomic) NSInteger beginTime;

//身份认证 ----默认未认证
//@property (assign, nonatomic) STUserAuthType authType;

//支付账号
@property (strong, nonatomic) NSString<Optional> *paymentAccount;

//支付类型 建议默认为支付宝支付
//@property (assign, nonatomic) STPaymentType paymentType;

@end
