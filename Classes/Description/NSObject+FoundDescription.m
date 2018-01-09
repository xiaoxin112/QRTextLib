//
//  NSObject+FoundDescription.m
//  字典格式化
//
//  Created by 大兵布莱恩特 on 15/6/12.
//  Copyright (c) 2015年 dzb. All rights reserved.
//

#import "NSObject+FoundDescription.h"
#import <objc/runtime.h>

@implementation NSObject (FoundDescription)

/**
 *  主要适用于自定义模型便利模型的每个属性 并打印出来
 *
 *  @return 返回 json 字符串 如果模型中又字典 数组 打印出来有 / /n 等字符暂时无法去除 
 */
-(NSString *)description1
{
    //  取得当前类类型
    Class cls = [self class];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned int ivarsCnt = 0;
    //　获取类成员变量列表，ivarsCnt为类成员数量
    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    
    //　遍历成员变量列表，其中每个变量都是Ivar类型的结构体
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;
        
        //　获取变量名
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        //　获取变量值
        id value = [self valueForKey:key];
        
        NSMutableString *keyString = [NSMutableString stringWithString:key];
        //把 key 前边的下划线去掉
        if ([keyString rangeOfString:@"_"].location!=NSNotFound)
        {
            [keyString deleteCharactersInRange:NSMakeRange(0, 1)];

        }
        if (value)
        {
            if ([value isKindOfClass:[NSArray class]])
            {
                NSArray *arr = (NSArray*)value;
                [dict setValue:[arr description1] forKey:keyString];
            }else if ([value isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict1 =(NSDictionary*)value;
                [dict setValue:[dict1 description1] forKey:keyString];
            }else
            {
                [dict setValue:[NSString stringWithFormat:@"%@",value] forKey:keyString];
            }
            
        }else
        {
            [dict setValue:@"" forKey:keyString];
        }
        
    }
    
    NSMutableString *string = [dict description1];
    // 去除特殊符号
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@/（）¥「」＂、#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    string = [NSMutableString stringWithString:[string stringByTrimmingCharactersInSet:set]];
    
    return string;
}


@end


@implementation NSArray (NSArrayDescription)

- (NSMutableString *)description1
{
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJapaneseEUCStringEncoding error:nil];
    NSMutableString *string = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
    
}

@end

@implementation NSDictionary(NSDictionaryDescription)

- (NSMutableString *)description1
{
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJapaneseEUCStringEncoding error:nil];
    NSMutableString *string = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

@end


@implementation NSData (JSON)

/**
 *  json 转 oc 字典或数组
 *
 *  @return object
 */
-(id)json
{
    NSObject *object = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
    return object;
}

@end
