//
//  NSObject+FoundDescription.h
//  字典格式化
//
//  Created by 大兵布莱恩特 on 15/6/12.
//  Copyright (c) 2015年 dzb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FoundDescription)
/**
 *  格式化自己建的模型类
 *
 *  @return 返回模型类中的所有成员变量 
 */
-(NSString *)description1;

@end


@interface NSArray (NSArrayDescription)

-(NSMutableString*)description1;


@end

@interface NSDictionary(NSDictionaryDescription)

-(NSMutableString*)description1;


@end


@interface NSData (JSON)


@end