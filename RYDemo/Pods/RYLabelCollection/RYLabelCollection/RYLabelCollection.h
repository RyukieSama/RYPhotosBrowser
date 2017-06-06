//
//  RYLabelCollection.h
//  RYDemo
//
//  Created by RongqingWang on 2017/6/1.
//  Copyright © 2017年 RongqingWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYLabelCollection : UIView

/**
 是否切圆角
 */
@property (nonatomic, assign) BOOL noRoundCorner;
/**
 标签间距
 */
@property (nonatomic, assign) CGFloat itemSpace;
/**
 标签高度
 */
@property (nonatomic, assign) CGFloat itemHeight;
/**
 标签字体
 */
@property (nonatomic, strong) UIFont *font;
/**
 最大宽度   超出的标签不显示
 */
@property (nonatomic, assign) CGFloat maxWidth;
/**
 单个标签最大宽度
 */
@property (nonatomic, assign) CGFloat maxItemWidth;
/**
 最多显示几个标签
 */
@property (nonatomic, assign) NSInteger maxCount;
/**
 标签的背景色
 */
@property (nonatomic, strong) UIColor *backgroundColor;
/**
 标签边框色
 */
@property (nonatomic, strong) UIColor *borderColor;
/**
 标签文字颜色   优先级低于 textColorArr
 */
@property (nonatomic, strong) UIColor *textColor;
/**
 需要显示的标签文案数组
 */
@property (nonatomic, strong) NSArray *labels;
/**
 指定了文字颜色数组后 textColor 失效  务必在设置文字之前设置
 */
@property (nonatomic, strong) NSArray <UIColor *>*textColorArr;
/**
 边框色数组
 */
@property (nonatomic, strong) NSArray <UIColor *>*borderColorArr;
/**
 标签背景色数组
 */
@property (nonatomic, strong) NSArray <UIColor *>*backgroundColorArr;

@end
