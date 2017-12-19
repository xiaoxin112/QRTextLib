//
//  NSObject+QRFoundationKit.m
//  QRKit
//
//  Created by xiaoxin on 2017/6/11.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import "NSObject+QRFoundationKit.h"
#import "NSString+Extension.h"

#import <objc/runtime.h>
static void *block_key;

#pragma mark - KVO

@interface QRObjectKVOTarget : NSObject

@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block;

@end

@implementation QRObjectKVOTarget

- (id)initWithBlock:(void (^)(__weak id, id, id))block {
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.block) return;
    
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) return;
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldVal == [NSNull null]) oldVal = nil;
    
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null]) newVal = nil;
    
    self.block(object, oldVal, newVal);
}

@end

#pragma mark - runtime

@implementation NSObject (QRFoundationKit)

- (void)setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}

- (id)getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

+ (NSString *)className {
    return NSStringFromClass(self);
}

- (NSString *)className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

+ (BOOL)object_empty:(id)obj {
    
    if (!obj) return YES;
    if (obj == [NSNull null]) return YES;
    
    return NO;
}


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
                                     id _Nonnull newVal))block {
    if (!keyPath || !block) return;
    QRObjectKVOTarget *target = [[QRObjectKVOTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self QR_allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    if (!arr) {
        arr = [NSMutableArray new];
        dic[keyPath] = arr;
    }
    [arr addObject:target];
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];

}

/**
 移除对属性的观察
 
 @param keyPath 属性的 keypath
 */
- (void)QR_removeObserverBlocksForKeyPath:(NSString *)keyPath {
    if (!keyPath) return;
    NSMutableDictionary *dic = [self QR_allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    
    [dic removeObjectForKey:keyPath];
}
/**
 移除所有属性观察的回调 block
 */

- (void)QR_removeObserverBlocks {
    NSMutableDictionary *dic = [self QR_allNSObjectObserverBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    
    [dic removeAllObjects];
}


- (NSMutableDictionary *)QR_allNSObjectObserverBlocks {
    NSMutableDictionary *targets = [self getAssociatedValueForKey:&block_key];
    if (!targets) {
        targets = [NSMutableDictionary new];
        [self setAssociateValue:targets withKey:&block_key];
    }
    return targets;
}

#pragma mark - performSelector

- (id)QR_performSelectorWithArgs:(SEL)aSelector withObjects:(NSArray*)objects {
   
    
    NSInvocation *invocation = [self QR_invocation:aSelector withObjects:objects];
    
    //6、调用NSinvocation对象
    [invocation invoke];
    
    NSMethodSignature*signature = [[self class] instanceMethodSignatureForSelector:aSelector];

    //7、获取返回值
    id res = nil;
    //判断当前方法是否有返回值
    
    if (signature.methodReturnLength!=0) {
        //getReturnValue获取返回值
        [invocation getReturnValue:&res];
    }
    return res;
}

- (void)QR_performSelectorWithArgs:(SEL)sel withObjects:(NSArray*)objects afterDelay:(NSTimeInterval)delay {
    
    NSInvocation *invocation = [self QR_invocation:sel withObjects:objects];
    [invocation performSelector:@selector(invoke) withObject:nil afterDelay:delay];
    
}

- (nullable id)QR_performSelectorWithArgsOnMainThread:(SEL _Nullable )sel
                                       withObjects:(NSArray*_Nullable)objects {
    return [self QR_performSelectorWithArgs:sel onThread:[NSThread mainThread] withObjects:objects];
}

- (nullable id)QR_performSelectorWithArgs:(SEL _Nullable )sel
                              onThread:(NSThread *_Nullable)thread withObjects:(NSArray*_Nullable)objects {
    NSInvocation *invocation = [self QR_invocation:sel withObjects:objects];
    [invocation performSelector:@selector(invoke) onThread:thread withObject:nil waitUntilDone:YES];
    return [self QR_returnObjectWithSelector:sel invocation:invocation];

}

- (NSInvocation *)QR_invocation:(SEL)aSelector withObjects:(NSArray*)objects {
    //1、创建签名对象
    NSMethodSignature*signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    
    //2、判断传入的方法是否存在
    if (signature==nil) {
        //传入的方法不存在 就抛异常
        NSString*info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(aSelector)];
        @throw [[NSException alloc] initWithName:@"方法没有" reason:info userInfo:nil];
        return nil;
    }
    
    
    //3、、创建NSInvocation对象
    NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
    //4、保存方法所属的对象
    invocation.target = self;
    invocation.selector = aSelector;
    
    
    //5、设置参数
    /*
     当前如果直接遍历参数数组来设置参数
     如果参数数组元素多余参数个数，那么就会报错
     */
    NSInteger arguments =signature.numberOfArguments-2;
    /*
     如果直接遍历参数的个数，会存在问题
     如果参数的个数大于了参数值的个数，那么数组会越界
     */
    /*
     谁少就遍历谁
     */
    NSUInteger objectsCount = objects.count;
    NSInteger count = MIN(arguments, objectsCount);
    for (int i = 0; i<count; i++) {
        NSObject*obj = objects[i];
        //处理参数是NULL类型的情况
        if ([obj isKindOfClass:[NSNull class]]) {
            obj = nil;
        }
        [invocation setArgument:&obj atIndex:i+2];
        
    }
    return invocation;
}

- (id)QR_returnObjectWithSelector:(SEL)sel invocation:(NSInvocation *)aInvocation {
    NSMethodSignature*signature = [[self class] instanceMethodSignatureForSelector:sel];
    
    //7、获取返回值
    id res = nil;
    //判断当前方法是否有返回值
    
    if (signature.methodReturnLength!=0) {
        //getReturnValue获取返回值
        [aInvocation getReturnValue:&res];
    }
    return res;
    
}

@end

#pragma mark - QRArrayKit

@implementation NSArray (QRArrayKit)

@dynamic isEmpty;

- (id)safe_ObjectAtIndex:(NSUInteger)index {
    
    if ([self isEmpty]) return nil;

    if(index > self.count - 1) return nil;
    
    return [self objectAtIndex:index];
  
}

- (id)randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}


- (BOOL)isEmpty {
    return self.count == 0;
}


/**
  array to jsonString
  */
- (NSString *_Nullable)jsonValue {
    
    NSData *jsonData = [NSData dataWithObject:self];
    if (!jsonData) return nil;
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}




@end

#pragma mark - NSMutableArray+QRMutableArrayKit

@implementation NSMutableArray (QRMutableArrayKit)


- (void)safe_addObject:(id)anObject {
    
    if (!anObject) return;
    [self addObject:anObject];
    
}

- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index {
    
    if (!anObject) return;
    if(index > self.count) {
        NSAssert(!(index > self.count), @"\n插入元素的 index 大于数组的 count 导致数组越界了\n");
        return;
    }
    [self insertObject:anObject atIndex:index];
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index {
    
    if (self.isEmpty) return;
    if (index > self.count-1) {
        NSAssert(!(self.count-1), @"\n将要被删除元素的 index 大于数组的 count 导致数组越界了\n");
        return;
    }
    
    [self removeObjectAtIndex:index];
    
}

- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    
    if (self.isEmpty) return;
    if (!anObject) return;
    
    if (index > self.count-1) {
        NSAssert(!(self.count-1), @"\n将要被替换元素的 index 大于数组的 count 导致数组越界了\n");
        return;
    }
    
    [self replaceObjectAtIndex:index withObject:anObject];
    
}

- (void)removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}


