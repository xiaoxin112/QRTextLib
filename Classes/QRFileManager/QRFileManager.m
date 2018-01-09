//
//  QRFileManager.m
//  QRKit
//
//  Created by xiaoxin on 2017/4/13.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import "QRFileManager.h"

@implementation QRFileManager

/// 把对象归档存到沙盒里
+(void)saveObject:(id)object byFileName:(NSString*)fileName
{
    @synchronized (self) {
        if (!object||!fileName||[fileName isEqualToString:@""]) return;
        NSString *path  = [self appendFilePath:fileName];
        [NSKeyedArchiver archiveRootObject:object toFile:path];
    }
}
/**
 *  通过类名来获取存储的类模型文件
 *
 *  @param className 类名
 *
 *  @return  返回该类的实例
 */
+(id)getObjectByClassName:(Class)className
{
    return [self getObjectByFileName:NSStringFromClass(className)];
}
/// 通过文件名从沙盒中找到归档的对象
+(id)getObjectByFileName:(NSString*)fileName
{
    NSString *path  = [self appendFilePath:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}
// 根据文件名删除沙盒中的 plist 文件
+(void)removeFileByFileName:(NSString*)fileName
{
    NSString *path  = [self appendFilePath:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}
/// 拼接文件路径
+(NSString*)appendFilePath:(NSString*)fileName
{
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *file = [NSString stringWithFormat:@"%@/%@.plist",documentsPath,fileName];
    return file;
}
/// 存储用户偏好设置 到 NSUserDefults
+(void)saveUserDefaults:(id)data forKey:(NSString*)key
{
    if (!data||!key) return;
    @synchronized (self) {
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
/// 读取用户偏好设置
+(id)readUserDefaultsForKey:(NSString*)key
{
    if (!key) return nil;
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}
/// 删除用户偏好设置
+(void)removeUserDefaultsForkey:(NSString*)key
{
    if (!key) return;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
/**
 *   存储文件通过类名
 *
 *  @param object    对象
 *  @param className 类名
 */
+ (void)saveObject:(id)object byClassName:(Class)className
{
    [self saveObject:object byFileName:NSStringFromClass(className)];
}
/**
 *  通过类名移除该类存储的模型文件
 *
 *  @param className 类名
 */
+ (void)removeFileByClassName:(Class)className
{
    [self removeFileByFileName:NSStringFromClass(className)];
}

+ (void)removeUserDefaultsForkeys:(NSArray *)keys {
    for (NSString *key in keys) {
        [QRFileManager removeUserDefaultsForkey:key];
    }
}


@end
