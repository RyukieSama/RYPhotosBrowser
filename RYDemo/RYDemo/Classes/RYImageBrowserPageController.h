//
//  RYImageBrowserPageController.h
//  RYImageBrowser
//
//  Created by RongqingWang on 16/11/4.
//  Copyright © 2016年 RyukieSama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYImageBrowser.h"

typedef void(^showCallBack)(id obj);

@interface RYImageBrowserPageController : UIPageViewController

/**
 当前图片的序号
 */
@property (nonatomic, assign) NSInteger pageIndex;
/**
 缩略图数组
 */
@property (nonatomic, strong) NSArray *thumbnails;
/**
 原图URL String数组
 */
@property (nonatomic, strong) NSArray *images;
/**
 分页样式
 */
@property (nonatomic, assign) RYImageBrowserPageStyle pageStyle;
/**
 防止RYImageBrowser被释放掉
 */
@property (nonatomic, strong) RYImageBrowser *browser;
@property (nonatomic, copy) showCallBack dismissCallBack;
@property (nonatomic) CGSize thumbnailsSize;

#pragma mark - NOTI
#define kRYImageBrowserOneClick @"kRYImageBrowserOneClick"
#define kRYImageBrowserDoubleClick @"kRYImageBrowserDoubleClick"

@end
