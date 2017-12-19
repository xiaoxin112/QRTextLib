//
//  NSString+Extension.h
//  QRKit
//
//  Created by xiaoxin on 2017/6/12.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

/*******字符串加密编码**********/

#pragma mark - MD5加密
/**
 *  MD5加密
 *
 *  @return MD5加密后的新字段
 */
- (NSString *_Nullable)md5;

#pragma mark - URL编码
/**
 *  URL编码，http请求遇到汉字的时候，需要转化成UTF-8
 *
 *  @return 编码的字符串
 */
- (NSString *_Nullable)urlCodingToUTF8;

#pragma mark - URL解码
/**
 *  URL解码，URL格式是 %3A%2F%2F 这样的，则需要进行UTF-8解码
 *
 *  @return 解码的字符串
 */
- (NSString *_Nullable)urlDecodingToUrlString;

/**
 字符串编码成 base64加密
 */
- (nullable NSString *)base64EncodedString;

/**
 base64字符串解码
 */
- (nullable NSString *)base64DecodedString;

/**
 将 base64字符串转成 NSData
 */
- (nullable NSData *)base64DecodedData;

/*********字符串常用方法***********/

/**
 *  计算字符串尺寸
 *
 *  @param fontSize   字体大小
 *  @param width   限定文字的宽度
 *  @return 返回一个 CGSize类型结构体
 */
-(CGSize)getTextSizeWithFont:(CGFloat)fontSize restrictWidth:(float)width;

/**
 *  字符串中是否包含中文
 */
-(BOOL)QR_containChinese:(NSString *_Nonnull)str;

/**
 *  字符串如果是 N OR Y 的返回一个结果 BOOL 类型的返回值
 */
- (BOOL)QR_boolValue;

/**
 *  银行卡号验证
 */
+ (BOOL) isValidCreditNumber:(NSString*_Nullable)value;
//

/**
 *  身份证号验证
 */
+(BOOL)checkIdentityCardNo:(NSString*_Nullable)cardNo;

/// 汉字转拼音 返回首字母 A-Z (数字 ,特殊符号 #代替 )
+ (NSString *_Nullable)transformFirstLetter:(NSString *_Nullable)chinese;

/**
 汉字转拼音
 */
+ (NSString *_Nullable)chineseTransformLetter:(NSString *_Nullable)chinese;

/**
 *  把 app 版本号转成一个数字
 */
- (NSInteger)appVersionToInteger;

/**
 字符串是否为空
 */
+ (BOOL) empty:(id _Nullable )obj;

/**
 对字符串的空判断+空置替换
 */
+ (NSString *_Nullable)stringByReplacingIfNull:(id _Nullable )string;

/**
 去除字符串中的空格
 */
-(NSString *_Nullable)removeWhiteSpace;

/**
 是否为纯数字 0-9 不包含 字母 符号
 */
- (BOOL)isNumberValue;

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)QR_isNotBlank;

/**
 string to data
 */
- (NSData *_Nullable)dataValue;


@end
