//
//  ViewController.m
//  RYDemo
//
//  Created by RongqingWang on 2017/6/1.
//  Copyright © 2017年 RongqingWang. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "RYImageBrowser.h"
#import <UIButton+WebCache.h>

@interface ViewController ()

@property (nonatomic, strong) UIView *viewOne;
@property (nonatomic, strong) NSArray *images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.images = @[
                    @"http://ohfpqyfi7.bkt.clouddn.com/14962186443463.png",
                    @"http://ohfpqyfi7.bkt.clouddn.com/14962198828930.png",
                    @"http://ohfpqyfi7.bkt.clouddn.com/14962200654350.png",
                    @"http://ohfpqyfi7.bkt.clouddn.com/14962202375596.png",
                    @"http://ohfpqyfi7.bkt.clouddn.com/14962202549313.png",
                    [UIImage imageNamed:@"Simulator Screen Shot 2017年5月27日 下午4.21.22"]
                    ];
    [self setupUI];
}

- (void)setupUI {
    self.viewOne = [[UIView alloc] init];
    self.viewOne.backgroundColor = [UIColor cyanColor];
    
    NSInteger count = -1;
    for (id img in self.images) {
        count++;
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, count * 100, 60, 100)];
        [self.view addSubview:bt];
        if ([img isKindOfClass:[UIImage class]]) {
            [bt setImage:img forState:UIControlStateNormal];
        } else if ([img isKindOfClass:[NSString class]]) {
            [bt sd_setImageWithURL:[NSURL URLWithString:img] forState:UIControlStateNormal];
        }
        [bt addTarget:self action:@selector(shiowImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)shiowImage:(UIButton *)button {
    [RYImageBrowser showBrowserWithImageURLs:self.images atIndex:0 withPageStyle:RYImageBrowserPageStyleAuto fromImageView:button withProgress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
        
    } changImage:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
        
    } loadedImage:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
