//
//  QRFileManager.h
//  QRKit
//
//  Created by xiaoxin on 2017/4/13.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRFileManager : NSObject

#pragma mark 读取数据

/// 读取用户偏好设置
+(id)readUserDefaultsForKey:(NSString*)key;


/// 通过文件名从沙盒中找到归档的对象
+(id)getObjectByFileName:(NSString*)fileName;

/**
 *  通过类名来获取存储的类模型文件
 */
+(id)getObjectByClassName:(Class)className;


#pragma mark - 存取数据

/// 把对象归档存到沙盒里
+(void)saveObject:(id)object byFileName:(NSString*)fileName;


/// 存储用户偏好设置 到 NSUserDefults
+(void)saveUserDefaults:(id)data forKey:(NSString*)key;

/**
 *   存储文件通过类名
 *
 *  @param object    对象
 *  @param className 类名
 */
+(void)saveObject:(id)object byClassName:(Class)className;

#pragma mark - 删除数据

/// 删除用户偏好设置
+(void)removeUserDefaultsForkey:(NSString*)key;

/**
 从 NSUserDefaults 删除多个数据 通过 key
 
 */
+ (void)removeUserDefaultsForkeys:(NSArray *)keys;

/**
 *  通过类名移除该类存储的模型文件
 *
 *  @param className 类名
 */
+(void)removeFileByClassName:(Class)className;


/// 根据文件名删除沙盒中的 plist 文件
+(void)removeFileByFileName:(NSString*)fileName;


@end
