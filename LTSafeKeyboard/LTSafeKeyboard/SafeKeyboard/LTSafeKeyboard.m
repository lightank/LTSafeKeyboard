//
//  LTSafeKeyboard.m
//  testAPP
//
//  Created by huanyu.li on 2017/9/8.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import "LTSafeKeyboard.h"
#import "LTPasswordKeyboard.h"
#import "LTNumberKeyboard.h"
#import "LTLetterKeyboard.h"
#import "LTSymbolKeyboard.h"
#import <AVFoundation/AVFoundation.h>


@interface LTSafeKeyboard () <LTBaseKeyboardDelegate>

/**  呼出键盘的输入框  */
@property (nonatomic, weak) UITextField *textFiled;
/**  呼出键盘的输入框  */
@property (nonatomic, weak) UITextView *textView;

/** 交易密码键盘 **/
@property (nonatomic, strong) LTPasswordKeyboard *passwordKeyboard;
/** 数字键盘 **/
@property (nonatomic, strong) LTNumberKeyboard *numberKeyboard;
/** 字母键盘 **/
@property (nonatomic, strong) LTLetterKeyboard *letterKeyboard;
/** 符号键盘 **/
@property (nonatomic, strong) LTSymbolKeyboard *symbolKeyboard;

/** 按键声音开关 **/
@property (nonatomic, assign) BOOL clickSoundEnable;
/** 输入的内容文本 **/
@property (nonatomic, strong) NSString *content;
/** 键盘数组 **/
@property (nonatomic, strong) NSArray<__kindof LTBaseKeyboard *> *keyboardsArray;
/** 按键声音1 **/
@property (nonatomic, assign) SystemSoundID soundID;
/** 按键声音2 **/
@property (nonatomic, assign) SystemSoundID soundID2;


@end

@implementation LTSafeKeyboard

+ (instancetype)focusOnTextFiled:(UITextField *)textFiled
{
    return [self focusOnTextFiled:textFiled keyboardType:LTKeyboardTypeLetter];
}
+ (instancetype)focusOnTextView:(UITextView *)textView
{
    return [self focusOnTextView:textView keyboardType:LTKeyboardTypeLetter];
}
+ (instancetype)focusOnTextFiled:(UITextField *)textFiled keyboardType:(LTKeyboardType)type
{
    NSAssert([textFiled isKindOfClass:[UITextField class]], @"自定义键盘出现在非UITextField对象上");
    
    LTSafeKeyboard *keyboard = [[LTSafeKeyboard alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kKeyboardHeight)];
    keyboard.textFiled = textFiled;
    keyboard.keyboardType = type;
    textFiled.inputView = keyboard;
    return keyboard;
}
+ (instancetype)focusOnTextView:(UITextView *)textView keyboardType:(LTKeyboardType)type
{
    NSAssert([textView isKindOfClass:[textView class]], @"自定义键盘出现在非UITextView对象上");
    
    LTSafeKeyboard *keyboard = [[LTSafeKeyboard alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kKeyboardHeight)];
    keyboard.textView = textView;
    keyboard.keyboardType = type;
    textView.inputView = keyboard;
    return keyboard;
}

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initKeyboard];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [self switchKeyboardWithType:self.keyboardType];
}

- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(_soundID);
    AudioServicesDisposeSystemSoundID(_soundID2);
}

#pragma mark - 初始化键盘
- (void)initKeyboard
{
    self.backgroundColor = [UIColor redColor];
    
    // 按键音默认开启
    self.clickSoundEnable = YES;
    
    // 初始化键盘
    [self addSubview:self.numberKeyboard];
    [self addSubview:self.letterKeyboard];
    [self addSubview:self.symbolKeyboard];
    [self addSubview:self.passwordKeyboard];
    
    // 添加键盘数组
    self.keyboardsArray = @[self.passwordKeyboard,
                            self.letterKeyboard,
                            self.numberKeyboard,
                            self.symbolKeyboard];
}

