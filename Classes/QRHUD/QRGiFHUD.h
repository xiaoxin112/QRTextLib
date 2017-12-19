
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 如果修改配置信息
/*
 
 // 拿到全局的 gifConfig 去修改
 QRGifConfiguration *config  = [QRGiFHUD shareInstacne].gifConfig;
 config.imageName            = @"TH.gif";
 
 // 或者创建一个新的  gifConfig 通过  QRGifConfiguration initWithImageName:gifSpeed:fadeDuration:gifViewSize:
 // 设置配置信息
 [QRGiFHUD setupGifConfig:config];
 
 */

@class QRGifConfiguration;

@interface QRGiFHUD : UIView

+ (void)show;
+ (void)showWithOverlay;
+ (void)dismiss;
+ (void)setGifWithImages:(NSArray *_Nullable)images;
+ (void)setGifWithImageName:(NSString *_Nullable)imageName;
+ (void)setGifWithURL:(NSURL *_Nullable)gifUrl;

/**
 获取全局的 HUD 实例
 */
+ (instancetype)shareInstacne;

/**
 更改 gifView 的配置
 */
+ (void)setupGifConfig:(QRGifConfiguration *_Nonnull)config;

/**
    HUD 配置信息
 */
@property (nonatomic,strong,readonly) QRGifConfiguration *gifConfig;

NS_ASSUME_NONNULL_END

@end

