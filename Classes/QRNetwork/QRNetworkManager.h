//
//  QRNetworkManager.h
//  QRKit
//
//  Created by xiaoxin on 2017/4/21.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger timeoutInterval = 30.0f;

@interface QRNetworkManager : NSObject

+ (instancetype _Nonnull) manager;


/**
 GET请求方式
 */
+ (void) GET:(NSString *_Nullable)URLString
  parameters:(nullable id)parameters
     success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

/**
 POST请求方式
 */
+ (void) POST:(NSString *_Nullable)URLString
   parameters:(nullable id)parameters
      success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

/**
 通用请求方式 根据 Request决定请求方式
 */
+ (void) dataTaskWithRequest:(NSURLRequest *_Nullable)request
          completionHandler:(void (^_Nullable)(NSURLResponse * _Nullable response, id _Nullable responseObject, NSError * _Nullable error))callBack;

/**
 请求单个网络请求
 */
- (void) cancelTaQRForKey:(NSString *_Nullable)key;

/**
 取消多个网络请求
 */
- (void) cancellAllTask;

@end
