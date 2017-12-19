//
//  QRNetworkOperation.h
//  QRKit
//
//  Created by xiaoxin on 2017/4/21.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager ,NSURLSessionDataTask;

/**
 请求成功的回调
 */
typedef void (^QRResponseSuccessBlock) (NSURLSessionDataTask * _Nullable taQR, id _Nullable responseObject);

/**
 请求失败的回调
 */
typedef void (^QRResponseFailureBlock)(NSURLSessionDataTask * _Nullable taQR, NSError * _Nullable error);

/**
 网络请求接受到响应的回调
 */
typedef  void (^QRDataTaQRBlock)(NSURLResponse * _Nullable response, id _Nullable responseObject,  NSError * _Nullable error);


/**
 网络请求的任务 一个任务代表一个网络请求
 */
@interface QRNetworkOperation : NSOperation


/**
 成功
 */
@property (nonatomic,copy,nullable) QRResponseSuccessBlock success;

/**
 失败
 */
@property (nonatomic,copy,nullable) QRResponseFailureBlock failure;

/**
 网络请求完成
 */
@property (nonatomic,copy,nullable) QRDataTaQRBlock  completionHandler;

/**
  AFHttpSessionManager
 */
@property (nonatomic,weak,nullable) AFHTTPSessionManager *sessionManager;

/**
 网络请求的 URL
 */
@property (nonatomic,nullable,copy) NSString *reqeustURL;

@property (nonatomic,strong,nullable) NSURLSessionDataTask *task;

@property (nonatomic,strong,nullable) NSURLRequest *request;


- (nullable instancetype) initOperationWithManager:(AFHTTPSessionManager *_Nullable)manager
                                        httpMethod:(NSString *_Nullable)method
                                               url:(NSString *_Nullable)URLString
                                        parameters:(nullable id)parameters
                                           success:(nullable void (^)(NSURLSessionDataTask * _Nullable taQR, id _Nullable responseObject))success
                                           failure:(nullable void (^)(NSURLSessionDataTask * _Nullable taQR, NSError * _Nullable error))failure;


@end
