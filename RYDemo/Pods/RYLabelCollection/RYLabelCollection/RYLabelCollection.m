//
//  RYLabelCollection.m
//  RYDemo
//
//  Created by RongqingWang on 2017/6/1.
//  Copyright © 2017年 RongqingWang. All rights reserved.
//

#import "RYLabelCollection.h"
#import "Masonry.h"

#define TEXT_LR_SPACE 10

@interface RYLabelCollection ()

@property (nonatomic, strong) NSMutableArray *arrWid;

@end

@implementation RYLabelCollection

- (void)setLabels:(NSArray *)labels {
    _labels = labels;
    
    self.arrWid = @[].mutableCopy;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = 0;
    NSInteger count = 0;
    NSInteger index = 0;
    
    for (NSString *title in labels) {
        index++;
        if (index == self.borderColorArr.count+1 || index == self.textColorArr.count+1) {//循环颜色
            index = 1;
        }
        if (self.maxCount && index > self.maxCount) {
            break;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = self.textColorArr ? [self.textColorArr objectAtIndex:index-1] : self.textColor;
        label.textAlignment = NSTextAlignmentCenter;
        
        if (!self.noRoundCorner) {
            label.layer.cornerRadius = 7.5;
            label.layer.masksToBounds = YES;
            label.layer.borderColor = self.backgroundColorArr ? [[self.borderColorArr objectAtIndex:index-1] CGColor] : self.borderColor.CGColor;
            label.layer.borderWidth = 0.5f;
        }
        
        label.font = [UIFont systemFontOfSize:11];
        label.text = title;
        label.backgroundColor = self.backgroundColorArr ? [self.backgroundColorArr objectAtIndex:index-1] : self.backgroundColor;
        
//        CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
        
        NSDictionary *attribute = @{NSFontAttributeName: self.font};
        
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        
        UILabel *lastLabel = [self.subviews lastObject];
        
        CGFloat titleSizeWid = titleSize.width;
        if (self.maxItemWidth != 0) {
            titleSizeWid = (titleSizeWid < self.maxItemWidth) ? titleSizeWid : self.maxItemWidth;
        }
        
        count ++;
        if (count == labels.count) {
            width += titleSizeWid + TEXT_LR_SPACE;
        } else {
            width += titleSizeWid + TEXT_LR_SPACE + self.itemSpace;
        }
        
        if (width > self.maxWidth && self.maxWidth != 0 && count != 1) {
            if (count == labels.count) {
                width -= titleSizeWid + TEXT_LR_SPACE;
            } else {
                width -= titleSizeWid + TEXT_LR_SPACE + self.itemSpace;
            }
            break;
        }
        
        [self addSubview:label];
        if (lastLabel) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lastLabel.mas_right).offset(self.itemSpace);
                make.centerY.mas_equalTo(0);
                make.height.mas_equalTo(self.itemHeight);
                make.width.mas_equalTo(titleSizeWid+TEXT_LR_SPACE);
            }];
        }
        else {//第一个
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.centerY.mas_equalTo(0);
                make.height.mas_equalTo(self.itemHeight);
                make.width.mas_equalTo(titleSizeWid+TEXT_LR_SPACE);
            }];
        }
        
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(16);
    }];
}

- (void)setMaxItemWidth:(CGFloat)maxItemWidth {
    _maxItemWidth = maxItemWidth - TEXT_LR_SPACE;
}

#pragma mark - lazy
- (UIColor *)borderColor {
    if (!_borderColor) {
        _borderColor = [UIColor grayColor];
    }
    return _borderColor;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor grayColor];
    }
    return _textColor;
}

- (UIColor *)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = [UIColor whiteColor];
    }
    return _backgroundColor;
}

- (UIFont *)font {
    if (!_font) {
        _font = [UIFont systemFontOfSize:11];
    }
    return _font;
}

- (CGFloat)itemHeight {
    if (!_itemHeight) {
        _itemHeight = 16;
    }
    return _itemHeight;
}

- (CGFloat)itemSpace {
    if (!_itemSpace) {
        _itemSpace = 4;
    }
    return _itemSpace;
}


@end
