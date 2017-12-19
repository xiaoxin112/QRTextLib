//
//  TimeXLJ.m
//  Lebang
//
//  Created by 熊良军 on 15/1/14.
//  Copyright (c) 2015年 熊良军. All rights reserved.
//

#import "QRTimeXLJ.h"

@implementation QRTimeXLJ
/*处理返回应该显示的时间*/
+ (NSString *) returnUploadTime_no1970:(NSString *)timeString1
{
    /***时间截*******/
    //float f = [timeString1 floatValue];
    //NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:f];
    //NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:f];
    //NSLog(@"1296035591  = %@",confromTimesp);
    //NSString *timestr = [NSString stringWithFormat:@"%@",confromTimesp];
    //Tue May 21 10:56:45 +0800 2013
    //NSLog(@"timeStr = %@",timestr);
    //NSString *timeStr = [timestr substringToIndex:19];
    
    /*****************/
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"YY-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:timeString1];
    //NSLog(@"d == %@",d);
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    //NSLog(@"late == %f",late);
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSDateFormatter *dateformatterLate=[[NSDateFormatter alloc] init];
    [dateformatterLate setDateFormat:@"dd"];
    NSString *  timeStringLate = [NSString stringWithFormat:@"%@",[dateformatterLate stringFromDate:d]];  //过去的时间日期
    NSDateFormatter *dateformatterNow=[[NSDateFormatter alloc] init];
    [dateformatterNow setDateFormat:@"dd"];
     NSString * timeStringNow = [NSString stringWithFormat:@"%@",[dateformatterNow stringFromDate:dat]];  //现在的时间日期
    //NSLog(@"timeStringLate = %@",timeStringLate);
    //NSLog(@"timeStringNow = %@",timeStringNow);
    //NSInteger timeStringLateInt = [timeStringLate integerValue];  //过去日期转整型
    //NSInteger timeStringNowInt = [timeStringNow integerValue];    //现在日期转整型
    //NSLog(@"timeStringLateInt = %i",timeStringLateInt);
    //NSLog(@"timeStringNowInt = %i",timeStringNowInt);
    
    NSTimeInterval cha=now-late;
    //NSLog(@"cha == %f",cha);
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        //timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        NSInteger time = [timeString integerValue];
        if (time<1){
            timeString = [NSString stringWithFormat:@"刚刚"];
        }else{
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"HH:mm"];
            timeString = [NSString stringWithFormat:@"今天 %@",[dateformatter stringFromDate:d]];
        }
    }else{
        if ([timeStringLate isEqualToString:timeStringNow]) {
            //        timeString = [NSString stringWithFormat:@"%f", cha/3600];
            //        timeString = [timeString substringToIndex:timeString.length-7];
            //        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"HH:mm"];
            timeString = [NSString stringWithFormat:@"今天 %@",[dateformatter stringFromDate:d]];
        }else{
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"HH:mm"];
            timeString = [NSString stringWithFormat:@"昨天 %@",[dateformatter stringFromDate:d]];
            
        }
    
    }
    
    if (cha/86400>1&&cha/(86400*2)<1) {
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HH:mm"];
        timeString = [NSString stringWithFormat:@"昨天 %@",[dateformatter stringFromDate:d]];
    }
    if (cha/(86400*2)>1)
    {
        //        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        //        timeString = [timeString substringToIndex:timeString.length-7];
        //        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        //[dateformatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
        [dateformatter setDateFormat:@"MM-dd"];
        timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:d]];
        //NSLog(@"timeString == %@",timeString);
    }
   
    return timeString;
}
+ (NSString *) returnUploadTime:(NSString *)timeString1
{
    /***时间截*******/
    
    NSDate *d1 = [NSDate dateWithTimeIntervalSince1970:[timeString1 doubleValue]];
    //NSLog(@"dddd:%@",d); //2011-01-18 13:00:00 +0000
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *showtimeNew = [formatter1 stringFromDate:d1];
    //NSLog(@"showtimeNew:%@",showtimeNew); //21:00 比d的时间 +8小时
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"YY-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:showtimeNew];
    NSLog(@"d == %@",d);
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    //NSLog(@"late == %f",late);
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSDateFormatter *dateformatterLate=[[NSDateFormatter alloc] init];
    [dateformatterLate setDateFormat:@"dd"];
    NSString *  timeStringLate = [NSString stringWithFormat:@"%@",[dateformatterLate stringFromDate:d]];  //过去的时间日期
    NSDateFormatter *dateformatterNow=[[NSDateFormatter alloc] init];
    [dateformatterNow setDateFormat:@"dd"];
    NSString * timeStringNow = [NSString stringWithFormat:@"%@",[dateformatterNow stringFromDate:dat]];  //现在的时间日期
    //NSLog(@"timeStringLate = %@",timeStringLate);
    //NSLog(@"timeStringNow = %@",timeStringNow);
    //NSInteger timeStringLateInt = [timeStringLate integerValue];  //过去日期转整型
    //NSInteger timeStringNowInt = [timeStringNow integerValue];    //现在日期转整型
    //NSLog(@"timeStringLateInt = %i",timeStringLateInt);
    //NSLog(@"timeStringNowInt = %i",timeStringNowInt);
    
    NSTimeInterval cha=now-late;
    //NSLog(@"cha == %f",cha);
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        //timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        NSInteger time = [timeString integerValue];
        if (time<1){
            timeString = [NSString stringWithFormat:@"刚刚"];
        }else{
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"HH:mm"];
            timeString = [NSString stringWithFormat:@"今天 %@",[dateformatter stringFromDate:d]];
        }
    }else{
        if ([timeStringLate isEqualToString:timeStringNow]) {
            //        timeString = [NSString stringWithFormat:@"%f", cha/3600];
            //        timeString = [timeString substringToIndex:timeString.length-7];
            //        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"HH:mm"];
            timeString = [NSString stringWithFormat:@"今天 %@",[dateformatter stringFromDate:d]];
        }else{
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"HH:mm"];
            timeString = [NSString stringWithFormat:@"昨天 %@",[dateformatter stringFromDate:d]];
            
        }
        
    }
    
    if (cha/86400>1&&cha/(86400*2)<1) {
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HH:mm"];
        timeString = [NSString stringWithFormat:@"昨天 %@",[dateformatter stringFromDate:d]];
    }
    if (cha/(86400*2)>1)
    {
        //        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        //        timeString = [timeString substringToIndex:timeString.length-7];
        //        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        //[dateformatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
        [dateformatter setDateFormat:@"MM-dd"];
        timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:d]];
        //NSLog(@"timeString == %@",timeString);
    }
    
    return timeString;
}
//是否同一天
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    
    
    return [comp1 day]   == [comp2 day] &&
    
    [comp1 month] == [comp2 month] &&
    
    [comp1 year]  == [comp2 year];
    
}
// 是否是今天
+(BOOL)isToDay:(NSDate*)date1
{
    NSDate *nowdate2=[TimeXLJ localeDate];
    return [TimeXLJ isSameDay:date1 date2:nowdate2];
}
//获取本地时间
+(NSDate *)localeDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *_localDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"当前时间 _localDate = %@",_localDate);
    
    return _localDate;
}
@end
