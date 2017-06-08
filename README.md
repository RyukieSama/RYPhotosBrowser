# RYPhotosBrowser

## 亮点
>可高度自定义的图片浏览控件
>支持多种图片传入类型:  `本地文件路径` `网络图片NSString`  `UIImage对象`或`者三者混合`
>基于SDWebImage4.0
>可自定义加载阶段HUD

## 导入方式
iOS 9+
pod 'RYPhotosBrowser'

## 两种弹出姿势

* 从图片容器放大恢复

![](http://ohfpqyfi7.bkt.clouddn.com/14968906918877.gif)

``` swift
[RYImageBrowser showBrowserWithImageURLs:arr atIndex:[obj integerValue] withPageStyle:RYImageBrowserPageStyleAuto fromImageView:weakSelf.vCover withProgress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
                NSLog(@"withProgress");
                [SVProgressHUD show];
            } changImage:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
                NSLog(@"changImage");
                [SVProgressHUD dismiss];
            } loadedImage:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
                NSLog(@"loadedImage");
                [SVProgressHUD dismiss];
            }];
```

* 渐变放大

![](http://ohfpqyfi7.bkt.clouddn.com/14968935108832.gif)

``` swift
[RYImageBrowser showBrowserWithImageURLs:arr atIndex:[obj integerValue] withPageStyle:RYImageBrowserPageStyleAuto];
```

## 设置分页样式
``` swift
typedef NS_ENUM(NSInteger, RYImageBrowserPageStyle) {
    /**
     9张以内显示点点点    大于9张显示文字序号
     */
    RYImageBrowserPageStyleAuto = 99,
    /**
     显示点点点
     */
    RYImageBrowserPageStylePoints = 100,
    /**
     显示文字
     */
    RYImageBrowserPageStyleText = 101,
};
```

## 调用方法
``` swift
/**
 show   自定义分页样式

 @param imageURLs 图片数组  UIImage 和 URLString(webURL/本地路径) 都行  混合也行   @[UIImage ,UIImage UIImage , ...]  或  @[NSString, NSString ,NSString , ...]  或 @[UIImage ,NSString ,UIImage , ...]
 @param index 当前第几张   从0 开始
 @param style 页码样式
 */
+ (void)showBrowserWithImageURLs:(NSArray *)imageURLs atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style;

/**
 show   自定义分页样式
 
 @param imageURLs 图片数组  UIImage 和 URLString(webURL/本地路径) 都行  混合也行   @[UIImage ,UIImage UIImage , ...]  或  @[NSString, NSString ,NSString , ...]  或 @[UIImage ,NSString ,UIImage , ...]
 @param index 当前第几张   从0 开始
 @param style 页码样式
 @param imageView 点击的图片容器
 */
+ (void)showBrowserWithImageURLs:(NSArray *)imageURLs atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style fromImageView:(UIView *)imageView;

/**
 show   自定义分页样式
 
 @param imageURLs 图片数组  UIImage 和 URLString(webURL/本地路径) 都行  混合也行   @[UIImage ,UIImage UIImage , ...]  或  @[NSString, NSString ,NSString , ...]  或 @[UIImage ,NSString ,UIImage , ...]
 @param index 当前第几张   从0 开始
 @param style 页码样式
 @param imageView 点击的图片容器
 @param progress 加载图片中的回调  在此可自定义添加HUD等操作
 @param changed 切换图片的回调
 @param loaded 图片完成的回调
 */
+ (void)showBrowserWithImageURLs:(NSArray *)imageURLs atIndex:(NSInteger)index withPageStyle:(RYImageBrowserPageStyle)style fromImageView:(UIView *)imageView withProgress:(RYWebImageDownloaderProgressBlock)progress changImage:(RYWebImageDownloaderProgressBlock)changed loadedImage:(RYWebImageDownloaderProgressBlock)loaded;
```


