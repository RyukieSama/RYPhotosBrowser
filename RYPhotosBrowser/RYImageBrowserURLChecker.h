//
//  RYImageBrowserURLChecker.h
//  Ryuk
//
//  Created by RongqingWang on 2017/6/6.
//  Copyright © 2017年 RyukieSama. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RYCheckURLCallBack)(id obj);

@interface RYImageBrowserURLChecker : NSObject

+ (BOOL)checkIsURL:(id)image WebStringDo:(RYCheckURLCallBack)stringWebCall FileStringDo:(RYCheckURLCallBack)stringFileCall ImageDo:(RYCheckURLCallBack)imageCall;

@end
