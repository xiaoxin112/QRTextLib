
#import "QRGiFHUD.h"
#import <ImageIO/ImageIO.h>
#import "QRGifConfiguration.h"

//#define FadeDuration    0.3
//#define GifSpeed        0.3

#define APPWindow  [[UIApplication sharedApplication].delegate window]

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif

#pragma mark - UIImage Animated GIF

@implementation UIImage (animatedGIF)

static int delayCentisecondsForImageAtIndex(CGImageSourceRef const source, size_t const i) {
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
    if (properties) {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        if (gifProperties) {
            NSNumber *number = fromCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
            if (number == NULL || [number doubleValue] == 0) {
                number = fromCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            }
            if ([number doubleValue] > 0) {
                delayCentiseconds = (int)lrint([number doubleValue] * 100);
            }
        }
        CFRelease(properties);
    }
    return delayCentiseconds;
}

static void createImagesAndDelays(CGImageSourceRef source, size_t count, CGImageRef imagesOut[count], int delayCentisecondsOut[count]) {
    for (size_t i = 0; i < count; ++i) {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = delayCentisecondsForImageAtIndex(source, i);
    }
}

static int sum(size_t const count, int const *const values) {
    int theSum = 0;
    for (size_t i = 0; i < count; ++i) {
        theSum += values[i];
    }
    return theSum;
}

static int pairGCD(int a, int b) {
    if (a < b)
        return pairGCD(b, a);
    while (true) {
        int const r = a % b;
        if (r == 0)
            return b;
        a = b;
        b = r;
    }
}

static int vectorGCD(size_t const count, int const *const values) {
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i) {
        gcd = pairGCD(values[i], gcd);
    }
    return gcd;
}

static NSArray *frameArray(size_t const count, CGImageRef const images[count], int const delayCentiseconds[count], int const totalDurationCentiseconds) {
    int const gcd = vectorGCD(count, delayCentiseconds);
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        UIImage *const frame = [UIImage imageWithCGImage:images[i]];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
            frames[f++] = frame;
        }
    }
    return [NSArray arrayWithObjects:frames count:frameCount];
}

static void releaseImages(size_t const count, CGImageRef const images[count]) {
    for (size_t i = 0; i < count; ++i) {
        CGImageRelease(images[i]);
    }
}

static UIImage *animatedImageWithAnimatedGIFImageSource(CGImageSourceRef const source) {
    size_t const count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delayCentiseconds[count]; // in centiseconds
    createImagesAndDelays(source, count, images, delayCentiseconds);
    int const totalDurationCentiseconds = sum(count, delayCentiseconds);
    NSArray *const frames = frameArray(count, images, delayCentiseconds, totalDurationCentiseconds);
    UIImage *const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    releaseImages(count, images);
    return animation;
}

static UIImage *animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceRef CF_RELEASES_ARGUMENT source) {
    if (source) {
        UIImage *const image = animatedImageWithAnimatedGIFImageSource(source);
        CFRelease(source);
        return image;
    } else {
        return nil;
    }
}

+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)data {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithData(toCF data, NULL));
}

+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)url {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithURL(toCF url, NULL));
}

@end



#pragma mark - GiFHUD Private

@interface QRGiFHUD ()
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL shown;

@end



#pragma mark - GiFHUD Implementation

@implementation QRGiFHUD


#pragma mark Lifecycle

static QRGiFHUD *_instance;

+ (instancetype)shareInstacne {
    if (!_instance){
        _instance = [[QRGiFHUD alloc] init];
        QRGifConfiguration *config = [[QRGifConfiguration alloc] initWithImageName:@"Lodging.gif" gifSpeed:0.3f fadeDuration:0.3f gifViewSize:CGSizeMake(90.0f, 90.0f)];
        [self setupGifConfig:config];
    }
    return _instance;
}



+ (void)setupGifConfig:(QRGifConfiguration *)config {

    QRGiFHUD *hud               = [QRGiFHUD shareInstacne];
    hud.gifConfig               = config;
    
    [QRGiFHUD setGifWithImageName:config.imageName];

}

- (void)setGifConfig:(QRGifConfiguration *)gifConfig {
    _gifConfig          = gifConfig;
    
    self.frame          = CGRectMake(0.0f, 0.0f, gifConfig.gifViewSize.width, gifConfig.gifViewSize.height);
    [self setAlpha:1];
    [self setCenter:APPWindow.center];
    [self setClipsToBounds:NO];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:0] CGColor]];
    [self.layer setCornerRadius:10];
    [self.layer setMasksToBounds:YES];
    self.imageView.frame = CGRectInset(self.bounds, 25.0f, 25.0f);
    
    [APPWindow addSubview:self];
    
}

- (instancetype)init {
    
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)]) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 25.0f, 25.0f)];
        [self addSubview:self.imageView];

    }
    return self;
}



#pragma mark HUD

+ (void)showWithOverlay {
    if([[self shareInstacne] shown]){
        [self dismiss];
    }
    [self dismiss:^{
        [APPWindow addSubview:[[self shareInstacne] covering]];
        [self show];
    }];
}

+ (void)show {
    if([[self shareInstacne] shown]){
        [self dismiss];
        
    }
    [self dismiss:^{
        [APPWindow bringSubviewToFront:[self shareInstacne]];
        [[self shareInstacne] setShown:YES];
        [[self shareInstacne] fadeIn];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:10.0f];
    }];
}

+ (void)dismiss {
    [[[self shareInstacne] covering] removeFromSuperview];
    [[self shareInstacne] fadeOut];
}

+ (void)dismiss:(void(^)(void))complated {
    if (![[self shareInstacne] shown])
        return complated ();
    
    [[self shareInstacne] fadeOutComplate:^{
        [[[self shareInstacne] covering] removeFromSuperview];
        complated ();
    }];
}

#pragma mark Effects

- (void)fadeIn {
    [self.imageView startAnimating];
    [UIView animateWithDuration:self.gifConfig.fadeDuration animations:^{
        [self setAlpha:1];
    }];
}

- (void)fadeOut {
    [UIView animateWithDuration:self.gifConfig.fadeDuration animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setShown:NO];
        [self.imageView stopAnimating];
    }];
}

- (void)fadeOutComplate:(void(^)(void))complated {
    [UIView animateWithDuration:self.gifConfig.fadeDuration animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setShown:NO];
        [self.imageView stopAnimating];
        complated ();
    }];
}

- (UIView *)covering {
    
    if (!self.overlayView) {
        self.overlayView = [[UIView alloc] initWithFrame:APPWindow.frame];
        [self.overlayView setBackgroundColor:[UIColor blackColor]];
        [self.overlayView setAlpha:0];
        [UIView animateWithDuration:self.gifConfig.fadeDuration animations:^{
            [self.overlayView setAlpha:0.1];
        }];
    }
    return self.overlayView;
}

#pragma mark Gif

+ (void)setGifWithImages:(NSArray *)images {
    [[[self shareInstacne] imageView] setAnimationImages:images];
    [[[self shareInstacne] imageView] setAnimationDuration:_instance.gifConfig.gifSpeed];
}

+ (void)setGifWithImageName:(NSString *_Nullable)imageName {
    [[[self shareInstacne] imageView] stopAnimating];
    [[[self shareInstacne] imageView] setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:imageName withExtension:nil]]];
}

+ (void)setGifWithURL:(NSURL *)gifUrl {
    [[[self shareInstacne] imageView] stopAnimating];
    [[[self shareInstacne] imageView] setImage:[UIImage animatedImageWithAnimatedGIFURL:gifUrl]];
}

@end
