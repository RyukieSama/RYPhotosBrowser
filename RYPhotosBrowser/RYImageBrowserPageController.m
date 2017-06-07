//
//  RYImageBrowserPageController.m
//  RYImageBrowser
//
//  Created by RongqingWang on 16/11/4.
//  Copyright © 2016年 RyukieSama. All rights reserved.
//

#import "RYImageBrowserPageController.h"
#import "Masonry.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "RYImageBrowserURLChecker.h"

#define PAGE_BOTTOM_OFFSET -20

@interface RYImageBrowserPageController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

/**
 当前展示的图片   UIImage 或者  URLString
 */
@property (nonatomic, strong) id currentImage;
/**
 pageControl显示模式  点点点
 */
@property (nonatomic, strong) UIPageControl *pcPageControl;
/**
 文字模式  2/12
 */
@property (nonatomic, strong) UILabel *lbIndex;

@end

@implementation RYImageBrowserPageController

#pragma mark - init
- (instancetype)init {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey:@30.f}];
    if (self) {
        self.dataSource      = self;
        self.delegate        = self;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self addNotificationOB];
    }
    return self;
}

#pragma mark - NOTIFICATION
- (void)addNotificationOB {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(borwersOneClick:) name:kRYImageBrowserOneClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHUD) name:BIB_NOTI_HUD_SHOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showErrorHUD) name:BIB_NOTI_HUD_SHOW_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissHUD) name:BIB_NOTI_HUD_DISMISS object:nil];
}

- (void)showHUD {
//    [RYCustomHUD showWithStyle:RYHUDStyleLoadingPic maskType:RYHUDMaskTypeNone inView:self.view];
}

- (void)showErrorHUD {
//    [RYCustomHUD dismiss];
//    [RYCustomHUD showInfoWithStatus:@"无法加载图片"];
}

- (void)dismissHUD {
//    [RYCustomHUD dismiss];
}

- (void)borwersOneClick:(NSNotification *)noti {
    [[SDWebImageDownloader sharedDownloader] cancelAllDownloads];
//    [RYCustomHUD dismiss];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if (self.dismissCallBack) {
        self.dismissCallBack(nil);
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //隐藏导航栏状态栏
    [self prefersStatusBarHidden];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;//否则偶尔会显示不出来导航栏
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    //解决可能出现的第一次进来序号点点错误的问题
    [self updateIndex:[self.images indexOfObject:self.currentImage] +1];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //取消  隐藏导航栏状态栏
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - set
- (void)setUpUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    //只有一张就不显示分页
    if (self.images.count == 1) {
        return;
    }
    
    //Points
    if (self.pageStyle == RYImageBrowserPageStylePoints) {
        [self.view addSubview:self.pcPageControl];
        [self.pcPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.mas_offset(PAGE_BOTTOM_OFFSET);
        }];
        return;
    }
    
    //Text
    [self.view addSubview:self.lbIndex];
    [self.lbIndex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(PAGE_BOTTOM_OFFSET);
    }];
}

/**
 更新页数显示
 
 @param index 当前页数
 */
- (void)updateIndex:(NSInteger)index {
    //Potins
    if (self.pageStyle == RYImageBrowserPageStylePoints) {
        self.pcPageControl.currentPage = index-1;
        return;
    }
    //Text
    self.lbIndex.text = [NSString stringWithFormat:@"%ld/%lu",(long)index,(unsigned long)self.images.count];
}

#pragma mark - PageController 设置分页
- (NSInteger)pageIndex {
    return [self.images indexOfObject:self.currentImage];
}

- (void)setPageIndex:(NSInteger)pageIndex {
    NSInteger count = self.images.count;
    if (pageIndex >= 0 && pageIndex < count) {
        // 到指定的index页面
        __block RYImageBrowserInnerController *vc;
        id img = [self.images objectAtIndex:pageIndex];
        //根据不同类型初始化不同控制器   UIImage 或者   URLString
        [RYImageBrowserURLChecker checkIsURL:img WebStringDo:^(id obj) {
            vc = [RYImageBrowserInnerController innerControllerWithImageURL:img];
        } FileStringDo:^(id obj) {
            vc = [RYImageBrowserInnerController innerControllerWithImageURL:img];
        } ImageDo:^(id obj) {
            vc = [RYImageBrowserInnerController innerControllerWithImage:img];
        }];
//        vc.thumbnailsSize = self.thumbnailsSize;
        vc.progressCallBack = self.progressCallBack;
        vc.changeCallBack = self.changeCallBack;
        vc.loadedCallBack = self.loadedCallBack;
        
        [self setViewControllers:@[vc]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:YES
                      completion:^(BOOL finished) {
                          
                      }];
        self.currentImage = img;
        [self updateIndex:pageIndex +1];
    }
}

