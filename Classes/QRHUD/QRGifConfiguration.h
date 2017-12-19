//
//  QRGifConfiguration.h
//  QRKit
//
//  Created by xiaoxin on 2017/4/27.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRGifConfiguration : NSObject

@property (nonatomic,nullable,copy) NSString *imageName;

@property (nonatomic,assign) CGSize gifViewSize;

@property (nonatomic,assign) CGFloat gifSpeed;

@property (nonatomic,assign) CGFloat fadeDuration;

/**
 *  禁用 init 方法来生成该类的实例对象
 */
- (_Nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;
/**
 *  禁用 new 方法来生成该类的实例对象
 */
+ (_Nonnull instancetype)new UNAVAILABLE_ATTRIBUTE;


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
                               gifViewSize:(CGSize)size;


@end
