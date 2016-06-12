//
//  STClubModel.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 9/2/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "JSONModel.h"

@interface STClubModel : JSONModel

//组织ID
@property (assign, nonatomic) NSString * id;

//组织名称
@property (assign, nonatomic) NSString * name;

//组织logo
@property (strong, nonatomic) NSString * logo;

//简介
@property (strong, nonatomic) NSString * desc;

//标语
@property (strong, nonatomic) NSString *slogan;

//创建时间
@property (strong, nonatomic) NSString *created_time;

//更新时间
@property (strong, nonatomic) NSString *last_updated_time;

//学校id
@property (strong, nonatomic) NSString *school_id;

//社团id
@property (strong, nonatomic) NSString *college_id;

//会长id
@property (strong, nonatomic) NSString *president_id;

//类型 //社团，小组，etc
@property (strong, nonatomic) NSString *type;

//成员数量
@property (assign, nonatomic) NSInteger member_count;

//打赏账户
@property (strong, nonatomic) NSString *pay_account;

//打赏账户类型
@property (strong, nonatomic) NSString *pay_account_type;

@end
