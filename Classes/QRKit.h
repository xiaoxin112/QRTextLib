//
//  QRKit.h
//  QRKit
//
//  Created by xiaoxin on 2017/4/26.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#ifndef QRKit_h
#define QRKit_h


#import <UIKit/UIKit.h>
#import <pthread/pthread.h>
#import <dispatch/dispatch.h>

#endif /* QRKit_h */



#pragma makr -  GCD相关

/**
 Whether in main queue/thread.
 */
static inline bool dispatch_is_main_queue() {
    return pthread_main_np() != 0;
}

/**
 Submits a block for asynchronous execution on a main queue and returns immediately.
 */
static inline void dispatch_async_on_main_queue(void (^ _Nullable block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

static inline void dispatch_async_on_global_queue(void (^ _Nullable block)()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

static inline NSThread* _Nullable dispatch_currentThread() {
    return [NSThread currentThread];
}

/**
 Returns a dispatch_time delay from now.
 */
static inline dispatch_time_t dispatch_time_delay(NSTimeInterval second) {
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

static  inline NSString * _Nonnull appVersion() {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

static inline NSString * _Nonnull appBundleIdentifier() {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

static inline NSString * _Nonnull appBundleName() {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}
static inline NSString *_Nullable app_display_name() {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}


static inline NSString * _Nonnull documentsPath() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

static inline NSString *_Nonnull cachesPath() {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

static inline NSString *_Nonnull libraryPath() {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}


static inline bool debugMode() {
#ifdef DEBUG
    return true;
#else
    return false;
#endif
}



/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef QR_weakify
#if DEBUG
#if __has_feature(objc_arc)
#define QR_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define QR_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define QR_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define QR_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef QR_strongify
#if DEBUG
#if __has_feature(objc_arc)
#define QR_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define QR_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define QR_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define QR_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif



#pragma mark ---------------------------------LOG--------------------------------------------------
//打印Log
#ifdef DEBUG

#define DLog( s, ... )                          NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )

#endif


#define KScreenWidth    [UIScreen mainScreen].bounds.size.width

#define KScreenHeight   [UIScreen mainScreen].bounds.size.height


#define KScreenSize   [UIScreen mainScreen].bounds.size

