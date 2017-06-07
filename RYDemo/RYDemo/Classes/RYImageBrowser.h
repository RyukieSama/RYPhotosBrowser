//
//  RYImageBrowser.h
//  RYImageBrowser
//
//  Created by RongqingWang on 16/11/4.
//  Copyright © 2016年 RyukieSama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYImageBrowserInnerController.h"

typedef NS_ENUM(NSInteger, RYImageBrowserPageStyle) {
    /**
     9张以内显示点点点    大于9张显示文字序号
     */
    RYImageBrowserPageStyleAuto = 99,
    /**
     显示点点点
     */
    RYImageBrowserPageStylePoints = 100,
    /**
     显示文字
     */
    RYImageBrowserPageStyleText = 101,
};

@interface RYImageBrowser : NSObject

/**
 show   自定义分页样式

 @param imageURLs 图片数组  UIImage 和 URLString(webURL/本地路径) 都行  混合也行   @[UIImage ,UIImage UIImage , ...]  或  @[NSString, NSString ,NSString , ...]  或 @[UIImage ,NSString ,UIImage , ...]
 @param index 当前第几张   从0 开始
 @param style 页码样式
 */
+ (void)showBrowserWithImageURLs:(NSArray *)imageURLs atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style;

/**
 show   自定义分页样式
 
 @param imageURLs 图片数组  UIImage 和 URLString(webURL/本地路径) 都行  混合也行   @[UIImage ,UIImage UIImage , ...]  或  @[NSString, NSString ,NSString , ...]  或 @[UIImage ,NSString ,UIImage , ...]
 @param index 当前第几张   从0 开始
 @param style 页码样式
 @param imageView 点击的图片容器
 */
+ (void)showBrowserWithImageURLs:(NSArray *)imageURLs atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style fromImageView:(UIView *)imageView;

/**
 show   自定义分页样式
 
 @param imageURLs 图片数组  UIImage 和 URLString(webURL/本地路径) 都行  混合也行   @[UIImage ,UIImage UIImage , ...]  或  @[NSString, NSString ,NSString , ...]  或 @[UIImage ,NSString ,UIImage , ...]
 @param index 当前第几张   从0 开始
 @param style 页码样式
 @param imageView 点击的图片容器
 @param progress 加载图片中的回调  在此可自定义添加HUD等操作
 @param changed 切换图片的回调
 @param loaded 图片完成的回调
 */
+ (void)showBrowserWithImageURLs:(NSArray *)imageURLs atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style fromImageView:(UIView *)imageView withProgress:(RYWebImageDownloaderProgressBlock)progress changImage:(RYWebImageDownloaderProgressBlock)changed loadedImage:(RYWebImageDownloaderProgressBlock)loaded;

@end
