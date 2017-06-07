//
//  RYImageBrowser.m
//  RYImageBrowser
//
//  Created by RongqingWang on 16/11/4.
//  Copyright © 2016年 RyukieSama. All rights reserved.
//

#import "RYImageBrowser.h"
#import "RYImageBrowserPageController.h"
#import "RYImageBrowserTransitionAnimator.h"
#import "RYImageBrowserURLChecker.h"
#import "UIImageView+WebCache.h"

@interface RYImageBrowser ()<UIViewControllerTransitioningDelegate>

//@property (nonatomic) CGSize thumbnailsSize;
@property (nonatomic, copy) showCallBack presentCallBack;
@property (nonatomic, copy) showCallBack dismissCallBack;
@property (nonatomic, copy) RYWebImageDownloaderProgressBlock progressCallBack;
@property (nonatomic, copy) RYWebImageDownloaderProgressBlock changeCallBack;
@property (nonatomic, copy) RYWebImageDownloaderProgressBlock loadedCallBack;

@end

@implementation RYImageBrowser

+ (void)showBrowserWithImageURLs:(NSArray *)imageURLs atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style fromImageView:(UIView *)imageView withProgress:(RYWebImageDownloaderProgressBlock)progress changImage:(RYWebImageDownloaderProgressBlock)changed loadedImage:(RYWebImageDownloaderProgressBlock)loaded {
    if (imageURLs.count <= 0) { //没有图片
        return;
    }
    
    if (!imageView) {//没有指定点击控件
        RYImageBrowser *ib = [[RYImageBrowser alloc] init];
        [ib showBrowserWithURLs:imageURLs atIndex:index withPageStyle:style];
        return;
    }
    
    //指定了点击控件
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect imageRect = [imageView convertRect:imageView.bounds toView:window];
    NSLog(@"x:%f   y:%f   w:%f   h:%f",imageRect.origin.x,imageRect.origin.y,imageRect.size.width,imageRect.size.height);
    
    //创建Window上的蒙版
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backView.backgroundColor = [UIColor clearColor];
    
    //添加一个和弹出控件一样的imageView
    UIImageView *topImage = [[UIImageView alloc] initWithFrame:imageRect];
    topImage.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:topImage];
    //    topImage.backgroundColor = [UIColor clearColor];
    
    CGPoint dismissToCenter = topImage.center;
    
    id imageObj = [imageURLs objectAtIndex:index];
    [RYImageBrowserURLChecker checkIsURL:imageObj WebStringDo:^(id obj) {
        [topImage sd_setImageWithURL:[NSURL URLWithString:imageObj] placeholderImage:nil];
    } FileStringDo:^(id obj) {
        UIImage *imageFile = [UIImage imageWithContentsOfFile:imageObj];
        if (imageFile) {
            topImage.image = imageFile;
        } else {
            NSLog(@"图片不存在");
        }
    } ImageDo:^(id obj) {
        topImage.image = imageObj;
    }];
    
    [window addSubview:backView];
    
    //动画放大
    [UIView animateWithDuration:0.25 animations:^{
        backView.backgroundColor = [UIColor blackColor];
        topImage.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*imageRect.size.height/imageRect.size.width);
        topImage.center = backView.center;
    } completion:^(BOOL finished) {
        RYImageBrowser *ib = [[RYImageBrowser alloc] init];
        ib.progressCallBack = progress;
        ib.changeCallBack = changed;
        ib.loadedCallBack = loaded;
        ib.presentCallBack = ^(id obj) {
            backView.hidden = YES;
        };
        ib.dismissCallBack = ^(id obj) {
            backView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                backView.backgroundColor = [UIColor clearColor];
                topImage.frame = imageRect;
                topImage.center = dismissToCenter;
            } completion:^(BOOL finished) {
                backView.hidden = YES;
                [backView removeFromSuperview];
            }];
        };
        [ib showBrowserWithURLs:imageURLs atIndex:index withPageStyle:style];
    }];
}

+ (void)showBrowserWithImageURLs:(NSArray *)imageURLs atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style {
    [self showBrowserWithImageURLs:imageURLs atIndex:index withPageStyle:style fromImageView:nil];
}

+ (void)showBrowserWithImageURLs:(NSArray *)imageURLs atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style fromImageView:(UIView *)imageView {
    [self showBrowserWithImageURLs:imageURLs atIndex:index withPageStyle:style fromImageView:imageView withProgress:nil changImage:nil loadedImage:nil];
}

- (void)showBrowserWithURLs:(NSArray *)imageURLs atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style {
    //checkArr    提高容错
    for (id obj in imageURLs) {
        if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[UIImage class]]) {
            continue;
        }
        NSLog(@"RYImageBrowser    !!!!!!!!!!!!!!!!      传入的图片数组有误    请确认仅包含  UIImage  或者   URLString ");
        return;
    }
    
    //初始化预览控制器
    RYImageBrowserPageController *vc = [[RYImageBrowserPageController alloc] init];
    //大图
    vc.images = imageURLs;
    //在设置分页前先设置回调
    vc.dismissCallBack = self.dismissCallBack;
    vc.progressCallBack = self.progressCallBack;
    vc.changeCallBack = self.changeCallBack;
    vc.loadedCallBack = self.loadedCallBack;
    //当前页数
    vc.pageIndex = (index>=0 && index < imageURLs.count) ? index : 0;
    //持有一下它防止在dimiss之前被释放掉导致自定义的专场动画的代理没有了
    vc.browser = self;
    
    //设置分页样式
    if (style > 99) {
        vc.pageStyle = style;
    } else {
        if (imageURLs.count > 9) {
            vc.pageStyle = RYImageBrowserPageStyleText;
        } else {
            vc.pageStyle = RYImageBrowserPageStylePoints;
        }
    }
    
    //设置自定义动画
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [[self getAppTopVieController] presentViewController:vc animated:YES completion:^{
        if (self.presentCallBack) {
            self.presentCallBack(nil);
        }
    }];
}

- (UIViewController *)getAppTopVieController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return tabBarController.selectedViewController;
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return navigationController.visibleViewController;
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return presentedViewController.presentedViewController;
    } else {
        return rootViewController;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[RYImageBrowserTransitionAnimator alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[RYImageBrowserTransitionAnimator alloc] init];
}

- (void)dealloc {
    //一旦弹出了图片浏览器后就会释放掉  动画的代理没有了  需要持有一下它
    NSLog(@"- [%@ dealloc]",[self class]);
}

@end
