//
//  LTBaseKeyboard.m
//  testAPP
//
//  Created by huanyu.li on 2017/9/11.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import "LTBaseKeyboard.h"

@interface LTBaseKeyboard () 

/** 顶部左边Logo **/
@property (nonatomic, strong) UIImageView *logoImageView;
/** 顶部Logo键盘标题 **/
@property (nonatomic, strong) UILabel *logoLabel;
/** 右上角完成按钮 **/
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation LTBaseKeyboard

+ (instancetype)keyboardWithDelegate:(id<LTBaseKeyboardDelegate>)delegate
{
    __kindof LTBaseKeyboard *keyboard = [[self alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kKeyboardHeight)];
    keyboard.delegate = delegate;
    return keyboard;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBaseUI];
    }
    return self;
}

- (void)setupBaseUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self creatKeyboardLogoView];
}

- (void)creatKeyboardLogoView
{
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLogoViewHeight)];
    logoView.backgroundColor = [UIColor whiteColor];
    _titleView = logoView;
    
    // 添加顶部视图
    [self addSubview:logoView];
    // 添加logo视图
    [logoView addSubview:self.logoImageView];
    // 添加标题
    [logoView addSubview:self.logoLabel];
    // 添加完成按钮
    [logoView addSubview:self.doneButton];
    
    //------  添加约束  ------//
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(kLogoViewHeight - 5.f);
        make.width.mas_equalTo((kLogoViewHeight - 5.f) * 0.72);
        make.centerY.mas_offset(0.f);
        make.left.mas_offset(5.f);
    }];
    
    [_logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_offset(0.f);
        make.height.mas_offset(kLogoViewHeight - 10.f);
    }];
    
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-5.f);
        make.centerY.mas_offset(0.f);
    }];
    
    //------  添加底部划线  ------//
    UIView * bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [logoView addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_offset(0);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - 事件处理
/**  右上角完成按钮点击事件  */
- (void)doneClick:(UIButton *)sender
{
    [self.delegate pressKey:@"完成" keyType:LTKeyTypeDone keyboardType:LTKeyboardTypeCommon];
}

- (void)layoutSubviews
{
    [self addPressGestureToDeleteKey:self.deleteKey];
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [self randomKeyBoard];
}

/**  乱序键盘  */
- (void)randomKeyBoard
{
    if (!self.isRandom) return;
}

/**  在删除按钮上添加长按手势  */
- (void)addPressGestureToDeleteKey:(UIView *)key
{
    if (![self.delegate respondsToSelector:@selector(deleteKeyPressGestureAction:)])
    {
        return;
    }
    else
    {
        
    }
    
    __block BOOL isAdd = NO;
    [key.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if ([obj isKindOfClass:[UILongPressGestureRecognizer class]])
       {
           isAdd = YES;
           *stop = YES;
       }
    }];
    if (isAdd) return;
    
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(deleteKeyPressGestureAction:)];
    longPressGr.minimumPressDuration = 1.f;
    [key addGestureRecognizer:longPressGr];
}

#pragma mark - setter and getter
- (void)setHideTopDoneButton:(BOOL)hideTopDoneButton
{
    _hideTopDoneButton = hideTopDoneButton;
    self.doneButton.hidden = _hideTopDoneButton;
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView)
    {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    }
    return _logoImageView;
}

- (UILabel *)logoLabel
{
    if (!_logoLabel)
    {
        _logoLabel = [[UILabel alloc] init];
        // 设置图片和文字
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:kSafeKeyboardTitle];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrStr.string.length)];
        // 创建一个文字附件对象
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:kSafeKeyboardTitleImageName];  //设置图片源
        textAttachment.bounds = CGRectMake(0, - 7, 27, 27);  //设置图片位置和大小
        // 将文字附件转换成属性字符串
        NSAttributedString *attachmentAttrStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        // 将转换成属性字符串插入到目标字符串
        [attrStr insertAttributedString:attachmentAttrStr atIndex:0];
        [_logoLabel setAttributedText:attrStr];
        // 设置字体颜色
        _logoLabel.textColor = [UIColor darkGrayColor];
        // 设置字体大小
        _logoLabel.font = [UIFont systemFontOfSize:15];
    }
    return _logoLabel;
}

- (UIButton *)doneButton
{
    if (!_doneButton)
    {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (void)setRandom:(BOOL)random
{
    _random = random;
    [self randomKeyBoard];
}

- (LTHintBubble *)bubble
{
    if (!_bubble && self.isShowHintBubble)
    {
        _bubble = [[LTHintBubble alloc] init];
    }
    return _bubble;
}

- (void)setShowHintBubble:(BOOL)showHintBubble
{
    _showHintBubble = showHintBubble;
    [self bubble];
}

- (LTKeyboardType)keyboardType
{
    return LTKeyboardTypeCommon;
}

@end
