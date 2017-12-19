//
//  TimeXLJ.h
//  Lebang
//
//  Created by 熊良军 on 15/1/14.
//  Copyright (c) 2015年 熊良军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRTimeXLJ : NSObject
+ (NSString *) returnUploadTime_no1970:(NSString *)timeString1;
//1970
+ (NSString *) returnUploadTime:(NSString *)timeString1;
//s是否同一天
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;
//是否是今天
+(BOOL)isToDay:(NSDate*)date1;
//获取本地时间
+(NSDate *)localeDate;
@end
