//
//  UIView+QRUIViewExtension.h
//  QRKit
//
//  Created by xiaoxin on 2017/6/12.
//  Copyright © 2017年 xiaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (QR_Frame)

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;

/**
 Remove all subviews.
 
 @warning Never call this method inside your view's drawRect: method.
 */
- (void)removeAllSubviews;

/**
 Returns the view's view controller (may be nil).
 */
@property (nullable, nonatomic, readonly) UIViewController *viewController;


@end


@interface UIView (QR_Target)


/**
 从 nib 中加载一个 view

 @return 如果存在返回这个 view 否则为 nil
 */
+ (instancetype _Nullable )viewFromBundle;

/**
 *  点击事件
 */
- (void)addTarget:(nonnull id)target action:(nonnull SEL)action;

/**
 *  点击某个点是否在一个 view 上
 */
- (BOOL)pointInView:(CGPoint)locationPoint;

@end


@interface UILabel (QR_TextSize)


/**
 计算 label 文字的 size
 */
-(CGSize)getTextSizeWithFont:(UIFont *_Nullable)font restrictWidth:(float)width;


// 计算普通的 label
+ (CGSize)getLabelHeightWithContent:(id _Nullable)content Width:(CGFloat)width font:(UIFont *_Nullable)font;
/**
 *  计算指定行或者多行 Label 的高度
 */
+ (CGSize)getLabelHeightWithContent:(id _Nullable)content Width:(CGFloat)width font:(UIFont *_Nullable)font numberOfLines:(NSInteger)numberOfLines;



@end


@interface UIControl (QR_Event)


- (void)removeAllTargets;


/**
 Adds a block for a particular event (or events) to an internal dispatch table.
 It will cause a strong reference to @a block.
 
 @param block          The block which is invoked then the action message is
 sent  (cannot be nil). The block is retained.
 
 @param controlEvents  A bitmaQR specifying the control events for which the
 action message is sent.
 */
- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^_Nullable)(id _Nullable sender))block;

/**
 Adds or replaces a block for a particular event (or events) to an internal
 dispatch table. It will cause a strong reference to @a block.
 
 @param block          The block which is invoked then the action message is
 sent (cannot be nil). The block is retained.
 
 @param controlEvents  A bitmaQR specifying the control events for which the
 action message is sent.
 */
- (void)setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^_Nullable)(id _Nullable sender))block;

/**
 Removes all blocks for a particular event (or events) from an internal
 dispatch table.
 
 @param controlEvents  A bitmaQR specifying the control events for which the
 action message is sent.
 */
- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;


@end



@interface UIButton (Extension)


/// 获取 button 所在 cell 的 indexPath
- (NSIndexPath *_Nullable) indexPathAt:(UITableView *_Nullable)tableView forEvent:(id _Nullable )sender;



@end

@interface UIScrollView (Extension)

/**
 Scroll content to top with animation.
 */
- (void)scrollToTop;

/**
 Scroll content to bottom with animation.
 */
- (void)scrollToBottom;

/**
 Scroll content to left with animation.
 */
- (void)scrollToLeft;

/**
 Scroll content to right with animation.
 */
- (void)scrollToRight;

/**
 Scroll content to top.
 
 @param animated  Use animation.
 */
- (void)scrollToTopAnimated:(BOOL)animated;

/**
 Scroll content to bottom.
 
 @param animated  Use animation.
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

/**
 Scroll content to left.
 
 @param animated  Use animation.
 */
- (void)scrollToLeftAnimated:(BOOL)animated;

/**
 Scroll content to right.
 
 @param animated  Use animation.
 */
- (void)scrollToRightAnimated:(BOOL)animated;


@end

@interface UITableView (QR_Add)



/**
 执行更新操作 在block进行insert update delete操作
 */
- (void)updateWithBlock:(void (^_Nullable)(UITableView * _Nullable tableView))block;


/**
 滚动到指定 section 的指定 row 并设置动画类型
 */
- (void)scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;


/**
 插入一个在 indexPath 位置
 */
- (void)insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

 
/**
 reload table at row in section and  set animaiton type
 */
- (void)reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;


/**
 delete row in section with animation
 */
- (void)deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;


/**
 insert cell at indexPath
 */
- (void)insertRowAtIndexPath:(NSIndexPath *_Nullable)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
  reload cell at indexPath with animaiton
 */
- (void)reloadRowAtIndexPath:(NSIndexPath *_Nullable)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
   delete cell at indexPath with animation
 */
- (void)deleteRowAtIndexPath:(NSIndexPath *_Nullable)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
  insert section in table with animation
 */
- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 delete section in table with animation
 */
- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 reload section in table with animation

 */
- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Unselect all rows in tableView.
  */
- (void)clearSelectedRowsAnimated:(BOOL)animated;


@end


@interface UINavigationController (POP)

- (void) popViewControllerAnimated:(BOOL)animated delay:(CGFloat)duration;


- (void) popToViewController:(UIViewController *_Nullable)viewController animated:(BOOL)animated delay:(NSTimeInterval)duration;

- (void)popToRootViewControllerAnimated:(BOOL)animated delay:(NSTimeInterval)duration;

@end
