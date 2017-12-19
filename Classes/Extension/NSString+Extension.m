//
//  NSString+Extension.m
//  QRKit
//
//  Created by xiaoxin on 2017/6/12.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSObject+QRFoundationKit.h"

@implementation NSString (Extension)
#pragma mark - MD5加密
/**
 *  MD5加密
 *
 *  @return MD5加密后的新字段
 */
- (NSString *_Nullable)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    // 先转MD5，再转大写
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
          ];

}

#pragma mark - URL编码
/**
 *  URL编码，http请求遇到汉字的时候，需要转化成UTF-8
 *
 *  @return 编码的字符串
 */
- (NSString *_Nullable)urlCodingToUTF8 {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!$&'()*+,-./:;=?@_~%#[]"]];
}
#pragma mark - URL解码
/**
 *  URL解码，URL格式是 %3A%2F%2F 这样的，则需要进行UTF-8解码
 *
 *  @return 解码的字符串
 */
- (NSString *_Nullable)urlDecodingToUrlString {
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data dataBase64Sting];
}

- (NSString *)base64DecodedString
{
    NSData *data = [self base64DecodedData];
    if (data)
    {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSData *)base64DecodedData
{
    return [NSData QR_dataWithBase64EncodedString:self];
}


/**
 *  计算字符串尺寸
 *
 *  @param fontSize   字体大小
 *  @param width   限定文字的宽度
 *  @return 返回一个 CGSize类型结构体
 */
-(CGSize)getTextSizeWithFont:(CGFloat)fontSize restrictWidth:(float)width {
    //动态计算文字大小
    NSDictionary *oldDict = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize oldPriceSize = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:oldDict context:nil].size;
    return oldPriceSize;
}
/**
 *  字符串中是否包含中文
 */
-(BOOL)QR_containChinese:(NSString *_Nonnull)str {
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

/**
 *  字符串如果是 N OR Y 的返回一个结果 BOOL 类型的返回值
 */
- (BOOL)QR_boolValue {
    
    if ([self isEqualToString:@"true"]||[self isEqualToString:@"1"]) {
        return YES;
    } else if ([self isEqualToString:@"false"]||[self isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}

/**
 汉字转拼音
 */
+ (NSString *)chineseTransformLetter:(NSString *)chinese {
    
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    
    NSString *letter = [pinyin uppercaseString];
    
    return letter;
}

/// 汉字转拼音 返回首字母

+ (NSString *)transformFirstLetter:(NSString *)chinese
{
    NSString *letter                = [self chineseTransformLetter:chinese];
    if (letter.length < 1) {
        return @"#";
    }
    NSString *firstLetter           = [letter substringToIndex:1];
    NSString *regex = @"^[A-Z]+$";
    NSPredicate *letterPredicate    = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL flag = [letterPredicate evaluateWithObject:firstLetter];
    if (!flag) {
        return @"#";
    } else {
        return firstLetter;
    }
    
}

/**
 *  判断银行卡号
 */
+ (BOOL) isValidCreditNumber:(NSString*)cardNo {
    
    int oddsum       = 0;//奇数求和
    int evensum      = 0;//偶数求和
    int allsum       = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum      = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)  {
        
        return YES;
    } else {
        return NO;
        
    }
    
    
}


/**
 身份证正则验证
 */
+(BOOL)checkIdentityCardNo:(NSString*)identityCard {

    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }

    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:identityCard];


    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(flag)
    {
        if(identityCard.length ==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];

            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];

            //用来保存前17位各自乖以加权因子后的总和

            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex   = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];

                idCardWiSum             += subStrIndex * idCardWiIndex;

            }

            //计算出校验码所在数组的位置
            NSInteger idCardMod = idCardWiSum%11;

            //得到最后一位身份证号码
            NSString * idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];

            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return flag;
                }else
                {
                    flag =  NO;
                    return flag;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return flag;
                }
                else
                {
                    flag =  NO;
                    return flag;
                }
            }
        }
        else
        {
            flag =  NO;
            return flag;
        }
    }
    else
    {
        return flag;
    }

    
}

/**
 *  把 app 版本号转成一个数字
 */
- (NSInteger)appVersionToInteger
{
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:self];
    while ([mutableString containsString:@"."]) {
        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"."]];
    }
    return mutableString.integerValue;
}


//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号码验证。YES 是手机号
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13，14， 15，17,18开头，八个 \d 数字字符
    NSString *phoneRegex = @"(^1[3|4|5|7|8][0-9]{9}$)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/**
 对字符串的空判断+空置替换
 */
+ (NSString *)stringByReplacingIfNull:(id)string {
    BOOL empty = [self empty:string];
    return empty ? @"" : string;
}

/**
 字符串是否为空
 */
+ (BOOL) empty:(id)obj {
    
    if (!obj) {
        return YES;
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (obj == (NSNull*)[NSNull null]) {
        return YES;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([obj isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([obj isEqualToString:@""]) {
        return YES;
    }
    if ([obj length]==0) {
        return YES;
    }
    return NO;
}

/**
 字符串去除空格
 */
-(NSString *)removeWhiteSpace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/**
 是否为纯数字 0-9 不包含 字母 符号
 */
- (BOOL)isNumberValue {
    
    NSString *number                    = @"^[0-9]*$";
    NSPredicate *regextestmobile        = [NSPredicate predicateWithFormat:@"SELF MATCHES  %@",number];
    
    BOOL isNumber                       = [regextestmobile evaluateWithObject:self];
    
    return isNumber;
}

- (BOOL)QR_isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

/**
 string to data
 */
- (NSData *_Nullable)dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}


@end
