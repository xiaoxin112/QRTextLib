//
//  NSObject+QRFoundationKit.h
//  QRKit
//
//  Created by xiaoxin on 2017/6/11.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark QRFoundationKit

@interface NSObject (QRFoundationKit)

/**
 关联一个对象 保留所有权

 @param value 对象的值
 @param key   对象的 key
 */
- (void)setAssociateValue:(id _Nullable )value withKey:(void *_Nullable)key;

/**
 关联一个弱引用对象

 @param value 对象的值
 @param key  对象的 key
 */
- (void)setAssociateWeakValue:(id _Nullable )value withKey:(void *_Nullable)key;

/**
 移除所有关联的对象
 */
- (void)removeAssociatedValues;

/**
 移除关联的某个对象 根据这个对象的 key
 */
- (id _Nullable )getAssociatedValueForKey:(void *_Nullable)key;

/**
 类方法 获取类名
 */
+ (NSString *_Nonnull)className;

/**
 实例方法获取类型
 */
- (NSString *_Nonnull)className;


/**
 判断对象是否为空,如果判断字符串 请用 [NSString empty:@"null"]
 @param obj 要做空判断的对象
 @return 返回结果 如果对象为空 返回 YES 不为空返回 NO
 */
+ (BOOL)object_empty:(id _Nullable )obj;

#pragma mark - KVO拓展
/**
 给对象添加自己的属性观察方法 KVO

 @param keyPath 属性的 keypath
 @param block 属性发生改变的回调
 */
- (void)QR_addObserverBlockForKeyPath:(NSString*_Nullable)keyPath
                             block:(void (^_Nullable)
                                    (id _Nonnull obj,
                                     id _Nonnull oldVal,
                                     id _Nonnull newVal))block;
/**
 移除对属性的观察

 @param keyPath 属性的 keypath
 */
- (void)QR_removeObserverBlocksForKeyPath:(NSString*_Nullable)keyPath;

/**
 移除所有属性观察的回调 block
 */
- (void)QR_removeObserverBlocks;


#pragma mark - performSelector

- (nullable id)QR_performSelectorWithArgsOnMainThread:(SEL _Nullable )sel
                                       withObjects:(NSArray*_Nullable)objects;

- (nullable id)QR_performSelectorWithArgs:(SEL _Nullable )sel
                              onThread:(NSThread *_Nullable)thread withObjects:(NSArray*_Nullable)objects;

- (void)QR_performSelectorWithArgs:(SEL _Nullable )sel
                       withObjects:(NSArray*_Nullable)objects
                        afterDelay:(NSTimeInterval)delay;

- (nullable id)QR_performSelectorWithArgs:(SEL _Nullable )aSelector
                              withObjects:(NSArray*_Nullable)objects;


@end

#pragma mark QRArrayKit


@interface NSArray <__covariant ObjectType> (QRArrayKit)

/**
 根据元素下标获取数组中对应下标的元素

 @param index 下标
 @return 返回元素 如果对应下标没有元素 返回 nil
 */
- (nullable ObjectType)safe_ObjectAtIndex:(NSUInteger)index;

/**
 数组是否为 nil
 */
@property (nonatomic,assign,readonly) BOOL isEmpty;


/**
 从数组中随机取出一个元素
 */
- (nonnull id)randomObject;


/**
 array to jsonString
 */
- (NSString *_Nullable)jsonValue;



@end

#pragma mark QRMutableArrayKit

@interface NSMutableArray  <ObjectType> (QRMutableArrayKit)

/**
  向数组里添加一个新元素

 @param anObject 如果元素为 nil 那么不执行添加操作
 */
- (void)safe_addObject:(nonnull ObjectType)anObject;

/**
 在数组的指定 index 位置插入一个元素

 @param anObject 要插入到数组中的元素
 @param index 下标
 */
- (void)safe_insertObject:(nonnull ObjectType)anObject atIndex:(NSUInteger)index;

/**
 从数组中移除一个元素根据下标

 @param index 下标
 */
- (void)safe_removeObjectAtIndex:(NSUInteger)index;

/**
 根据下标替换数组中的某个元素

 @param index 下标
 @param anObject 新的元素
 */
- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(nonnull ObjectType)anObject;

/**
 移除数组中的第一个元素
 */
- (void)removeFirstObject;

/**
 Adds the objects contained in another given array at the index of the receiving
 array's content.
 
 @param objects An array of objects to add to the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 
 @param index The index in the array at which to insert objects. This value must
 not be greater than the count of elements in the array. Raises an
 NSRangeException if index is greater than the number of elements in the array.
 */
- (void)QR_insertObjects:(NSArray *_Nonnull)objects atIndex:(NSUInteger)index;

/**
 Reverse the index of object in this array.
 Example: Before @[ @1, @2, @3 ], After @[ @3, @2, @1 ].
 */
