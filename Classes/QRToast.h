//
//  QRToast.h
//  QRKit
//
//  Created by maxin on 15/11/28.
//  Copyright (c) 2015年 maxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRToast : NSObject

+ (void)showMessage:(NSString *)msg;

+ (void)showMessage:(NSString *)msg inView:(UIView *)view;

+ (void)showMessage:(NSString *)msg inView:(UIView *)view duration:(NSTimeInterval)duration;

@end
