//
//  SafeKeyboardDefine.h
//  testAPP
//
//  Created by huanyu.li on 2017/9/11.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

// 字体及大小
#define KRFONTNAME @"Helvetica-light"

// 键盘高度
#define kKeyboardHeight (kScreenHeight * 0.4)

// 设置字体和大小
#define UIFontWithNameAndSize(name, s) ([UIFont fontWithName:(name) size:(s)])

// 键盘顶部logo视图的高度
static CGFloat kLogoViewHeight = 40.f;

static NSString * const kSafeKeyboardTitle = @"  个人安全键盘";
static NSString * const kSafeKeyboardTitleImageName = @"github_logo";
static NSString * const kSpaceKeyImageName = @"kongge";   //空格键图片
static NSString * const kDeleteKeyImageName = @"shanchu";   //删除键图片
static NSString * const kKeyBackgroundImageName = @"zimubaikuang";   //键盘白框背景图片
static NSString * const kUpLowSwitchKeyNormalImageName = @"daxiaoxie";   //大小写键常规状态下图片名字
static NSString * const kUpLowSwitchKeySelectImageName = @"daxiaoxie_seleted";   //大小写键选中状态下图片名字


// 机型自适应
#define IS_IPHONE6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667 || [UIScreen mainScreen].bounds.size.width == 667)
#define IS_IPHONE6_PLUS ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 736 || [UIScreen mainScreen].bounds.size.width == 736)
#define AUTO_ADAPT_SIZE_VALUE(iPhone4_5, iPhone6, iPhone6plus) (IS_IPHONE6 ? iPhone6 : (IS_IPHONE6_PLUS ? iPhone6plus : iPhone4_5))

#pragma mark - 屏幕尺寸
//需要横屏或者竖屏，获取屏幕宽度与高度
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
#define kScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define kScreenSize ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#define kScreenBounds ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGRectMake(0, 0,[UIScreen mainScreen].nativeBounds.size.width / [UIScreen mainScreen].nativeScale, [UIScreen mainScreen].nativeBounds.size.height / [UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds)
#else
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenSize [UIScreen mainScreen].bounds.size
#define kScreenBounds [UIScreen mainScreen].bounds
#endif

//数值转字符串
#define NSStringFromValue(value) (@(value).description)
