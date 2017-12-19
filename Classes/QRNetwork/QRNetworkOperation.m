//
//  skNetworkOperation.m
//  skKit
//
//  Created by xiaoxin on 2017/4/21.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import "QRNetworkOperation.h"
#import <AFNetworking/AFNetworking.h>

@interface QRNetworkOperation ()

@property (nonatomic,nullable,strong) id parameters;
@property (nonatomic,copy,nullable) NSString *httpMethod;

@end

@implementation QRNetworkOperation

- (void)main {
    
    [super main];

    
    __weak typeof(self)weakSelf = self;
    // 如果使用 [skNetwokManager dataWithRequest] 时会执行这个 if 判断里边的代码
    if (self.request) {
        
         self.task =  [self.sessionManager dataTaskWithRequest:self.request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            __strong typeof(weakSelf)strongify = weakSelf;
            if (strongify.completionHandler)
                strongify.completionHandler(response, responseObject, error);
            
        }];
        
        [self.task resume];
        
        return;
    }
    
    // 使用 [skNetworkManager GET] [skNetworkManager POST]请求会调用下边的方法
    if ([self.httpMethod isEqualToString:@"GET"]) {
    
        self.task =  [self.sessionManager GET:self.reqeustURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            __strong typeof(weakSelf)strongify = weakSelf;
            if (strongify.success)
                strongify.success(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            __strong typeof(weakSelf)strongify = weakSelf;
            if (strongify.failure)
                strongify.failure(task,error);
        }];

    } else {
        
        self.task =  [self.sessionManager POST:self.reqeustURL parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(weakSelf)strongify = weakSelf;
            if (strongify.success)
                strongify.success(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            __strong typeof(weakSelf)strongify = weakSelf;
            if (strongify.failure)
                strongify.failure(task,error);
        }];
        
        
    }
    
}

/**
 开始网络请求
 */
- (void)start {
    
    [super start];
    
    if (self.task)
        [self.task resume];
    
}


- (instancetype)initOperationWithManager:(AFHTTPSessionManager *)manager httpMethod:(NSString *)method url:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * _Nullable, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nullable))failure {
    
    
    if (self = [super init]) {
        
        self.reqeustURL         = URLString;
        self.success            = success;
        self.failure            = failure;
        self.httpMethod         = method;
        self.sessionManager     = manager;
        self.parameters         = parameters;
        
    }
    
    return self;
}


/**
 取消网络请求
 */
- (void)cancel {

    [super cancel];
    
    [self.task cancel];
    self.task = nil;
    
}


- (void)dealloc {
    
    
//    NSLog(@"dealloc");
    
}

@end
