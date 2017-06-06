//
//  ViewController.m
//  RYDemo
//
//  Created by RongqingWang on 2017/6/1.
//  Copyright © 2017年 RongqingWang. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "RYLabelCollection.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *viewOne;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
}

- (void)setupUI {
    self.viewOne = [[UIView alloc] init];
    self.viewOne.backgroundColor = [UIColor cyanColor];
    
    RYLabelCollection *labelCollection = [[RYLabelCollection alloc] init];
//    labelCollection.textColor = [UIColor redColor];
    labelCollection.borderColor = [UIColor redColor];
    labelCollection.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    labelCollection.itemSpace = 10;
    labelCollection.itemHeight = 16;
    labelCollection.font = [UIFont systemFontOfSize:11];
    labelCollection.maxWidth = [UIScreen mainScreen].bounds.size.width;
    
    labelCollection.textColorArr = @[
                                     [UIColor redColor],
                                     [UIColor whiteColor]
                                     ];
    
    labelCollection.labels = @[
                               @"asdfafdadfasdfasf",
                               @"asdf",
                               @"asdfa",
                               @"kjnlkjnlkkljnl",
                               @"alkjsldknjlknfgjbnkjnsdc",
                               @"jinytinade de ad",
                               @"asdasdasdad"
                               ];
    
    [self.view addSubview:self.viewOne];
    [self.viewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.viewOne addSubview:labelCollection];
    [labelCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
