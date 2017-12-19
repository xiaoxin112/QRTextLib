//
//  QRToast.m
//  QRKit
//
//  Created by maxin on 15/11/28.
//  Copyright (c) 2015年 maxin. All rights reserved.
//

#import "QRToast.h"
#import <objc/runtime.h>
#import <pthread/pthread.h>



@implementation QRToast

+ (void)showMessage:(NSString *)msg{


    if (pthread_main_np() != 0) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [QRToast showMessage:msg inView:window.rootViewController.view duration:2.0f];
        
    } else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [QRToast showMessage:msg inView:window.rootViewController.view duration:2.0f];
        });
        
    }
    

}


+ (void)showMessage:(NSString *)msg inView:(UIView *)view
{
    [QRToast showMessage:msg inView:view duration:2.0f];
}

+ (void)showMessage:(NSString *)msg inView:(UIView *)view duration:(NSTimeInterval)duration
{
    if(view && msg && duration > 0)
    {
        UILabel *lb = (UILabel *)objc_getAssociatedObject(view, @"Message");
        if(!lb)
        {
            lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260.0f, 2000.0f)];
            lb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
            lb.textColor = [UIColor whiteColor];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.font = [UIFont boldSystemFontOfSize:14];
            lb.numberOfLines = 0;
            lb.layer.masksToBounds = YES;
            lb.layer.cornerRadius = 7.0f;
            lb.layer.shouldRasterize = YES;
            lb.text = [NSString stringWithFormat:@" %@ ",msg];
            
            [view addSubview:lb];
            objc_setAssociatedObject(view, @"Message", lb, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            __block UILabel *blockLabel = lb;
            double delayInSeconds = duration;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [blockLabel removeFromSuperview];
                objc_setAssociatedObject(view, @"Message", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            });
        }
        
        [view bringSubviewToFront:lb];
        
        CGSize vwSize = view.bounds.size;
        CGSize lbSize =  [self getTextSizeWithFont:13.0f restrictWidth:[UIScreen mainScreen].bounds.size.width *0.6f text:lb.text];
        lbSize.width = MIN(260.0f, MAX(60.0f, lbSize.width + 20.0f));
        lbSize.height = MIN(120.0f, MAX(30.0f, lbSize.height + 5.0f));
        lb.frame = CGRectMake(0, 0, lbSize.width, lbSize.height);
        lb.center = CGPointMake(vwSize.width / 2.0f, vwSize.height * 0.65);
        
        
    }
}

+ (CGSize)getTextSizeWithFont:(CGFloat)fontSize restrictWidth:(float)width text:(NSString *)text {
    //动态计算文字大小
    NSDictionary *oldDict = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize oldPriceSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:oldDict context:nil].size;
    return oldPriceSize;
}

@end
