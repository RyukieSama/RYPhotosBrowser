//
//  RYImageBrowserInnerController.m
//  RYImageBrowser
//
//  Created by RongqingWang on 16/11/4.
//  Copyright © 2016年 RyukieSama. All rights reserved.
//

#import "RYImageBrowserInnerController.h"
#import "RYImageBrowserScrollView.h"
#import "SDWebImageManager.h"
#import "Masonry.h"
#import "RYImageBrowserPageController.h"

#define PREVIEW_IV_WIDTH 100

@interface RYImageBrowserInnerController ()

@property (nonatomic, strong) RYImageBrowserScrollView *scrollView;
@property (nonatomic, strong) UIImageView *ivPre;

@end

@implementation RYImageBrowserInnerController

+ (instancetype)innerControllerWithImageURL:(NSString *)imageURL {
    RYImageBrowserInnerController *vc = [[RYImageBrowserInnerController alloc] init];
    vc.imageURL = imageURL;
    return vc;
}

+ (instancetype)innerControllerWithImage:(UIImage *)image {
    RYImageBrowserInnerController *vc = [[RYImageBrowserInnerController alloc] init];
    vc.image = image;
    return vc;
}

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestAssetImage];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.scrollView setNeedsUpdateConstraints];
    [self.scrollView updateConstraintsIfNeeded];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //        [self.scrollView updateZoomScalesAndZoom:YES];
    } completion:nil];
}

- (void)dealloc {
    NSLog(@"- [%@ dealloc]",[self class]);
}

#pragma mark - set
- (void)setUpUI {
    //缩略图
    self.ivPre = [[UIImageView alloc] init];
    self.ivPre.backgroundColor = [UIColor clearColor];
    self.ivPre.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.ivPre];
    [self.ivPre mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0).offset(-34.8);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(PREVIEW_IV_WIDTH);
        make.height.mas_equalTo(PREVIEW_IV_WIDTH);
    }];
    
    RYImageBrowserScrollView *scrollView = [[RYImageBrowserScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView = scrollView;
    self.scrollView.vc = self;
    [self.view addSubview:self.scrollView];
    
    [self.view layoutIfNeeded];
}

#pragma mark - Request image
- (void)requestAssetImage {
    //传入的是UIIMage
    if (self.image) {
        [self setImageForScrollView:self.image];
        return;
    }
    
    //传入的是URLString
    //网络图片
    if ([self.imageURL containsString:@"http://"] || [self.imageURL containsString:@"https://"] || [self.imageURL containsString:@"HTTP://"] || [self.imageURL containsString:@"HTTPS://"]) {
        [self loadWebImage];
    }
    else {//本地图片路径
        [self loadLocalImageFile];
    }
}

- (void)loadWebImage {
    //1: 先看有没有缓存原图
    UIImage *imageCached = [self getCachedImage:self.imageURL withSize:CGSizeZero];
    if (imageCached) {
        [self setImageForScrollView:imageCached];
        return;
    }
    else {
        //2: 再看有没有缓存缩略图
        UIImage *thumbnails = [self getCachedImage:self.imageURL withSize:self.thumbnailsSize];
        if (thumbnails) {
            //已经缓存了缩略图就展示  没有就不展示
            self.ivPre.image = thumbnails;
        }
        
        //否则就下载
        __weak typeof(self)weakSelf = self;
        
        NSString *imageURLString = self.imageURL;
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        
        [self showHUD];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imageURL
                                                              options:0
                                                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                                                 __strong __typeof(weakSelf)strongSelf = weakSelf;
                                                                 [strongSelf showHUD];
                                                             }
                                                            completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                                                __strong __typeof(weakSelf)strongSelf = weakSelf;
                                                                
                                                                if (!finished) {
                                                                    return;
                                                                }
                                                                
                                                                if (error) {
                                                                    [strongSelf dismissHUD];
                                                                    [strongSelf showErrorHUD];
                                                                } else {
                                                                    [[SDWebImageManager sharedManager] saveImageToCache:image forURL:imageURL];
                                                                    [strongSelf setImageForScrollView:image];
                                                                }
                                                            }];
    }
}

- (void)loadLocalImageFile {
    UIImage *imageFile = [UIImage imageWithContentsOfFile:self.imageURL];
    if (imageFile) {
        [self setImageForScrollView:imageFile];
    }
    else {
        [self showErrorHUD];
    }
}

- (UIImage *)getCachedImage:(NSString *)URLString withSize:(CGSize)size {
    NSURL *URL = [NSURL URLWithString:URLString];
    //    从缓存中取
    //    if ([[SDWebImageManager sharedManager] diskImageExistsForURL:URL]) {
    //        return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[URL absoluteString]];
    //    }
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[URL absoluteString]];
}

- (NSInteger)checkImageCache:(NSURL *)URL {
    //    [[SDWebImageManager sharedManager] cachedImageExistsForURL:URL];
    //
    //    [[SDWebImageManager sharedManager] diskImageExistsForURL:URL];
    
    return 1;
}

- (void)setImageForScrollView:(UIImage *)image {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf dismissHUD];
        [weakSelf.ivPre removeFromSuperview];
        weakSelf.scrollView.image = image;
    });
}

- (CGSize)targetImageSize {
    UIScreen *screen    = UIScreen.mainScreen;
    CGFloat scale       = screen.scale;
    return CGSizeMake(CGRectGetWidth(screen.bounds) * scale, CGRectGetHeight(screen.bounds) * scale);
}

#pragma mark - function
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:kRYImageBrowserOneClick object:self userInfo:nil];
}

#pragma mark - others
- (void)showHUD {
    [[NSNotificationCenter defaultCenter] postNotificationName:BIB_NOTI_HUD_SHOW object:nil];
}

- (void)showErrorHUD {
    [[NSNotificationCenter defaultCenter] postNotificationName:BIB_NOTI_HUD_SHOW_ERROR object:nil];
}

- (void)dismissHUD {
    [[NSNotificationCenter defaultCenter] postNotificationName:BIB_NOTI_HUD_DISMISS object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
