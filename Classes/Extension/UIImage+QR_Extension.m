//
//  UIImage+QR_Extension.m
//  QRKit
//
//  Created by xiaoxin on 2017/6/13.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import "UIImage+QR_Extension.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImage (QR_Extension)

/**
 程序的 icon
 */
+ (UIImage *_Nullable)app_icon_60_60 {
    
    return [UIImage app_iconWithName:@"AppIcon60x60"];
    
}

+ (NSArray *_Nullable)app_icon_names {
    NSDictionary* imagesDict = [[NSBundle mainBundle] infoDictionary][@"CFBundleIcons"][@"CFBundlePrimaryIcon"];
    NSArray *icons = [imagesDict objectForKey:@"CFBundleIconFiles"];
    return icons;
}

+ (UIImage *_Nullable)app_iconWithName:(NSString *)name {
    
    NSArray *icons = [self app_icon_names];

    for (NSString *named in icons) {
        if ([named isEqualToString:name]) {
            return [UIImage imageNamed:named];
        }
    }
    
    return nil;
}

/**
 *  获取系统启动页图片
 */
+ (UIImage *_Nullable)app_lauchImage
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
            break;
        }
    }
    return [UIImage imageNamed:launchImage];
}

/**
 *  将图片裁剪成圆形图片
 */
- (UIImage*)cirleImage {
    
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *cirleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return cirleImage;
}

/**
 *  给张图片设置渲染模式为不渲染
 *
 *  @param name 图片名
 *
 *  @return 返回图片 UIImage 对象
 */
+ (instancetype)rendeWithName:(NSString*)name
{
    return [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)normalizedImage {
    
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);

    [self drawInRect:CGRectMake(0.0f, 0.0f, self.size.width, self.size.height)];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
    
}

/// 通过一个 UIColor 生成一个 UIImage
+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
