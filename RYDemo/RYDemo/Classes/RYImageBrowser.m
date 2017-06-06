//
//  RYImageBrowser.m
//  RYPhotosBrowser
//
//  Created by RongqingWang on 16/11/4.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import "RYImageBrowser.h"
#import "RYImageBrowserPageController.h"
#import "RYImageBrowserTransitionAnimator.h"

@interface RYImageBrowser ()<UIViewControllerTransitioningDelegate>

@property (nonatomic) CGSize thumbnailsSize;

@end

@implementation RYImageBrowser

+ (void)showBrowserWithImageURLs:(NSArray *)imageURLs thumbnailsSize:(CGSize)size atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style {
    RYImageBrowser *ib = [[RYImageBrowser alloc] init];
    ib.thumbnailsSize = size;
    [ib showBrowserWithURLs:imageURLs thumbnailsSize:size atIndex:index withPageStyle:style];
}

- (void)showBrowserWithURLs:(NSArray *)imageURLs thumbnailsSize:(CGSize)size atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style {
    if (imageURLs.count <= 0) { //没有图片
        return;
    }
    
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
    vc.thumbnailsSize = self.thumbnailsSize;
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