- (NSMutableArray *)QR_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
    return self;
}


- (void)QR_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
    
}

/**
 *   过滤掉相同的元素
 *
 *   @return 返回一个数组
 */
- (NSMutableArray *_Nonnull)filterTheSameElement {
    
    NSMutableSet *set       = [NSMutableSet setWithArray:self];
    NSMutableArray *array   = [[NSMutableArray alloc] initWithArray:set.allObjects];
    array                   = [array QR_reverse];
    
    return array;
}

@end

#pragma mark -  QRDictionarayKit

@implementation NSDictionary (QRDictionarayKit)

- (nullable id)safe_ObjectForKey:(id<NSCopying>)aKey {
    if (!aKey) return nil;
    return (([self objectForKey:aKey] == [NSNull null]) ? (nil) : ([self objectForKey:aKey]));
}

- (BOOL)isEmpty {
    return self.count == 0;
}

- (BOOL)containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

- (NSString *)jsonValue {
    NSData *jsonData = [NSData dataWithObject:self];
    if (!jsonData) return nil;
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

/**
 如果值类型是一个sting类型 当它为空值时 将它替换成 @"" 空字符串
 */
- (id)safe_stringObjectForKey:(NSString *_Nonnull)key {
    if (!key) return @"";
    NSString *string = [NSString stringByReplacingIfNull:[self objectForKey:key]];
    return string;
}

- (id)safe_arrayObjectForkey:(NSString *_Nonnull)key {
 
    id object = [self safe_ObjectForKey:key];
    BOOL null = [NSObject object_empty:object];
    if (null) return @[];
    else
        return (NSArray *)object;
}

- (id)safe_dictionaryObjectForkey:(NSString *_Nonnull)key {
    
    id object = [self safe_ObjectForKey:key];
    BOOL null = [NSObject object_empty:object];
    if (null)
        return @{};
    else
        return (NSDictionary *)object;
}

- (id)safe_numberObjectForkey:(NSString *_Nonnull)key {
    
    id object = [self safe_ObjectForKey:key];
    BOOL null = [NSObject object_empty:object];
    if (null)
        return [[NSNumber alloc] init];
    else
        return (NSNumber *)object;
 
}

@end

@implementation NSMutableDictionary (QRMutableDictionaryKit)

- (void)safe_removeObjectForKey:(id)aKey {
    
    if (self.isEmpty) return;
    if (!aKey) return;
    [self removeObjectForKey:aKey];
    
}

- (void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    if (!aKey) return;
    if (!anObject) {
        [self setObject:@"" forKey:aKey];
    } else {
        [self setObject:anObject forKey:aKey];
    }
    
}

@end

@implementation NSTimer (QRTimerBlock)

+ (void)_QR_ExecBlock:(NSTimer *_Nullable)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

/**
 创建一个 timer 默认添加到当前的 runloop 中
 @param seconds  timer 多少秒后被触发
 @param block timer被触发后的回调方法
 @param repeats 是否重复执行 timer
 @return timer
 */
+ (NSTimer *_Nullable)QR_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^_Nullable)(NSTimer * _Nullable timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_QR_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

/**
 创建一个新的 timer 需要自己手动添加到 runloop 中 否则 timer 无法执行
 @param seconds  timer 多少秒后被触发
 @param block timer被触发后的回调方法
 @param repeats 是否重复执行 timer
 @return timer
 */
+ (NSTimer *_Nullable)QR_timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^_Nullable)(NSTimer * _Nullable timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(_QR_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

@end

#pragma mark - NSData

@implementation NSData (DataBase64)

- (NSString *_Nullable)dataBase64Sting {
    
    const uint8_t* input = (const uint8_t*)[self bytes];
    NSUInteger length = [self length];
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    NSUInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    (uint8_t)table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    (uint8_t)table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? (uint8_t)table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? (uint8_t)table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
}

+ (NSData *)QR_dataWithBase64EncodedString:(NSString *)string
{
    if (![string length]) return nil;
    
    NSData *decoded = nil;
    
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
    {
        decoded = [[self alloc] initWithBase64EncodedString:[string stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9+/=]" withString:@""] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    else
        
#endif
        
    {
        decoded = [[self alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    
    return [decoded length]? decoded: nil;
}

/**
 将 NSData 类型转换成JSON类型
 */
- (id _Nullable)jsonValue {
    
    id object = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
    
    return object;
}

/**
 将 NSData 转成 NSString 对象
 */
- (NSString *_Nullable) stringValue {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSArray *_Nullable)arrayValue {
    id objct = [self jsonValue];
    if (objct && [objct isKindOfClass:[NSArray class]]) {
        return (NSArray *)objct;
    }
    return nil;
}

- (NSDictionary *_Nullable)dictionaryValue {
    id objct = [self jsonValue];
    if (objct && [objct isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)objct;
    }
    return nil;
}

/**
 将  dictionaray  array 转成data another type is not allow
 */
+ (NSData *_Nullable)dataWithObject:(id _Nullable)anObject {
    
    if (![NSJSONSerialization isValidJSONObject:anObject]) {
        return nil;
    }
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:anObject options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return nil;
    } else {
        return data;
    }
}

@end

#pragma mark -  NSNotificationCenter


@interface QRNotificationObserver : NSObject

@property (nonatomic,copy) QRNotificationBlock observerBlock;

@property (nonatomic,weak) id observer;

@property (nonatomic,copy) NSString *name;

- (instancetype)initObserver:(id _Nullable)observer callBack:(QRNotificationBlock)observerBlock;


@end

@implementation QRNotificationObserver

- (instancetype)initObserver:(id _Nullable)observer callBack:(QRNotificationBlock)observerBlock {
    if (self = [super init]) {
        self.observerBlock = observerBlock;
        self.observer      = observer;
    }
    return self;
}

- (void)invoke:(NSNotification *)noti {
    
    if (self.observerBlock) self.observerBlock(noti.name,noti.object, noti.userInfo);
    
}

- (void)dealloc {
    NSLog(@" dealloc");
}

@end

@implementation NSNotificationCenter (Notification)

+ (void) QR_postNotificationName:(NSString *_Nonnull)name {
    
    [self QR_postNotificationName:name object:nil userInfo:nil];
}

+ (void) QR_postNotificationName:(NSString *_Nonnull)name object:(id _Nullable)anObject {
    
    [self QR_postNotificationName:name object:anObject userInfo:nil];
}

+ (void) QR_postNotificationName:(NSString *_Nonnull)name object:(id _Nullable)anObject userInfo:(NSDictionary *_Nullable)aUserInfo {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:anObject userInfo:aUserInfo];
    
}

+ (void)QR_addObserver:(id _Nullable )observer
                  name:(nullable NSNotificationName)aName
                object:(nullable id)anObject
    notifaicationBlock:(QRNotificationBlock _Nullable )block {

    QRNotificationObserver *target = [[QRNotificationObserver alloc] initObserver:observer callBack:block];
    
    [[NSNotificationCenter defaultCenter] addObserver:target selector:@selector(invoke:) name:aName object:anObject];
    
    [[[NSNotificationCenter defaultCenter] QR_allNotificationObserverBlocks] addObject:target];
    
}

+ (void)QR_removeObserver:(id _Nullable )observer {
    
    if (!observer) return;
    
    NSMutableSet *set = [[NSNotificationCenter defaultCenter] QR_allNotificationObserverBlocks];
    
    for (QRNotificationObserver *target in set.allObjects) {
        if ([target.observer isEqual:observer]) {
            [set removeObject:target];
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
    
}


- (void)QR_removeObserverBlocks {
    [[self QR_allNSObjectObserverBlocks] removeAllObjects];
}

- (NSMutableSet *)QR_allNotificationObserverBlocks {

    NSMutableSet *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableSet set];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;

}

@end
