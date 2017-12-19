//
//  QRUMSocialHandler.m
//  QRKit
//
//  Created by xiaoxin on 2017/4/17.
//  Copyright © 2017年 maxin. All rights reserved.
//

#import "QRUMSocialHandler.h"
#if __has_include(<UMSocialCore/UMSocialCore.h>)
#import <UMSocialCore/UMSocialCore.h>
#endif

#if __has_include(<TencentOpenAPI/QQApiInterface.h>)
    #import <TencentOpenAPI/QQApiInterface.h>
#endif

#if __has_include("WXApi.h")
    #import "WXApi.h"
#endif

#if __has_include("WeiboSDK.h")
    #import "WeiboSDK.h"
#endif


@implementation QRUMSocialHandler
@dynamic isUsingHttpsWhenShareContent;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static  QRUMSocialHandler *_handle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handle = [super allocWithZone:zone];
        [_handle openLog:YES];
        [_handle clearCacheWhenGetUserInfo:NO];
    });
    return _handle;
}
+ (instancetype _Nonnull)shared {
    return [[super alloc] init];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}


+ (BOOL)isWXAppInstalled {
    
#if __has_include("WXApi.h")
    return [WXApi isWXAppInstalled];
#endif
    return NO;
}
+ (BOOL)isQQAppInstalled {
#if __has_include(<TencentOpenAPI/QQApiInterface.h>)
    return [QQApiInterface isQQInstalled];
#endif
    return NO;
}

+ (BOOL)isSinaAppInstalled {
    
#if __has_include("WeiboSDK.h")
    return [WeiboSDK isWeiboAppInstalled];
#endif

    return NO;
}
#pragma mark - initialize


- (void)openLog:(BOOL)isOpen {
#if __has_include(<UMSocialCore/UMSocialCore.h>)
    [[UMSocialManager defaultManager] openLog:isOpen];
#endif

}

- (void)initializeUMSocialSdk:(NSString *_Nonnull)appkey {
    
#if __has_include(<UMSocialCore/UMSocialCore.h>)
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:appkey];
#endif
    
}

#pragma mark - global

- (void)clearCacheWhenGetUserInfo:(BOOL)isClear {
    
#if __has_include(<UMSocialCore/UMSocialCore.h>)
    [[UMSocialGlobal shareInstance] setIsClearCacheWhenGetUserInfo:isClear];
#endif

}

- (void)setIsUsingHttpsWhenShareContent:(BOOL)isUsingHttpsWhenShareContent {
#if __has_include(<UMSocialCore/UMSocialCore.h>)
    [[UMSocialGlobal shareInstance] setIsUsingHttpsWhenShareContent:isUsingHttpsWhenShareContent];
#endif
}

#pragma mark - setup

- (BOOL)setupWeChatPlaformWith:(NSString *)appKey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL {
    
#if __has_include(<UMSocialCore/UMSocialCore.h>)
    return [self setPlaform:UMSocialPlatformType_WechatSession appKey:appKey appSecret:appSecret redirectURL:redirectURL];
#endif
    return NO;
}

- (BOOL)setupQQPlaformWith:(NSString *)appKey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL {
#if __has_include(<UMSocialCore/UMSocialCore.h>)
    return [self setPlaform:UMSocialPlatformType_QQ appKey:appKey appSecret:appSecret redirectURL:redirectURL];
#endif
    return NO;
}

- (BOOL)setupSinaPlaformWith:(NSString *)appKey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL {
#if __has_include(<UMSocialCore/UMSocialCore.h>)
    return [self setPlaform:UMSocialPlatformType_Sina appKey:appKey appSecret:appSecret redirectURL:redirectURL];
#endif
    return NO;
}

#if __has_include(<UMSocialCore/UMSocialCore.h>)

- (BOOL)setPlaform:(UMSocialPlatformType)platformType
            appKey:(NSString *)appKey
         appSecret:(NSString *)appSecret
       redirectURL:(NSString *)redirectURL {
    return [[UMSocialManager defaultManager] setPlaform:platformType appKey:appKey appSecret:appSecret redirectURL:redirectURL];
    return NO;
}

#endif


#pragma mark - 第三方登录

/**
 获取第三方登录授权成功后的用户资料
 */
- (void)getUserInfoWithPlatform:(QRSocialPlaformType)platformType
          currentViewController:(id _Nullable )currentViewController
                     completion:(QRUMSocialLoginCompletionHandler _Nullable )loginCompletion {
    
#if __has_include(<UMSocialCore/UMSocialCore.h>)
    UMSocialPlatformType type = platformType;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:type currentViewController:currentViewController completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        QRUMSocialUser *currentUser     = nil;
        if (resp) {
            
            currentUser                 = [[QRUMSocialUser alloc] init];
            currentUser.name            = resp.name;
            currentUser.iconurl         = resp.iconurl;
            currentUser.platformType    = platformType;
            currentUser.openId          = resp.uid;
            currentUser.gender          = [resp.gender integerValue];
            
        }
        
        if (loginCompletion)
            loginCompletion(currentUser,error);
        
    }];
#endif

    
}



/**  取消授权
 */
- (void)cancelAuthWithPlatform:(QRSocialPlaformType)platformType
                    completion:(QRUMSocialCancelCompletionHandler _Nullable )loginCompletion {

#if __has_include(<UMSocialCore/UMSocialCore.h>)
    
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        if (loginCompletion) {
            loginCompletion(error);
        }
    }];

#endif

    
}


#pragma mark - 第三方分享

/**
 *  设置分享平台
 */
- (void)shareToPlatform:(QRSocialPlaformType)platformType
          messageObject:(QRUMShreContent *_Nullable)content
  currentViewController:(UIViewController *_Nonnull)currentViewController
             completion:(QRUMSocialShareCompletionHandler _Nullable)shareCompletion {
    
    
#if __has_include(<UMSocialCore/UMSocialCore.h>)

    __block QRUMShreContent *shareContent = content;
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL                  = shareContent.thumbImage;
    UMShareWebpageObject *shareObject   = [UMShareWebpageObject shareObjectWithTitle:shareContent.title descr:shareContent.text thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl              = shareContent.webpageUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject           = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
        
        if (shareCompletion)
            shareCompletion(shareContent,error);
        shareContent = nil;
    }];

    
#endif

    
    
}


#pragma mark - handleOpenURL

- (BOOL)QR_handleOpenURL:(NSURL *)url options:(NSDictionary *)options {
    
#if __has_include(<UMSocialCore/UMSocialCore.h>)
    return [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
#endif
    return YES;
}

- (BOOL)QR_handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
#if __has_include(<UMSocialCore/UMSocialCore.h>)
    return [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
#endif
    return YES;
}



@end


/**
 第三方登录用户资料实体
 */
@implementation QRUMSocialUser

- (void)dealloc {
    
    
    
}

@end


/**
 分享的实体
 */
@implementation QRUMShreContent


/**
 创建一个分享实体类对象
 */
- (instancetype _Nullable )initWithTitle:(NSString *_Nullable)title
                                imageUrl:(id _Nullable)thumbImage
                                    text:(NSString *_Nullable)desc
                              webpageUrl:(NSString *_Nullable)shareUrl {
    self = [super init];
    
    if (self) {
        
        self.thumbImage         = thumbImage;
        self.title              = title;
        self.text               = desc;
        self.webpageUrl         = shareUrl;
        
    }
    
    return self;

}

- (void)dealloc {
    
    
}
@end
