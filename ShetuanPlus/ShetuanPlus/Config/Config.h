//
//  Config.h
//  shetuanplus
//
//  Created by Jiao Liu on 7/29/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#ifndef shetuanplus_Config_h
#define shetuanplus_Config_h

#pragma mark - 全局设置

#define UmengKey @"55b889dce0f55a3575000a86"
#define BaseURL @"http://api.shetuanplus.com/app/v1/"


#pragma mark - 网络接口宏

// 登录注册相关
#define STLOGIN @"accounts/login"
#define STREGISTER @"accounts/register"
#define STVERIFIED_CODE @"accounts/verifiedCode"
#define STREGISTER_AVAILABLE @"accounts/register/available"
#define STRESET_PASSWORD @"accounts/login/password"

// 个人信息相关
#define PERSONAL_INFOMATION_BASE [NSString stringWithFormat:@"%@userInfos/",BaseURL]
#define PERSONAL_MODIFY_NAME [NSString stringWithFormat:@"%@userName",PERSONAL_INFOMATION_BASE]

//基础数据
#define STBASEDATA [NSString stringWithFormat:@"%@baseData/",BaseURL]  
#define STBASEDATA_PROVINCE [NSString stringWithFormat:@"%@provinces/",STBASEDATA]
#define STBASEDATA_PROVINCE_SCHOOL(provinceId) [NSString stringWithFormat:@"%@schools?provinceId=%ld",STBASEDATA,provinceId]

#endif
