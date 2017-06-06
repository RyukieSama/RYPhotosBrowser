//
//  RYImageBrowserPageController.h
//  RYPhotosBrowser
//
//  Created by RongqingWang on 16/11/4.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYImageBrowser.h"

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
@property (nonatomic) CGSize thumbnailsSize;

#pragma mark - NOTI
#define kRYImageBrowserOneClick @"kRYImageBrowserOneClick"
#define kRYImageBrowserDoubleClick @"kRYImageBrowserDoubleClick"

@end
