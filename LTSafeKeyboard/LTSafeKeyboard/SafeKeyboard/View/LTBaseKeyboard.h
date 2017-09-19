//
//  LTBaseKeyboard.h
//  testAPP
//
//  Created by huanyu.li on 2017/9/11.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SafeKeyboardDefine.h"
#import "NSArray+Sudoku.h"
#import "LTSafeKeyboard.h"
#import "NSArray+LTAdd.h"
#import "LTHintBubble.h"
#import "NSMutableArray+LTAdd.h"
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "SafeKeyboardDefine.h"

// 按键类型
typedef NS_ENUM(NSInteger, LTKeyType) {
    // 切换键类型
    LTKeyTypeSymbolSwitch, // 符号键盘切换
    LTKeyTypeNumberSwitch, // 数字键盘切换
    LTKeyTypeLetterSwitch, // 字母键盘切换
    LTKeyTypeUpLowSwitch,  // 大小写切换
    
    // 功能键类型
    LTKeyTypeDelete, // 删除键
    LTKeyTypeDone,   // 完成键
    
    // 值键类型
    LTKeyTypeSymbol, // 符号
    LTKeyTypeNumber, // 数字
    LTKeyTypeLetter  // 字母
};


@protocol LTBaseKeyboardDelegate <NSObject>

@required

/**
 按键回调
 
 @param key 文本值
 @param keyType 按键类型
 @param keyboardType 键盘类型
 */
- (void)pressKey:(NSString *)key keyType:(LTKeyType)keyType keyboardType:(LTKeyboardType)keyboardType;

@optional
/**  删除按钮长按动作  */
- (void)deleteKeyPressGestureAction:(UILongPressGestureRecognizer *)gesture;

@end


@interface LTBaseKeyboard : UIView

/** 键盘代理 **/
@property (nonatomic, weak) id<LTBaseKeyboardDelegate> delegate;
/** 是否隐藏键盘顶部的完成按钮 默认不隐藏 **/
@property (nonatomic, assign) BOOL hideTopDoneButton;
/**  是否乱序键盘  */
@property (nonatomic, assign, getter=isRandom) BOOL random;
/**  头视图  */
@property (nonatomic, strong) UIView *titleView;
/** 键盘气泡 **/
@property (nonatomic, strong) LTHintBubble *bubble;
/**  是否显示提示气泡  */
@property (nonatomic, assign, getter=isShowHintBubble) BOOL showHintBubble;
/** 删除按钮 **/
@property (nonatomic, weak) UIView *deleteKey;

/**  当前键盘类型  */
- (LTKeyboardType)keyboardType;
/**  乱序键盘  */
- (void)randomKeyBoard;
/**  在删除按钮上添加长按手势  */
- (void)addPressGestureToDeleteKey:(UIView *)key;

/**
 快速创建键盘
 
 @param delegate 代理对象
 @return 键盘对象
 */
+ (instancetype)keyboardWithDelegate:(id<LTBaseKeyboardDelegate>)delegate;

@end
