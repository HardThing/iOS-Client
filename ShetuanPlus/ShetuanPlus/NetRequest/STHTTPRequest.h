//
//  STHTTPRequest.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/18/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
@class MBProgressHUD;
@interface STHTTPRequest : AFHTTPRequestOperationManager
{
@private
    MBProgressHUD *_progressHUD;
}

+ (instancetype)sharedClient;

// Get方式访问
//- (void)getPath:(NSString *)path
//     parameters:(NSDictionary *)parameters
//showProgressView:(UIView *)superView
//       showText:(NSString *)progressTitle
//        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//
//// Post方式访问
//- (void)postPath:(NSString *)path
//      parameters:(NSDictionary *)parameters
//showProgressView:(UIView *)superView
//        showText:(NSString *)progressTitle
//         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//
//// Patch方式访问
//- (void)patchPath:(NSString *)path
//       parameters:(NSDictionary *)parameters
// showProgressView:(UIView *)superView
//         showText:(NSString *)progressTitle
//          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Get方式访问
- (void)getPath:(NSString *)path
        token:(NSString *)token
        parameters:(NSDictionary *)parameters
        showProgressView:(UIView *)superView
        showText:(NSString *)progressTitle
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Post方式访问
- (void)postPath:(NSString *)path
        token:(NSString *)token
        parameters:(NSDictionary *)parameters
        showProgressView:(UIView *)superView
        showText:(NSString *)progressTitle
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Patch
- (void)patchPath:(NSString *)path
            token:(NSString *)token
       parameters:(NSDictionary *)parameters
 showProgressView:(UIView *)superView
         showText:(NSString *)progressTitle
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// PUT
- (void)putPath:(NSString *)path
          token:(NSString *)token
     parameters:(NSDictionary *)parameters
showProgressView:(UIView *)superView
       showText:(NSString *)progressTitle
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
