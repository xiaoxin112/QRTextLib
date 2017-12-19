//
//  QRShareView.h
//  QRKit
//
//  Created by xiaoxin on 2017/4/17.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRUMSocialHandler.h"

/**
 分享视图
 */
@interface QRShareView : UIView

/**
  打开分享视图

 @param view 展示在哪个 view 上
 @param content 分享内容实体
 @param shareCompletion 分享结果
 */
- (void)shareToView:(UIView *_Nullable)view
          shareContent:(QRUMShreContent *_Nullable)content
         completion:(QRUMSocialShareCompletionHandler _Nullable)shareCompletion;


@end
