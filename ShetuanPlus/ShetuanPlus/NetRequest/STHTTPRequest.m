//
//  STHTTPRequest.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 8/18/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STHTTPRequest.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
@implementation STHTTPRequest

+ (instancetype)sharedClient{
    static STHTTPRequest *sharedRequest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRequest = [[STHTTPRequest alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",BaseURL]]];
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        sharedRequest.requestSerializer = requestSerializer;
    });
    return sharedRequest;
}

#pragma mark -No Token

//get
- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
showProgressView:(UIView *)superView
       showText:(NSString *)progressTitle
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [self getPath:path token:nil parameters:parameters showProgressView:superView showText:progressTitle success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

// Post方式访问
- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
showProgressView:(UIView *)superView
        showText:(NSString *)progressTitle
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [self postPath:path token:nil parameters:parameters showProgressView:superView showText:progressTitle success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

- (void)patchPath:(NSString *)path
       parameters:(NSDictionary *)parameters
 showProgressView:(UIView *)superView
         showText:(NSString *)progressTitle
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [self patchPath:path token:nil parameters:parameters showProgressView:superView showText:progressTitle success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];

}
#pragma mark - Token

- (void)getPath:(NSString *)path
        token:(NSString *)token
        parameters:(NSDictionary *)parameters
        showProgressView:(UIView *)superView
        showText:(NSString *)progressTitle
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (![self isNetworkAvailable]) {
        [STHUD showErrorWithText:@"您的网络异常，请检查网络连接！" inView:superView];
        return;
    }
    
    if (superView != nil) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:superView activityKind:UIActivityIndicatorViewStyleWhite];
        [superView addSubview:_progressHUD];
        _progressHUD.detailsLabelText = progressTitle;
        _progressHUD.removeFromSuperViewOnHide = YES;
        [_progressHUD show:YES];
    }
    
    [super GET:path token:token parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_progressHUD != nil) {
            [_progressHUD hide:YES];
        }
        
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_progressHUD != nil) {
            [_progressHUD hide:YES];
        }
        [STHUD showText:NSLocalizedString(@"STServerWrong", nil) inView:superView];
        failure(operation,error);
    }];
}

- (void)postPath:(NSString *)path
        token:(NSString *)token
        parameters:(NSDictionary *)parameters
        showProgressView:(UIView *)superView
        showText:(NSString *)progressTitle
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (![self isNetworkAvailable]) {
        [STHUD showErrorWithText:@"您的网络异常，请检查网络连接！" inView:superView];
        return;
    }
    
    if (superView != nil) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:superView activityKind:UIActivityIndicatorViewStyleWhite];
        [superView addSubview:_progressHUD];
        _progressHUD.detailsLabelText = progressTitle;
        _progressHUD.removeFromSuperViewOnHide = YES;
        [_progressHUD show:YES];
    }
    
    [super POST:path token:token parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_progressHUD != nil) {
            [_progressHUD hide:YES];
        }
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_progressHUD != nil) {
            [_progressHUD hide:YES];
        }
        [STHUD showText:NSLocalizedString(@"STServerWrong", nil) inView:superView];
        failure(operation,error);
    }];
}


- (void)patchPath:(NSString *)path
           token:(NSString *)token
      parameters:(NSDictionary *)parameters
showProgressView:(UIView *)superView
        showText:(NSString *)progressTitle
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (![self isNetworkAvailable]) {
        [STHUD showErrorWithText:@"您的网络异常，请检查网络连接！" inView:superView];
        return;
    }
    
    if (superView != nil) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:superView activityKind:UIActivityIndicatorViewStyleWhite];
        [superView addSubview:_progressHUD];
        _progressHUD.detailsLabelText = progressTitle;
        _progressHUD.removeFromSuperViewOnHide = YES;
        [_progressHUD show:YES];
    }
    
    [super PATCH:path token:token parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_progressHUD != nil) {
            [_progressHUD hide:YES];
        }
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_progressHUD != nil) {
            [_progressHUD hide:YES];
        }
        [STHUD showText:NSLocalizedString(@"STServerWrong", nil) inView:superView];
        failure(operation,error);
    }];
}

- (void)putPath:(NSString *)path
            token:(NSString *)token
       parameters:(NSDictionary *)parameters
 showProgressView:(UIView *)superView
         showText:(NSString *)progressTitle
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (![self isNetworkAvailable]) {
        [STHUD showErrorWithText:@"您的网络异常，请检查网络连接！" inView:superView];
        return;
    }
    
    if (superView != nil) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:superView activityKind:UIActivityIndicatorViewStyleWhite];
        [superView addSubview:_progressHUD];
        _progressHUD.detailsLabelText = progressTitle;
        _progressHUD.removeFromSuperViewOnHide = YES;
        [_progressHUD show:YES];
    }
    
    [super PUT:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_progressHUD != nil) {
            [_progressHUD hide:YES];
        }
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_progressHUD != nil) {
            [_progressHUD hide:YES];
        }
        [STHUD showText:NSLocalizedString(@"STServerWrong", nil) inView:superView];
        failure(operation,error);
    }];
}

- (BOOL)isNetworkAvailable
{
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
        return YES;
    }
        return NO;
}
@end
