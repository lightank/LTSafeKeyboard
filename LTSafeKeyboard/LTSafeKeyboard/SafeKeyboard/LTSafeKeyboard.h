//
//  LTSafeKeyboard.h
//  testAPP
//
//  Created by huanyu.li on 2017/9/8.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

// 键盘类型
typedef NS_ENUM(NSInteger, LTKeyboardType) {
    LTKeyboardTypeLetter,   // 字母键盘
    LTKeyboardTypeNumber,   // 数字键盘
    LTKeyboardTypeSymbol,   // 符号键盘
    LTKeyboardTypePassword, // 交易密码键盘,纯数字,不可切换
    LTKeyboardTypeCommon,   // 通用键盘(预留拓展), 包括字母/数字/符号键盘, 用于标记顶部右上角的完成按钮, 切勿当具体键盘类型使用!
};

@interface LTSafeKeyboard : UIView

/**  当前键盘类型  */
@property (nonatomic, assign) LTKeyboardType keyboardType;
/**  是否乱序键盘,默认NO  */
@property (nonatomic, assign, getter=isRandom) BOOL random;
/**  是否显示提示气泡,默认NO  */
@property (nonatomic, assign, getter=isShowHintBubble) BOOL showHintBubble;


/**
 返回用于UITextField的默认类型为LTKeyboardTypeLetter的键盘
 */
+ (instancetype)focusOnTextFiled:(UITextField *)textFiled;
/**
 返回用于UITextView的默认类型为LTKeyboardTypeLetter的键盘
 */
+ (instancetype)focusOnTextView:(UITextView *)textView;
/**
 返回用于UITextField的指定类型的键盘
 */
+ (instancetype)focusOnTextFiled:(UITextField *)textFiled keyboardType:(LTKeyboardType)type;
/**
 返回用于UITextView的指定类型的键盘
 */
+ (instancetype)focusOnTextView:(UITextView *)textView keyboardType:(LTKeyboardType)type;

@end
