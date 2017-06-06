//
//  RYImageBrowserScrollView.h
//  RYPhotosBrowser
//
//  Created by RongqingWang on 16/11/4.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYImageBrowserScrollView : UIScrollView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;

- (void)updateZoomScalesAndZoom:(BOOL)zoom;

@end
