//
//  RYImageBrowser.h
//  RYPhotosBrowser
//
//  Created by RongqingWang on 16/11/4.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 @param size 页面展示用的缩略图的尺寸  (仅针对网络图片,默认传CGSizeZero就行了)   确保使用SD加载图片时使用的是经过处理的URL sd_setImageWithURL:STRINGTOURLWITHSIZE 
 @param index 当前第几张   从0 开始
 @param style 页码样式
 */
+ (void)showBrowserWithImageURLs:(NSArray *)imageURLs thumbnailsSize:(CGSize)size atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style;

@end
