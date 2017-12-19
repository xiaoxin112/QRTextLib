//
//  QRUMSocialHandler.h
//  QRKit
//
//  Created by xiaoxin on 2017/4/17.
//  Copyright © 2017年 maxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#if __has_include(<UMSocialCore/UMSocialCore.h>)
#import <UMSocialCore/UMSocialCore.h>
#endif

@class QRUMSocialUser , QRUMShreContent;

/**
 第三方平台类型
 */
typedef NS_ENUM(NSUInteger, QRSocialPlaformType) {
    QRSocialPlaformType_UnKnown            = -2,
    QRSocialPlaformType_Sina               = 0, //新浪
    QRSocialPlaformType_WechatSession      = 1, //微信聊天
    QRSocialPlaformType_WechatTimeLine     = 2,//微信朋友圈
    QRSocialPlaformType_WechatFavorite     = 3,//微信收藏
    QRSocialPlaformType_QQ                 = 4,//QQ聊天页面
    QRSocialPlaformType_Qzone              = 5,//qq空间
};

/**
 *  性别
 */
typedef NS_ENUM(NSUInteger, QRUMSocialUserGender){
    /**
     *  男
     */
    QRUMSocialUserGenderMale      = 0,
    /**
     *  女
     */
    QRUMSocialUserGenderFemale    = 1,
    /**
     *  未知
     */
    QRUMSocialUserGenderUnknown   = 2,
};


/**
 第三方登录授权成功后的回调内容

 @param user 用户信息
 @param error 错误信息
 */
typedef void(^QRUMSocialLoginCompletionHandler)(QRUMSocialUser *_Nullable user,NSError * _Nullable error);

/**
 第三方平台分享后的回调内容
 */
typedef void(^QRUMSocialShareCompletionHandler)(QRUMShreContent * _Nullable content,NSError * _Nullable error);

/**
 取消第三方平台登录成功的回调
 */
typedef void(^QRUMSocialCancelCompletionHandler)(NSError * _Nullable error);


/**
 对友盟分享的封装快速实现分享功能
 */
@interface QRUMSocialHandler : NSObject <NSCopying>

+ (instancetype _Nonnull)shared;

/*! @brief 检查微信是否已被用户安装
 *
 * @return 微信已安装返回YES，未安装返回NO。
 */
+ (BOOL)isWXAppInstalled;
/*! @brief 检查QQ是否已被用户安装
 *
 * @return QQ已安装返回YES，未安装返回NO。
 */
+ (BOOL)isQQAppInstalled;
/*! @brief 检查新浪微博是否已被用户安装
 *
 * @return 新浪微博已安装返回YES，未安装返回NO。
 */
+ (BOOL)isSinaAppInstalled;


/**
 初始化友盟分享 SDK
 */
- (void)initializeUMSocialSdk:(NSString *_Nonnull)appkey;

/**
 *  打开日志
 *
 *  @param isOpen YES代表打开，No代表关闭
 */
-(void) openLog:(BOOL)isOpen;

#pragma mark - setup

/**
 *  设置微信平台的appkey

 */
- (BOOL)setupWeChatPlaformWith:(NSString *_Nullable)appKey
                     appSecret:(NSString *_Nullable)appSecret
                   redirectURL:(NSString *_Nullable)redirectURL;

/**
 *  设置QQ平台的appkey

 */
- (BOOL)setupQQPlaformWith:(NSString *_Nullable)appKey
                     appSecret:(NSString *_Nullable)appSecret
                   redirectURL:(NSString *_Nullable)redirectURL;


/**
 *  设置新浪微博平台的appkey

 */
- (BOOL)setupSinaPlaformWith:(NSString *_Nullable)appKey
                     appSecret:(NSString *_Nullable)appSecret
                   redirectURL:(NSString *_Nullable)redirectURL;

#pragma mark - 第三方登录

/**
 获取第三方登录授权成功后的用户资料
 */
- (void)getUserInfoWithPlatform:(QRSocialPlaformType)platformType
          currentViewController:(id _Nullable )currentViewController
                     completion:(QRUMSocialLoginCompletionHandler _Nullable )loginCompletion;

/**  取消授权
 *
 */
- (void)cancelAuthWithPlatform:(QRSocialPlaformType)platformType
                    completion:(QRUMSocialCancelCompletionHandler _Nullable )loginCompletion;

/**
 *  是否清除缓存在获得用户资料的时候
 *  设置为YES,代表请求用户的时候需要请求缓存
 *  默认设置为NO,代表不清楚缓存，用缓存的数据请求用户数据
 */
- (void)clearCacheWhenGetUserInfo:(BOOL)isClear;

#pragma mark - 社会化分享

/**
 *  设置分享平台
 */
- (void)shareToPlatform:(QRSocialPlaformType)platformType
          messageObject:(QRUMShreContent *_Nullable)content
  currentViewController:(UIViewController *_Nonnull)currentViewController
             completion:(QRUMSocialShareCompletionHandler _Nullable)shareCompletion;

#pragma mark HandleOpenUrl

/**
 *  获得从其他 app回调到本app的回调 iOS9及iOS9以下版本可用
 */
-(BOOL)QR_handleOpenURL:(NSURL *_Nullable)url sourceApplication:(NSString *_Nullable)sourceApplication annotation:(id _Nullable )annotation;

/**
 *  获得从其他 app回调到本app的回调 ios9以上版本可用
 */
-(BOOL)QR_handleOpenURL:(NSURL *_Nullable)url options:(NSDictionary*_Nullable)options;





#if __has_include(<UMSocialCore/UMSocialCore.h>)

/**
 *  用来设置UMSocial的全局设置变量
 */
@property (nullable,weak,nonatomic) UMSocialGlobal *social_global;


#endif


/**
 *  当前网络请求是否用https
 *
 */
@property(atomic,assign)BOOL isUsingHttpsWhenShareContent;


@end

#pragma mark - User

/**
 用户授权后的资料信息
 */
@interface QRUMSocialUser : NSObject

/**
 *  平台类型
 */
@property (nonatomic) QRSocialPlaformType platformType;

/**
 第三方平台的openId
 */
@property (nonatomic,nullable,copy) NSString *openId;
/**
 第三方平台昵称
 */
@property (nonatomic, copy,nullable) NSString  *name;

/**
 第三方平台头像地址
 */
@property (nonatomic, copy,nullable) NSString  *iconurl;

/**
 性别
 */
@property (nonatomic,assign) QRUMSocialUserGender gender;

@end


/**
 分享内容的实体
 */
@interface QRUMShreContent : NSObject

/**
 *  文本标题
 */
@property (nonatomic,copy)NSString* _Nullable title;

/**
 * text 文本内容
 * @note 非纯文本分享文本
 */
@property (nonatomic, copy) NSString  * _Nullable text;

/**
 分享图片的 URL , NSData 或者 UIImage
 */
@property (nonatomic,strong,nullable) id thumbImage;

/**
 分享链接的 url
 */
@property (nonatomic,copy,nullable) NSString *webpageUrl;

/**
 *  平台类型
 */
@property (nonatomic) QRSocialPlaformType platformType;


/**
 创建一个分享实体类对象
 */
- (instancetype _Nullable )initWithTitle:(NSString *_Nullable)title
                                imageUrl:(id _Nullable)thumbImage
                                    text:(NSString *_Nullable)desc
                              webpageUrl:(NSString *_Nullable)shareUrl;


@end


