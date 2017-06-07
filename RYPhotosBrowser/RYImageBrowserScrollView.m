//
//  RYImageBrowserScrollView.m
//  RYImageBrowser
//
//  Created by RongqingWang on 16/11/4.
//  Copyright © 2016年 RyukieSama. All rights reserved.
//

#import "RYImageBrowserScrollView.h"
#import "RYImageBrowserPageController.h"

@interface RYImageBrowserScrollView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isAlertShowed;
@property (nonatomic, assign) CGFloat maximumDoubleTapZoomScale;

@end

@implementation RYImageBrowserScrollView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self setUpUI];
        [self addGestureRecognizers];
    }
    return self;
}

- (void)setUpUI {
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [UIImageView new];
    imageView.isAccessibilityElement = YES;
    imageView.accessibilityTraits = UIAccessibilityTraitImage;
    self.imageView = imageView;
    [self addSubview:self.imageView];
}

#pragma mark - Gesture recognizers
- (void)addGestureRecognizers {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapping:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapping:)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageWithLongPress)];
    
    [doubleTap setNumberOfTapsRequired:2.0];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [longPress setMinimumPressDuration:0.5];
    
    [singleTap setDelegate:self];
    [doubleTap setDelegate:self];
    [longPress setDelegate:self];
    
    [self addGestureRecognizer:singleTap];
    [self addGestureRecognizer:doubleTap];
    [self addGestureRecognizer:longPress];
}

#pragma mark - Gesture recognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

#pragma mark - Zoom with gesture recognizer
- (void)zoomWithGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self];
    
    //保证 plus上的缩放效果一致
    touchPoint.x = touchPoint.x * [UIScreen mainScreen].scale;
    touchPoint.y = touchPoint.y * [UIScreen mainScreen].scale;
    
    // 取消当前所有target为self.imageview的操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self.imageView];
    
    // Zoom
    if (self.zoomScale == self.maximumZoomScale) {
        //缩小
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        //放大
//        CGSize targetSize = CGSizeMake(self.frame.size.width / self.maximumDoubleTapZoomScale, self.frame.size.height / self.maximumDoubleTapZoomScale);
//        CGPoint targetPoint = CGPointMake(touchPoint.x - targetSize.width / 2, touchPoint.y - targetSize.height / 2);
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

#pragma mark - Handle tappings
- (void)handleTapping:(UITapGestureRecognizer *)recognizer {
    if (recognizer.numberOfTapsRequired == 2) {
        [self zoomWithGestureRecognizer:recognizer];
    } else if(recognizer.numberOfTapsRequired == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRYImageBrowserOneClick object:self userInfo:nil];
    }
}

- (void)saveImageWithLongPress {
    __weak typeof(self) weakSelf = self;
    if (self.isAlertShowed == YES) {
        return;
    }
    self.isAlertShowed = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存图片到系统相册?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *acCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.isAlertShowed = NO;
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    UIAlertAction *acDone = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.isAlertShowed = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            UIImageWriteToSavedPhotosAlbum(weakSelf.imageView.image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
    [alert addAction:acCancle];
    [alert addAction:acDone];
    
    [self.vc presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isAlertShowed = NO;
        if (!error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *acCancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:^{
                }];
            }];
            [alert addAction:acCancle];
            [self.vc presentViewController:alert animated:YES completion:^{
                
            }];
        }  else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存失败!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *acCancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:^{
                }];
            }];
            [alert addAction:acCancle];
            [self.vc presentViewController:alert animated:YES completion:^{
                
            }];
        }
    });
}

#pragma mark - Scroll view zoom delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - set
- (void)setImage:(UIImage *)image {
    if (image) {
        // Reset
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        
        self.contentSize = CGSizeMake(0, 0);
        
        self.imageView.image = image;
        
        // 设置size
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = image.size;
        
        self.imageView.frame = photoImageViewFrame;
        self.contentSize = photoImageViewFrame.size;
        
        // 缩放到最小
        [self setMaxMinZoomScalesForCurrentBounds];
        
        [self setNeedsLayout];
    }
}

#pragma mark - zoom
- (void)setMaxMinZoomScalesForCurrentBounds {
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    if (self.imageView.image == nil) return;
    
    // Sizes
    CGSize boundsSize = self.bounds.size;
    boundsSize.width -= 0.1;
    boundsSize.height -= 0.1;
    
    CGSize imageSize = self.imageView.frame.size;
    
    // 计算最小比例
    CGFloat xScale = boundsSize.width / imageSize.width;    // 最适应图片宽度的比例
    CGFloat yScale = boundsSize.height / imageSize.height;  // 最适应图片高度的比例
    CGFloat minScale = MIN(xScale, yScale);                 // 用其中最小的一个来作为全屏缩放的比例
    
    //    // 如果都比屏幕小  就设置为1
    //    if (xScale > 1 && yScale > 1) {
    //        minScale = 1.0;
    //    }
    
    // 计算最大比例
    CGFloat maxScale = 4.0; // Allow double scale
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
        
        if (maxScale < minScale) {
            maxScale = minScale * 2;
        }
    }
    
    // 计算双击后的最大比例
    CGFloat maxDoubleTapZoomScale = 4.0 * minScale; // Allow double scale
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxDoubleTapZoomScale = maxDoubleTapZoomScale / [[UIScreen mainScreen] scale];
        
        if (maxDoubleTapZoomScale < minScale) {
            maxDoubleTapZoomScale = minScale * 2;
        }
    }
    
    // Set
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    self.maximumDoubleTapZoomScale = maxDoubleTapZoomScale;
    
    // Reset
    self.imageView.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
    [self setNeedsLayout];
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 当图片比当前屏幕小的时候居中
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // H
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // V
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    if (!CGRectEqualToRect(self.imageView.frame, frameToCenter))
        self.imageView.frame = frameToCenter;
}

@end
