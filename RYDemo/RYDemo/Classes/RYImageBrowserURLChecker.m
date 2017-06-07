//
//  RYImageBrowserURLChecker.m
//  Ryuk
//
//  Created by RongqingWang on 2017/6/6.
//  Copyright © 2017年 RyukieSama. All rights reserved.
//

#import "RYImageBrowserURLChecker.h"

@implementation RYImageBrowserURLChecker

+ (BOOL)checkIsURL:(id)image WebStringDo:(RYCheckURLCallBack)stringWebCall FileStringDo:(RYCheckURLCallBack)stringFileCall ImageDo:(RYCheckURLCallBack)imageCall {
    if ([image isKindOfClass:[NSString class]]) {
        //网络图片
        if ([image containsString:@"http://"] || [image containsString:@"https://"] || [image containsString:@"HTTP://"] || [image containsString:@"HTTPS://"]) {
            if (stringWebCall) {
                stringWebCall(nil);
            }
        }
        else {//本地图片路径
            if (stringFileCall) {
                stringFileCall(nil);
            }
        }
        return YES;
    }
    else {
        if (imageCall) {
            imageCall(nil);
        }
        return NO;
    }
}

@end
