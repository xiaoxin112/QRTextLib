//
//  skNetworkManager.m
//  skKit
//
//  Created by xiaoxin on 2017/4/21.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import "QRNetworkManager.h"
#import "QRNetworkOperation.h"
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>

static  QRNetworkManager * _networkManager;

@interface QRNetworkManager  ()<NSCopying>

@property (nonatomic,strong) NSOperationQueue *opeartionQueue;

@property (nonatomic,strong) NSMutableDictionary *allTasks;

@property (nonnull,strong,nonatomic) AFHTTPSessionManager *httpSessionManager;

@end

@implementation QRNetworkManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkManager = [super allocWithZone:zone];
    });
    return _networkManager;
}

+ (instancetype) manager {
    
    return [[super alloc] init];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

- (NSOperationQueue *)opeartionQueue {
    if (!_opeartionQueue) {
        _opeartionQueue = [[NSOperationQueue alloc] init];
        _opeartionQueue.maxConcurrentOperationCount = 3;
    }
    return _opeartionQueue;
}

- (NSMutableDictionary *)allTasks {
    if (!_allTasks) {
        _allTasks = [NSMutableDictionary dictionary];
    }
    return _allTasks;
}

- (AFHTTPSessionManager *)httpSessionManager {
    if (!_httpSessionManager) {
        AFHTTPSessionManager *manager               = [AFHTTPSessionManager manager];
        manager.responseSerializer                  = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.stringEncoding    = NSUTF8StringEncoding;
        manager.operationQueue.maxConcurrentOperationCount = 3;
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval   = timeoutInterval;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _httpSessionManager                         = manager;
    }
    return _httpSessionManager;
}

+ (void) GET:(NSString *_Nullable)URLString
  parameters:(nullable id)parameters
     success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure {
    
    @synchronized ([self manager]) {
        
        QRNetworkManager *manager           = [self manager];
        QRNetworkOperation *op              = [manager publicRequst:URLString httpMethod:@"GET" parameters:parameters success:success failure:failure];
        
        [manager.opeartionQueue addOperation:op];
        
        [manager.allTasks setObject:op forKey:[manager md5:URLString]];

    }
    
}

+ (void) POST:(NSString *_Nullable)URLString
   parameters:(nullable id)parameters
      success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure {
    
    @synchronized ([self manager]) {
        
        QRNetworkManager *manager           = [self manager];
        QRNetworkOperation *op              = [manager publicRequst:URLString httpMethod:@"POST" parameters:parameters success:success failure:failure];
        
        [manager.opeartionQueue addOperation:op];
        
        [manager.allTasks setObject:op forKey:[manager md5:URLString]];
        
    }

    
}


+ (void) dataTaskWithRequest:(NSURLRequest *_Nullable)request
           completionHandler:(void (^_Nullable)(NSURLResponse * _Nullable response, id _Nullable responseObject, NSError * _Nullable error))callBack {
    
    
    
    @synchronized ([self manager]) {
        
       __weak QRNetworkManager *manager    = [self manager];
       __block NSString *requestString      = request.URL.absoluteString;
        // 同一个 url 多次请求会取消之前的 operation
        [[self manager] cancelTaskForKey:requestString];

        QRNetworkOperation *operation       = [[QRNetworkOperation alloc] init];
        
        operation.sessionManager            = manager.httpSessionManager;
        operation.request                   = request;
        operation.completionHandler         = ^(NSURLResponse *response,id responseObject,NSError *error) {
            
            if (callBack)
            callBack(response,responseObject,error);
            [manager cancelTaskForKey:requestString];
            
        };
        
        operation.reqeustURL                = requestString;
        [manager.opeartionQueue addOperation:operation];
        
        [manager.allTasks setObject:operation forKey:[manager md5:requestString]];
        
    }
    
    
}

#pragma mark - MD5加密
/**
 *  MD5加密
 *
 *  @return MD5加密后的新字段
 */
- (NSString *_Nullable)md5:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    // 先转MD5，再转大写
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}



- (nullable QRNetworkOperation *)publicRequst:(NSString *_Nullable)URLString
                                    httpMethod : (NSString *_Nullable)method
                                     parameters:(nullable id)parameters
                                        success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                                        failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure {
 
    // 同一个 url 多次请求会取消之前的 operation
    [self cancelTaskForKey:URLString];
    
    __weak typeof(self)weakSelf = self;
    
    QRNetworkOperation *operation = [[QRNetworkOperation alloc] initOperationWithManager:self.httpSessionManager httpMethod:method url:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        __strong typeof(weakSelf)strongify = weakSelf;
        
        if (success)
            success(task,responseObject);
        [strongify cancelTaskForKey:URLString];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
        __strong typeof(weakSelf)strongify = weakSelf;

        if (failure)
            success(task,error);
        
        [strongify cancelTaskForKey:URLString];

    }];
    
    return operation;
    
}

- (void) cancelTaskForKey:(NSString *)key {
    
    NSString *md5Key                = [self md5:key];
    
    QRNetworkOperation *operation   = [self.allTasks objectForKey:md5Key];
    
    if (!operation) return;
    
    [operation cancel];
    
    [self.allTasks removeObjectForKey:md5Key];
    
}

- (void) cancellAllTask {

    for (QRNetworkOperation *operation in [self.allTasks allValues]) {
        [self cancelTaskForKey:operation.reqeustURL];
    }
    
}

@end
