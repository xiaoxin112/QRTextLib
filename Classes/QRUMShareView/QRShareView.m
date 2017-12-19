//
//  QRShareView.m
//  QRKit
//
//  Created by xiaoxin on 2017/4/17.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import "QRShareView.h"
#define KContentViewH 180

@interface QRButton : UIButton


@end


@implementation QRButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0.0f, contentRect.size.height*0.7f, contentRect.size.width, contentRect.size.height*0.2f);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat y = 5.0f;
    CGFloat w = contentRect.size.width * 0.5f;
    CGFloat h = w;
    CGFloat x = (contentRect.size.width - w)*0.5f;
    
    return CGRectMake(x, y, w, h);
}

- (void)dealloc {
    
    
    
}
@end


@interface QRShareView ()

@property (nonatomic,strong,nullable) QRUMShreContent *shareContent;
@property (nonatomic,copy,nullable) QRUMSocialShareCompletionHandler completion;
@property (nonatomic,weak) UIView *cover;
@property (nonatomic,weak) UIView *contentView;
@end

@implementation QRShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tag                = 1000123;
        
        // 创建一个阴影
        UIView *cover           = [[UIView alloc] initWithFrame:frame];
        cover.backgroundColor   = [UIColor blackColor];
        self.cover              = cover;
        [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCancel)]];
        cover.tag               = 100;
        cover.alpha             = 0.5;
        [self addSubview:cover];
        
        
        // 创建一个提示框
        CGFloat tipX = 0;
        CGFloat tipW = cover.frame.size.width - 2*tipX;
        CGFloat tipH = KContentViewH;
        
        UIView *tipViews            = [[UIView alloc] initWithFrame:CGRectMake(tipX, [UIScreen mainScreen].bounds.size.height, tipW, tipH)];
        tipViews.backgroundColor    = [UIColor colorWithWhite:1 alpha:1];
        [self addSubview:tipViews];
        self.contentView            = tipViews;
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, tipViews.frame.size.width, 30)];
        lable.text  =@"分享到";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor=[UIColor grayColor];
        lable.font = [UIFont systemFontOfSize:15.0f];
        [tipViews addSubview:lable];
        
        NSArray *imgArr,*titleArr;
        
        
#if TARGET_IPHONE_SIMULATOR//模拟器
        imgArr      = @[@"QRShareView.bundle/weixin_share",@"QRShareView.bundle/pengyouquan",@"QRShareView.bundle/qq_share",@"QRShareView.bundle/kongjian"];
        titleArr    = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间"];

#elif TARGET_OS_IPHONE
        
        //真机
        if ([QRUMSocialHandler isWXAppInstalled]&&[QRUMSocialHandler isQQAppInstalled]) {
            imgArr      = @[@"QRShareView.bundle/weixin_share",@"QRShareView.bundle/pengyouquan",@"QRShareView.bundle/qq_share",@"QRShareView.bundle/kongjian"];
            titleArr    = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间"];
        }
        
        if (![QRUMSocialHandler isWXAppInstalled]) {
            
            imgArr      = @[@"QRShareView.bundle/qq_share",@"QRShareView.bundle/kongjian"];
            titleArr    = @[@"QQ好友",@"QQ空间"];
        }
        
 
#endif

        
        for (int i = 0; i < titleArr.count; i++) {
            
            int line = 4;
            CGFloat btnW                        = 90;
            CGFloat margin                      = (CGRectGetWidth(tipViews.frame) - line*btnW)*0.25;
            CGFloat btnX                        = margin + i%line*(btnW+margin);
            CGFloat btnY                        = i/line*btnW;
            QRButton *btnShare                  = [[QRButton alloc] initWithFrame:CGRectMake(btnX,40 + btnY, btnW, btnW)];
            btnShare.tag                        = i+100;
            btnShare.imageView.contentMode      = UIViewContentModeScaleAspectFit;
            [btnShare setTitle:titleArr[i] forState:UIControlStateNormal];
            [btnShare setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
            [btnShare setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btnShare addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            btnShare.titleLabel.textAlignment   = NSTextAlignmentCenter;
            btnShare.titleLabel.font            = [UIFont systemFontOfSize:15.0f];
            [btnShare setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [tipViews addSubview:btnShare];
            
        }
        
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, tipH-50, [UIScreen mainScreen].bounds.size.width, 1.0f)];
        line.backgroundColor=[UIColor colorWithWhite:0.783 alpha:1.000];
        [tipViews addSubview:line];
        
        //        CGFloat btnW = 80;
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(tipViews.frame) - 45, [UIScreen mainScreen].bounds.size.width, 35)];
        //        cancelBtn.layer.cornerRadius = 5;
        [cancelBtn setTitle:@"取消分享" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //        cancelBtn.backgroundColor = NavColor;
        [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        [tipViews addSubview:cancelBtn];

        
        
    }
    return self;
}


- (void)shareToView:(UIView *)view
       shareContent:(QRUMShreContent *)content
         completion:(QRUMSocialShareCompletionHandler)shareCompletion {
    
    if (!view) {
        view = [[UIApplication sharedApplication].delegate window];
    }
    
    // 移除旧的视图
    UIView *lastView = [view viewWithTag:1000123];
    if (lastView) {
        [lastView removeFromSuperview];
        lastView = nil;
    }
    // 添加新的视图到父 view
    [view addSubview:self];
    
    self.shareContent   = content;
    self.completion     = shareCompletion;
    
}


- (void)clickCancel
{
    [self hideView];
}

- (void)clickBtn:(UIButton *)btn
{

    QRSocialPlaformType platform   = QRSocialPlaformType_QQ;
    BOOL is_install_wechat          = [QRUMSocialHandler isWXAppInstalled];
    switch (btn.tag) {
        case 100:
        {
            platform = is_install_wechat ? QRSocialPlaformType_WechatSession : QRSocialPlaformType_QQ;
        }
            break;
        case 101:
        {
            platform = is_install_wechat ? QRSocialPlaformType_WechatTimeLine : QRSocialPlaformType_Qzone;
        }
            break;
        case 102:
            platform = QRSocialPlaformType_QQ;
            break;
        case 103:
            platform = QRSocialPlaformType_Qzone;
            break;
        default:
            break;
    }
    
    
    [self shareWebPageToPlatformType:platform];
    
    [self hideView];

    
}

- (void)shareWebPageToPlatformType:(QRSocialPlaformType)platformType {
    
    
    __weak typeof(self)weakSelf = self;
    
    [[QRUMSocialHandler shared] shareToPlatform:platformType messageObject:self.shareContent currentViewController:self.currentViewCotroller completion:^(QRUMShreContent * _Nullable content, NSError * _Nullable error) {
        __strong typeof(weakSelf)strongify = weakSelf;
        
        if (strongify.completion) {
            strongify.completion(content, error);
            [strongify removeFromSuperview];
        }

    }];
    
    
}

- (UIViewController *)currentViewCotroller {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (void)hideView {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = CGRectMake(0.0f, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200.0f);
    } completion:^(BOOL finished) {
        [self.contentView removeFromSuperview];
        self.contentView = nil;
        [self.cover removeFromSuperview];
        self.cover = nil;
        self.hidden = YES;
    }];
    
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = CGRectMake(0.0f, [UIScreen mainScreen].bounds.size.height - KContentViewH, [UIScreen mainScreen].bounds.size.width, KContentViewH);
    } completion:^(BOOL finished) {
        
        
    }];
    
}

- (void)dealloc {
    
    
}

@end


