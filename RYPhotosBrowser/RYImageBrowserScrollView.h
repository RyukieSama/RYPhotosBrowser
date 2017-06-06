//
//  RYImageBrowserScrollView.h
//  RYImageBrowser
//
//  Created by RongqingWang on 16/11/4.
//  Copyright © 2016年 RyukieSama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYImageBrowserInnerController.h"

@interface RYImageBrowserScrollView : UIScrollView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) RYImageBrowserInnerController *vc;

@end