#pragma mark - Page view controller data source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSString *urlString = ((RYImageBrowserInnerController *)viewController).imageURL;
    UIImage *img = ((RYImageBrowserInnerController *)viewController).image;
    NSInteger indexT;
    //获取当前index
    if (urlString.length > 0) {
        indexT = [self.images indexOfObject:urlString];
    }
    else {
        indexT = [self.images indexOfObject:img];
    }
    
    if (indexT <= 0 || indexT >= self.images.count) {
        return nil;
    }
    
    id imageObj = [self.images objectAtIndex:indexT - 1];
    __block RYImageBrowserInnerController *inner;
    
    [RYImageBrowserURLChecker checkIsURL:imageObj WebStringDo:^(id obj) {
        inner = [RYImageBrowserInnerController innerControllerWithImageURL:imageObj];
    } FileStringDo:^(id obj) {
        inner = [RYImageBrowserInnerController innerControllerWithImageURL:imageObj];
    } ImageDo:^(id obj) {
        inner = [RYImageBrowserInnerController innerControllerWithImage:imageObj];
    }];
//    inner.thumbnailsSize = self.thumbnailsSize;
    inner.progressCallBack = self.progressCallBack;
    inner.changeCallBack = self.changeCallBack;
    inner.loadedCallBack = self.loadedCallBack;
    return inner ?:nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSString *urlString = ((RYImageBrowserInnerController *)viewController).imageURL;
    UIImage *img = ((RYImageBrowserInnerController *)viewController).image;
    NSInteger indexT;
    //获取当前index
    if (urlString.length > 0) {
        indexT = [self.images indexOfObject:urlString];
    }
    else {
        indexT = [self.images indexOfObject:img];
    }
    
    if (!(indexT < self.images.count - 1)) {
        return nil;
    }
    
    id imageObj = [self.images objectAtIndex:indexT + 1];
    __block RYImageBrowserInnerController *inner;
    
    [RYImageBrowserURLChecker checkIsURL:imageObj WebStringDo:^(id obj) {
        inner = [RYImageBrowserInnerController innerControllerWithImageURL:imageObj];
    } FileStringDo:^(id obj) {
        inner = [RYImageBrowserInnerController innerControllerWithImageURL:imageObj];
    } ImageDo:^(id obj) {
        inner = [RYImageBrowserInnerController innerControllerWithImage:imageObj];
    }];
    
//    inner.thumbnailsSize = self.thumbnailsSize;
    inner.progressCallBack = self.progressCallBack;
    inner.changeCallBack = self.changeCallBack;
    inner.loadedCallBack = self.loadedCallBack;
    return inner ?:nil;
}

#pragma mark - Page view controller delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        RYImageBrowserInnerController *vc = (RYImageBrowserInnerController *)pageViewController.viewControllers[0];
        if (vc.imageURL.length > 0) {
            [self updateIndex:([self.images indexOfObject:vc.imageURL]+1)];
        } else {
            [self updateIndex:([self.images indexOfObject:vc.image]+1)];
        }
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    [self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //内存占用过多时清理内存中缓存的图片
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"- [%@ dealloc]",[self class]);
}

#pragma mark - lazyInti
- (UIPageControl *)pcPageControl {
    if (!_pcPageControl) {
        _pcPageControl = [[UIPageControl alloc] init];
        _pcPageControl.numberOfPages = self.images.count;
    }
    return _pcPageControl;
}

- (UILabel *)lbIndex {
    if (!_lbIndex) {
        _lbIndex = [[UILabel alloc] init];
        _lbIndex.textColor = [UIColor whiteColor];
        _lbIndex.numberOfLines = 1;
        _lbIndex.font = [UIFont systemFontOfSize:15];
        _lbIndex.textAlignment  = NSTextAlignmentCenter;
        _lbIndex.shadowColor = [UIColor blackColor];
        _lbIndex.shadowOffset = CGSizeMake(0.5, 0.5);
    }
    return _lbIndex;
}

@end
