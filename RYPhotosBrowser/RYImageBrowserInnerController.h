//
//  RYImageBrowserInnerController.h
//  RYImageBrowser
//
//  Created by RongqingWang on 16/11/4.
//  Copyright © 2016年 RyukieSama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYImageBrowserInnerController : UIViewController

/**
 webimage URL
 */
@property (nonatomic, copy) NSString *imageURL;
/**
 UIImage Obj
 */
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) CGSize thumbnailsSize;

/**
 加载网络图片
 
 @param imageURL 网络图片URL
 
 */
+ (instancetype)innerControllerWithImageURL:(NSString *)imageURL;

/**
 加载UIImage对象
 
 @param image UIImage
 
 */
+ (instancetype)innerControllerWithImage:(UIImage *)image;

#pragma mark - NOTI
#define BIB_NOTI_HUD_SHOW @"BIB_NOTI_HUD_SHOW"
#define BIB_NOTI_HUD_SHOW_ERROR @"BIB_NOTI_HUD_SHOW_ERROR"
#define BIB_NOTI_HUD_DISMISS @"BIB_NOTI_HUD_DISMISS"

@end