- (NSMutableArray *_Nonnull)QR_reverse;


/**
 *   过滤掉相同的元素
 *
 *   @return 返回一个数组
 */
- (NSMutableArray *_Nonnull)filterTheSameElement;


@end

#pragma mark QRDictionarayKit

@interface NSDictionary <__covariant KeyType, __covariant ObjectType> (QRDictionarayKit)


/**
 通过 key 取出字典中 key 对应的 value

 @param aKey  key
 @return  如果 key 对应元素为空 返回 nil
 */
- (nullable ObjectType)safe_ObjectForKey:(nonnull KeyType <NSCopying>)aKey;


/**
    如果值类型是一个sting类型 当它为空值时 将它替换成 @"" 空字符串
 */
- (nullable ObjectType)safe_stringObjectForKey:(NSString *_Nonnull)key;

/**
 如果数组为 nil 时 替换成 @[]
 */
- (nullable ObjectType)safe_arrayObjectForkey:(NSString *_Nonnull)key;


/**
 如果 dictionary 为 nil 替换成 @{}
 */
- (nullable ObjectType)safe_dictionaryObjectForkey:(NSString *_Nonnull)key;

/**
 如果 nsnumber 为 nil 时 替换成 NSNumber
 */
- (nullable ObjectType)safe_numberObjectForkey:(NSString *_Nonnull)key;

/**
  字典是否为空 没有元素
 */
@property (nonatomic,assign,readonly) BOOL isEmpty;

/**
 Returns a BOOL value tells if the dictionary has an object for key.
 
 @param key The key.
 */
- (BOOL)containsObjectForKey:(id _Nonnull)key;

/**
 array to jsonString
 */
- (NSString *_Nullable)jsonValue;


@end

#pragma mark QRMutableDictionaryKit

@interface NSMutableDictionary < KeyType,ObjectType> (QRMutableDictionaryKit)

/**
 从字典中根据 key 移除一个元素
 */
- (void)safe_removeObjectForKey:(_Nonnull KeyType <NSCopying>)aKey;

/**
 根据 key 添加一个新的元素到字典中

 @param anObject 新的元素
 @param aKey  key
 */
- (void)safe_setObject:(_Nonnull ObjectType)anObject forKey:(_Nonnull KeyType <NSCopying>)aKey;




@end

#pragma mark QRTimerBlock

@interface NSTimer (QRTimerBlock)

/**
 创建一个 timer 默认添加到当前的 runloop 中

 @param seconds  timer 多少秒后被触发
 @param block timer被触发后的回调方法
 @param repeats 是否重复执行 timer
 @return timer
 */
+ (NSTimer *_Nullable)QR_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^_Nullable)(NSTimer * _Nullable timer))block repeats:(BOOL)repeats;

/**
    创建一个新的 timer 需要自己手动添加到 runloop 中 并手动调用  [timer fire]
@param seconds  timer 多少秒后被触发
@param block timer被触发后的回调方法
@param repeats 是否重复执行 timer
@return timer
 */
+ (NSTimer *_Nullable)QR_timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^_Nullable)(NSTimer * _Nullable timer))block repeats:(BOOL)repeats;



@end

#pragma mark - NSData

@interface NSData (DataBase64)


/**
 将 NSData base64加密并生成加密后的字符串
 */
- (NSString *_Nullable)dataBase64Sting;

/**
 将base64解密成 NSData
 */
+ (NSData *_Nullable)QR_dataWithBase64EncodedString:(NSString *_Nullable)string;

/**
 将 NSData 类型转换成JSON类型
 */
- (id _Nullable)jsonValue;

/**
 将 NSData 转成 NSString 对象
 */
- (NSString *_Nullable) stringValue;

- (NSArray *_Nullable)arrayValue;

- (NSDictionary *_Nullable)dictionaryValue;

/**
 将  dictionaray  array 转成data another type is not allow
 */
+ (NSData *_Nullable)dataWithObject:(id _Nullable)anObject;


@end

#pragma mark -  NSNotificationCenter

typedef void(^QRNotificationBlock)(NSString *_Nullable name,id _Nullable object,NSDictionary * _Nullable userInfo);

@interface NSNotificationCenter (Notification)

+ (void) QR_postNotificationName:(NSString *_Nonnull)name;

+ (void) QR_postNotificationName:(NSString *_Nonnull)name
                          object:(id _Nullable)anObject;

+ (void) QR_postNotificationName:(NSString *_Nonnull)name
                          object:(id _Nullable)anObject
                        userInfo:(NSDictionary *_Nullable)aUserInfo;

+ (void)QR_addObserver:(id _Nullable )observer
                  name:(nullable NSNotificationName)aName
                object:(nullable id)anObject
    notifaicationBlock:(QRNotificationBlock _Nullable )block;


+ (void)QR_removeObserver:(id _Nullable )observer;


@end