#pragma mark - LTBaseKeyboardDelegate
- (void)pressKey:(NSString *)key keyType:(LTKeyType)keyType keyboardType:(LTKeyboardType)keyboardType
{
    //------  拦截键盘切换  ------//
    switch (keyType)
    {
        case LTKeyTypeSymbolSwitch:
        {
            self.keyboardType = LTKeyboardTypeSymbol;
            if (self.clickSoundEnable) AudioServicesPlaySystemSound(self.soundID2);
        }
            break;
        case LTKeyTypeNumberSwitch:
        {
            self.keyboardType = LTKeyboardTypeNumber;
            if (self.clickSoundEnable) AudioServicesPlaySystemSound(self.soundID2);
        }
            break;
        case LTKeyTypeLetterSwitch:
        {
            self.keyboardType = LTKeyboardTypeLetter;
            if (self.clickSoundEnable) AudioServicesPlaySystemSound(self.soundID2);
        }
            break;
        case LTKeyTypeUpLowSwitch:
        {
            if (self.clickSoundEnable) AudioServicesPlaySystemSound(self.soundID2);
        }
            break;
        case LTKeyTypeDelete:
        {
            //删除按钮动作
            if (self.textView) [self.textView deleteBackward];
            if (self.textFiled) [self.textFiled deleteBackward];
            
            if (self.clickSoundEnable) AudioServicesPlaySystemSound(self.soundID2);
        }
            break;
        case LTKeyTypeDone:
        {
            if (self.clickSoundEnable) AudioServicesPlaySystemSound(self.soundID2);
            if (self.textFiled) [self.textFiled resignFirstResponder];
            if (self.textView) [self.textView resignFirstResponder];
        }
            break;
        default:
        {
            self.content = [self.content stringByAppendingString:key];
            if (self.clickSoundEnable) AudioServicesPlaySystemSound(self.soundID);
        }
            break;
    }
}

#pragma mark - 事件处理
/**  切换键盘  */
- (void)switchKeyboardWithType:(LTKeyboardType)keyboardType
{
    if (keyboardType >= self.keyboardsArray.count) keyboardType = LTKeyboardTypeLetter;
    
    [self.keyboardsArray enumerateObjectsUsingBlock:^(__kindof LTBaseKeyboard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.keyboardType  == keyboardType)
        {
            obj.hidden = NO;
            obj.random = self.isRandom;
            obj.showHintBubble = self.showHintBubble;
        }
        else
        {
            obj.hidden = YES;
        }
    }];
}

#pragma mark - setter and getter
- (LTPasswordKeyboard *)passwordKeyboard
{
    if (!_passwordKeyboard)
    {
        _passwordKeyboard = [LTPasswordKeyboard keyboardWithDelegate:self];
        _passwordKeyboard.hidden = YES;
    }
    return _passwordKeyboard;
}

- (LTNumberKeyboard *)numberKeyboard
{
    if (!_numberKeyboard)
    {
        _numberKeyboard = [LTNumberKeyboard keyboardWithDelegate:self];
        _numberKeyboard.hidden = YES;
    }
    return _numberKeyboard;
}

- (LTLetterKeyboard *)letterKeyboard
{
    if (!_letterKeyboard)
    {
        _letterKeyboard = [LTLetterKeyboard keyboardWithDelegate:self];
        _letterKeyboard.hidden = YES;
    }
    return _letterKeyboard;
}

- (LTSymbolKeyboard *)symbolKeyboard
{
    if (!_symbolKeyboard)
    {
        _symbolKeyboard = [LTSymbolKeyboard keyboardWithDelegate:self];
        _symbolKeyboard.hidden = YES;
    }
    return _symbolKeyboard;
}

- (SystemSoundID)soundID
{
    if (_soundID == 0)
    {
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"keyboard-click.aiff" withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID);
    }
    return _soundID;
}

- (SystemSoundID)soundID2
{
    if (_soundID2 == 0)
    {
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"keyboard-click2.aiff" withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &_soundID2);
    }
    return _soundID2;
}

- (void)setKeyboardType:(LTKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    [self switchKeyboardWithType:keyboardType];
}

- (NSString *)content
{
    NSString *content = @"";
    if (self.textFiled) content = _textFiled.text;
    if (self.textView) content = _textView.text;
    return content;
}

- (void)setContent:(NSString *)content
{
    if (self.textFiled) _textFiled.text = content;
    if (self.textView) _textView.text = content;
}

@end
