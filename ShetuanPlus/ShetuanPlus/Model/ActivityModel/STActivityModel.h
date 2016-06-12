//
//  STActivityModel.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 9/2/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "JSONModel.h"

@interface STActivityModel : JSONModel

//活动ID
@property (assign, nonatomic) NSString * id;

//活动名称
@property (assign, nonatomic) NSString * name;

//活动logo
@property (strong, nonatomic) NSString * logo;

//简介
@property (strong, nonatomic) NSString * desc;

//地点
@property (strong, nonatomic) NSString *location;

//开始时间
@property (strong, nonatomic) NSString *start_time;

//结束时间
@property (strong, nonatomic) NSString *end_time;

//发起时间
@property (strong, nonatomic) NSString *created_time;

//更新时间
@property (strong, nonatomic) NSString *last_updated_time;

//活动打赏方式
@property (strong, nonatomic) NSString *donate_type;

//打赏截至时间
@property (strong, nonatomic) NSString *donate_deadline;

//发起人
@property (strong, nonatomic) NSString *founder;

//发起人类型
@property (strong, nonatomic) NSString *founderType;

//附件
@property (strong, nonatomic) NSData *attachment;

@end
