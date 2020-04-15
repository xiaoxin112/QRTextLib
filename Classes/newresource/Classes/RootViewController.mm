/****************************************************************************
 Copyright (c) 2013      cocos2d-x.org
 Copyright (c) 2013-2016 Chukong Technologies Inc.
 Copyright (c) 2017-2018 Xiamen Yaji Software Co., Ltd.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
****************************************************************************/

#import "RootViewController.h"
#import "cocos2d.h"

#include "platform/CCApplication.h"
#include "platform/ios/CCEAGLView-ios.h"
#include "cocos/scripting/js-bindings/jswrapper/SeApi.h"

@implementation RootViewController

/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
// Custom initialization
}
return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    // Set EAGLView as view of RootViewController
    self.view = (__bridge CCEAGLView *)cocos2d::Application::getInstance()->getView();
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIButton* button8 = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 50, 30)];
    [button8 setBackgroundColor:[UIColor yellowColor]];
    [button8 setTitle:@"加载E" forState:UIControlStateNormal];
    [button8 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button8 setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [button8 addTarget:self action:@selector(loadEmoji) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button8];
    
    UIButton* button3 = [[UIButton alloc] initWithFrame:CGRectMake(80, 40, 50, 30)];
    [button3 setBackgroundColor:[UIColor yellowColor]];
    [button3 setTitle:@"清除E" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [button3 addTarget:self action:@selector(clearEmoji) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    
    UIButton* button2 = [[UIButton alloc] initWithFrame:CGRectMake(140, 40, 50, 30)];
    [button2 setBackgroundColor:[UIColor yellowColor]];
    [button2 setTitle:@"设置E" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(setEmojiPosition) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton* buttonE = [[UIButton alloc] initWithFrame:CGRectMake(260, 40, 50, 30)];
    [buttonE setBackgroundColor:[UIColor yellowColor]];
    [buttonE setTitle:@"隐藏E" forState:UIControlStateNormal];
    [buttonE setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonE setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [buttonE addTarget:self action:@selector(setEmojiVisible) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonE];
    
    
    UIButton* button4 = [[UIButton alloc] initWithFrame:CGRectMake(200, 40, 50, 30)];
    [button4 setBackgroundColor:[UIColor yellowColor]];
    [button4 setTitle:@"思考" forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [button4 addTarget:self action:@selector(emojiThinking) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    
    //-----------------蛮牛空间-------------------------------------------------------------------------------------------------
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 50, 30)];
    [button setBackgroundColor:[UIColor yellowColor]];
    [button setTitle:@"加载Z" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(loadZone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton* button1 = [[UIButton alloc] initWithFrame:CGRectMake(80, 100, 50, 30)];
    [button1 setBackgroundColor:[UIColor yellowColor]];
    [button1 setTitle:@"清除Z" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [button1 addTarget:self action:@selector(clearZone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    UIButton* button6 = [[UIButton alloc] initWithFrame:CGRectMake(140, 100, 50, 30)];
    [button6 setBackgroundColor:[UIColor yellowColor]];
    [button6 setTitle:@"设置Z" forState:UIControlStateNormal];
    [button6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button6 setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [button6 addTarget:self action:@selector(setZonePosition) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button6];
    
    UIButton* buttonZ = [[UIButton alloc] initWithFrame:CGRectMake(260, 100, 50, 30)];
    [buttonZ setBackgroundColor:[UIColor yellowColor]];
    [buttonZ setTitle:@"隐藏Z" forState:UIControlStateNormal];
    [buttonZ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonZ setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [buttonZ addTarget:self action:@selector(setZoneVisible) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonZ];
    
    UIButton* button5 = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 50, 30)];
    [button5 setBackgroundColor:[UIColor yellowColor]];
    [button5 setTitle:@"点头" forState:UIControlStateNormal];
    [button5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button5 setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [button5 addTarget:self action:@selector(mNiuNodding) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark 回调
+ (void)emojiAniCallback:(NSString*)name{
    if ([name isEqual: @"emojiThinking"]) {
        NSLog(@"this is 思考 callback");
    }
}

+ (void)zoneAniCallback:(NSString*)name{
    if ([name isEqual: @"diantou"]) {
        NSLog(@"this is 点头 callback");
    }
}

#pragma mark -
#pragma mark 蛮牛表情
//加载指定对象
- (void)loadEmoji{
    NSString* codeString = @"loadEmojiData()";
    se::ScriptEngine::getInstance()->evalString([codeString UTF8String], -1, nullptr, "loadEmojiData");
}

//设置坐标
- (void)setEmojiPosition{
    NSString* codeString = [NSString stringWithFormat:@"setEmojiPosition('%d', '%d');",0, -400];
    se::ScriptEngine::getInstance()->evalString([codeString UTF8String], -1, nullptr, "setEmojiPosition");
}

//清除动画并加载指定对象
- (void)clearEmoji{
    NSString* codeString = @"clearEmoji()";
    se::ScriptEngine::getInstance()->evalString([codeString UTF8String], -1, nullptr, "clearEmoji");
}

//隐藏
- (void)setEmojiVisible{
    NSString* codeString = [NSString stringWithFormat:@"setEmojiVisible('%d');", 0];
    se::ScriptEngine::getInstance()->evalString([codeString UTF8String], -1, nullptr, "setEmojiVisible");
}

//思考
- (void)emojiThinking{
    NSString* codeString = [NSString stringWithFormat:@"setEmojiThinkAction('%d');", 0];
    se::ScriptEngine::getInstance()->evalString([codeString UTF8String], -1, nullptr, "setEmojiAction");
}

#pragma mark -
#pragma mark 蛮牛空间
//加载指定对象
- (void)loadZone{
    NSString* codeString = @"loadZoneNiuData()";
    se::ScriptEngine::getInstance()->evalString([codeString UTF8String]);
}

//设置坐标
- (void)setZonePosition{
    NSString* codeString = [NSString stringWithFormat:@"setZonePosition('%d', '%d');",0, 0];
    se::ScriptEngine::getInstance()->evalString([codeString UTF8String], -1, nullptr, "setZonePosition");
}

//清除动画并加载指定对象
- (void)clearZone{
    NSString* codeString = @"clearZoneNiu()";
    se::ScriptEngine::getInstance()->evalString([codeString UTF8String], -1, nullptr, "clearZoneNiu");
}

//隐藏
- (void)setZoneVisible{
    NSString* codeString = [NSString stringWithFormat:@"setZoneVisible('%d');", 0];
    se::ScriptEngine::getInstance()->evalString([codeString UTF8String], -1, nullptr, "setZoneVisible");
}

//点头
- (void)mNiuNodding{
    NSString* codeString = [NSString stringWithFormat:@"setDiantouAction('%d');", 1];
    se::ScriptEngine::getInstance()->evalString([codeString UTF8String], -1, nullptr, "setMNiuZoneAction");
}


#pragma mark -


// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
#ifdef __IPHONE_6_0
- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
#endif

- (BOOL) shouldAutorotate {
    return YES;
}

//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden {
    return YES;
}

// Controls the application's preferred home indicator auto-hiding when this view controller is shown.
- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}


@end
