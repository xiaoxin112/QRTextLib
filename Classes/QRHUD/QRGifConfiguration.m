//
//  QRGifConfiguration.m
//  QRKit
//
//  Created by xiaoxin on 2017/4/27.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import "QRGifConfiguration.h"

@implementation QRGifConfiguration

/**
 推荐的初始化方法
 
 @param name 图片名称
 @param speed 动画速度
 @param duration 时间
 @param size 指示器的 size
 @return  config
 */
- (nonnull instancetype) initWithImageName:(NSString *_Nullable)name
                                  gifSpeed:(CGFloat)speed
                              fadeDuration:(CGFloat)duration
                               gifViewSize:(CGSize)size {
    
    self = [super init];
    if (self) {
        
        _imageName      = name;
        _fadeDuration   = duration;
        _gifSpeed       = speed;
        _gifViewSize    = size;
        
    }
    return self;

    
}


@end
