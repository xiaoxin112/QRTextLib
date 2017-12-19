//
//  UIView+QRUIViewExtension.m
//  QRKit
//
//  Created by xiaoxin on 2017/6/12.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import "UIView+QRUIViewExtension.h"
#import "NSString+Extension.h"
#import <objc/runtime.h>
#import "UIImage+QR_Extension.h"


static const void *block_key;

@implementation UIView (QR_Frame)
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (void)removeAllSubviews {
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end


@implementation UIView (QR_Target)


/**
 从 nib 中加载一个 view
 
 @return 如果存在返回这个 view 否则为 nil
 */
+ (instancetype _Nullable )viewFromBundle {
    
    NSString *className = NSStringFromClass([self class]);
    id object = [[[NSBundle mainBundle]loadNibNamed:className owner:nil options:nil]lastObject];
    if ([object isKindOfClass:[self class]]) {
        return object;
    }
    return  nil;
    
}
/**
 *  点击事件
 */
- (void)addTarget:(nonnull id)target action:(nonnull SEL)action {
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
    
}
/**
 *  点击某个点是否在一个 view 上
 */
- (BOOL)pointInView:(CGPoint)locationPoint {
    CGFloat top         = self.top;
    CGFloat left        = self.left;
    CGFloat bottom      = self.bottom;
    CGFloat right       = self.right;
    if (locationPoint.x>=left && locationPoint.x<= right && locationPoint.y >= top && locationPoint.y <= bottom) {
        return YES;
    }
    return NO;
}


@end


@implementation UILabel (QR_TextSize)

/**
 计算 label 文字的 size
 */
-(CGSize)getTextSizeWithFont:(UIFont *_Nullable)font restrictWidth:(float)width {
    return [self.text getTextSizeWithFont:font.pointSize restrictWidth:width];
}

+ (CGSize)getLabelHeightWithContent:(id _Nullable)content Width:(CGFloat)width font:(UIFont *_Nullable)font {
    return [self getLabelHeightWithContent:content Width:width font:font numberOfLines:0];
}

/**
 *  计算指定行或者多行 Label 的高度
 */
+ (CGSize)getLabelHeightWithContent:(id _Nullable)content Width:(CGFloat)width font:(UIFont *_Nullable)font numberOfLines:(NSInteger)numberOfLines {
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 10.0f)];
    if ([content isKindOfClass:[NSString class]]) {
        label.text = content;
    }else if ([content isKindOfClass:[NSAttributedString class]]){
        label.attributedText = content;
    }
    if (font) {
        label.font  = font;
    }
    label.numberOfLines = numberOfLines;
    [label sizeToFit];
    CGRect labelFrame = label.frame;
    return CGSizeMake(labelFrame.size.width, labelFrame.size.height);
    
}

@end


@interface QRControlEventTarget : NSObject

@property (nonatomic,copy,nullable) void (^block)(id sender);
@property (nonatomic,assign) UIControlEvents events;

- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events;
- (void)invoke:(id)sender;

@end

@implementation QRControlEventTarget

- (instancetype)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events
{
    self = [super init];
    if (self) {
        self.block = block;
        self.events = events;
    }
    return self;
}

- (void)invoke:(id)sender {
    if (self.block) self.block(sender);
}

@end


@implementation UIControl (QR_Event)

- (void)removeAllTargets {
    
    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
    }];
    [[self QR_allUIControlBlockTargets] removeAllObjects];
}

- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^_Nullable)(id _Nullable sender))block {
    
    if (!controlEvents) return;
    
    QRControlEventTarget *target = [[QRControlEventTarget alloc] initWithBlock:block events:controlEvents];
    [self addTarget:self action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self QR_allUIControlBlockTargets];
    [targets addObject:target];
}


- (void)setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^_Nullable)(id _Nullable sender))block {
    
    if (!controlEvents) return;
    [self removeAllBlocksForControlEvents:UIControlEventAllEvents];
    [self addBlockForControlEvents:controlEvents block:block];
    
}

- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents {
    
    
    NSMutableArray *targets = [self QR_allUIControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    for (QRControlEventTarget *target in targets) {
        if (target.events & controlEvents) {
            UIControlEvents newEvent = target.events & (~controlEvents);
            if (newEvent) {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                target.events = newEvent;
                [self addTarget:target action:@selector(invoke:) forControlEvents:target.events];
            } else {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                [removes addObject:target];
            }
        }
    }
    [targets removeObjectsInArray:removes];

    
}


- (NSMutableArray *)QR_allUIControlBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}


@end


@implementation UIButton (Extension)

/**
 给按钮设置不同状态下的颜色
 */
- (void) setBackgroundColor:(UIColor *_Nullable)backgroundColor forState:(UIControlState)state {
    
    if (!backgroundColor) return;
    
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:state];
}

/// 获取 button 所在 cell 的 indexPath
- (NSIndexPath *_Nullable) indexPathAt:(UITableView *)tableView forEvent:(id)sender {
    
    NSSet *set = [(UIEvent *)sender allTouches];
    
    for (UITouch *touch in set) {
        CGPoint pt = [touch locationInView:tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:pt];
        if (indexPath) {
            return indexPath;
        }
    }
    
    return nil;
    
}


@end

@implementation UIScrollView (Extension)

- (void)scrollToTop {
    [self scrollToTopAnimated:YES];
}

- (void)scrollToBottom {
    [self scrollToBottomAnimated:YES];
}

- (void)scrollToLeft {
    [self scrollToLeftAnimated:YES];
}

- (void)scrollToRight {
    [self scrollToRightAnimated:YES];
}

- (void)scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end

@implementation UITableView (QR_Add)

- (void)updateWithBlock:(void (^)(UITableView *tableView))block {
    [self beginUpdates];
    block(self);
    [self endUpdates];
}

- (void)scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *toInsert = [NSIndexPath indexPathForRow:row inSection:section];
    [self insertRowAtIndexPath:toInsert withRowAnimation:animation];
}

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *toReload = [NSIndexPath indexPathForRow:row inSection:section];
    [self reloadRowAtIndexPath:toReload withRowAnimation:animation];
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *toDelete = [NSIndexPath indexPathForRow:row inSection:section];
    [self deleteRowAtIndexPath:toDelete withRowAnimation:animation];
}

- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self insertSections:sections withRowAnimation:animation];
}

- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self deleteSections:sections withRowAnimation:animation];
}

- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [self reloadSections:indexSet withRowAnimation:animation];
}

- (void)clearSelectedRowsAnimated:(BOOL)animated {
    NSArray *indexs = [self indexPathsForSelectedRows];
    [indexs enumerateObjectsUsingBlock:^(NSIndexPath* path, NSUInteger idx, BOOL *stop) {
        [self deselectRowAtIndexPath:path animated:animated];
    }];
}


@end


@implementation UINavigationController (POP)


- (void) popViewControllerAnimated:(BOOL)animated delay:(CGFloat)duration {
    
    [self performSelector:@selector(popViewControllerAnimated:) withObject:@(animated) afterDelay:duration];
    
}

- (void) popToViewController:(UIViewController *)viewController animated:(BOOL)animated delay:(NSTimeInterval)duration {
    
     [self performSelector:@selector(popToViewController:animated:) withObject:nil afterDelay:duration];
    
}


- (void)popToRootViewControllerAnimated:(BOOL)animated delay:(NSTimeInterval)duration {
    [self performSelector:@selector(popToRootViewControllerAnimated:) withObject:@(animated) afterDelay:duration];
}

- (NSInteger)indexOfChildViewController:(UIViewController *_Nullable)viewController {
    
    if ([self.childViewControllers containsObject:viewController]) {
        return [self.childViewControllers indexOfObject:viewController];
    }
    return NSNotFound;
}

- (void) popToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (index>=self.childViewControllers.count||index<0) {
        return;
    }
    UIViewController *vc = self.childViewControllers[index];
    [self popToViewController:vc animated:animated];
    
}
@end
