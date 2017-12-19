//
//  UIImage+QR_Extension.h
//  QRKit
//
//  Created by xiaoxin on 2017/6/13.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (QR_Extension)

/**
 *  获取系统启动页图片
 */
+ (UIImage *_Nullable)app_lauchImage;

/**
 程序的 icon
 */
+ (UIImage *_Nullable)app_icon_60_60;

/**
 获取 Assets.xcassets 的 appIcon  AppIcon40x40 , AppIcon60x60
 */
+ (UIImage *_Nullable)app_iconWithName:(NSString *_Nullable)name;

/**
 获取所有 Assets.xcassets 的 appIcon的图片名称
 ( 
  AppIcon40x40 ,
  AppIcon60x60
 )
 */
+ (NSArray *_Nullable)app_icon_names;


/**
 *  将图片裁剪成圆形图片
 *
 */
- (UIImage *_Nullable)cirleImage;

/**
 *  给张图片设置渲染模式为不渲染
 *
 *  @param name 图片名
 *
 *  @return 返回图片 UIImage 对象
 */
+ (instancetype _Nullable )rendeWithName:(NSString *_Nullable)name;

/**
 调整图片的方向
 */
- (UIImage *_Nullable)normalizedImage;


/// 通过一个 UIColor 生成一个 UIImage
+ (UIImage *_Nullable)imageWithColor:(UIColor *_Nonnull)color;

/**
    通过 UIColor 生成一个 UIImage 对象
 */
+ (nullable UIImage *)imageWithColor:(UIColor *_Nullable)color size:(CGSize)size;

@end
