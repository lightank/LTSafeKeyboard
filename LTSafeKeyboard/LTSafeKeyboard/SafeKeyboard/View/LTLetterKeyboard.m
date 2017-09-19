//
//  LTLTKeyboardTypeLetter.m
//  testAPP
//
//  Created by huanyu.li on 2017/9/11.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import "LTLetterKeyboard.h"

@interface LTLetterKeyboard ()

/** 大小写标记 **/
@property (nonatomic, assign) BOOL isUp;
/** 标识触摸最后的按钮 **/
@property (nonatomic, strong) UIButton *lastButton;
/** 按钮数组 **/
@property (nonatomic, strong) NSArray<UIButton *> *buttonArray;
/** 键盘父视图 */
@property (nonatomic, strong) UIView *buttonSuperView;

/**  正常的字母数组  */
@property (nonatomic, strong) NSArray *normalNumberArray;
/**  乱序的字母数组  */
@property (nonatomic, strong) NSArray *randomNumberArray;
/**  字母按钮数组  */
@property (nonatomic, strong) NSArray<UIButton *> *numberButtonArray;

/**  正常的数字数组  */
@property (nonatomic, strong) NSArray *normalLetterArray;
/**  乱序的数字数组  */
@property (nonatomic, strong) NSArray *randomLetterArray;
/**  数字按钮数组  */
@property (nonatomic, strong) NSArray<UIButton *> *letterButtonArray;

@end

@implementation LTLetterKeyboard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setupDefault];
    [self setupUI];
}

- (void)setupDefault
{
    
}

- (void)setupUI
{
    // 添加按钮
    [self creatButtons];
}

- (void)creatButtons
{
    NSString *str = @"1 2 3 4 5 6 7 8 9 0 q w e r t y u i o p a s d f g h j k l delete up z x c v b n m symbol 123";
    NSArray *letterArr = [str componentsSeparatedByString:@" "];
    
    // 添加按钮父视图
    _buttonSuperView = [[UIView alloc] init];
    [self addSubview:_buttonSuperView];
    
    [_buttonSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.mas_offset(kLogoViewHeight);
    }];
    
    NSMutableArray *normalNumberArray = [NSMutableArray array];
    NSMutableArray *normalLetterArray = [NSMutableArray array];
    
    NSMutableArray *numberButtonArray = [NSMutableArray array];
    NSMutableArray *letterButtonArray = [NSMutableArray array];
    
    NSMutableArray *buttonArray = [NSMutableArray array];

    
    for (int i  = 0; i < letterArr.count; i++)
    {
        UIButton * button = [[UIButton alloc] init];
        
        button.tag = i;
        [button setBackgroundImage:[[UIImage imageNamed:kKeyBackgroundImageName] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [button setTitle:letterArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = UIFontWithNameAndSize(KRFONTNAME,22);
        [_buttonSuperView addSubview:button];
        button.enabled = NO;
        
        switch (i)
        {
            case 29:    //删除键
            {
                [button setTitle:@"" forState:UIControlStateNormal];
                [button setBackgroundImage:[[UIImage imageNamed:kDeleteKeyImageName] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
                button.enabled = YES;
            }
                break;
            case 30:    //大小写切换
            {
                [button setTitle:@"" forState:UIControlStateNormal];
                [button setBackgroundImage:[[UIImage imageNamed:kUpLowSwitchKeyNormalImageName] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            }
                break;
            case 38:    //符号切换
            {
                [button setTitle:@"符" forState:UIControlStateNormal];
                button.titleLabel.font = UIFontWithNameAndSize(KRFONTNAME, 17);
            }
                break;
            case 39:    //数字切换
            {
                [button setTitle:@"123" forState:UIControlStateNormal];
                button.titleLabel.font = UIFontWithNameAndSize(KRFONTNAME, 17);
            }
                break;
            default:
            {
                if (i < 10)
                {
                    [normalNumberArray addObject:letterArr[i]];
                    [numberButtonArray addObject:button];
                }
                else
                {
                    [normalLetterArray addObject:letterArr[i]];
                    [letterButtonArray addObject:button];
                }
            }
                break;
        }
        
        _normalNumberArray = normalNumberArray.copy;
        _numberButtonArray = numberButtonArray.copy;
        
        _normalLetterArray = normalLetterArray.copy;
        _letterButtonArray = letterButtonArray.copy;
        
        // 启用点击事件
        if (i == 29 || i == 30 || i == 38 || i == 39)
        {
            [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
            button.enabled = YES;
        }
        [buttonArray addObject:button];
    }
    
    _buttonArray = buttonArray.copy;
    
    [_buttonSuperView.subviews mas_distributeSudokuViewsWithFixedLineSpacing:5 fixedInteritemSpacing:2 warpCount:10 topSpacing:8 bottomSpacing:8 leadSpacing:8 tailSpacing:8];
}

#pragma mark - Touch Responders
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.lastButton = nil;
    [self touchesMoved:touches withEvent:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    if (touch.view != _buttonSuperView) return;
    CGPoint location = [touch locationInView:touch.view];
    UIButton *btn = [self keyboardButtonWithLocation:location];
    
    if (btn)
    {
        self.lastButton = btn;
        [self.bubble showFromButton:btn];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.bubble removeFromSuperview];
    
    UITouch *touch = touches.anyObject;
    if (touch.view != _buttonSuperView) return;

    CGPoint location = [touch locationInView:touch.view];
    UIButton *btn = [self keyboardButtonWithLocation:location];
    
    if (btn)
    {
        [self buttonTap:btn];
    }
    else if (self.lastButton)
    {
        [self buttonTap:self.lastButton];
    }
    
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.bubble removeFromSuperview];
}

#pragma mark - 按钮点击事件
- (void)buttonTap:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        {
            [self.delegate pressKey:sender.titleLabel.text keyType:LTKeyTypeNumber keyboardType:LTKeyboardTypeLetter];
        }
            break;
        case 29:    //删除键
        {
            [self.delegate pressKey:@"删除" keyType:LTKeyTypeDelete keyboardType:LTKeyboardTypeLetter];
        }
            break;
        case 30:    //大小写切换
        {
            _isUp = !_isUp;
            
            [self switchUpLowCase:_isUp];
            
            [sender setBackgroundImage:[[UIImage imageNamed:_isUp ? kUpLowSwitchKeySelectImageName : kUpLowSwitchKeyNormalImageName] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            
            [self.delegate pressKey:@"大小写" keyType:LTKeyTypeUpLowSwitch keyboardType:LTKeyboardTypeLetter];
        }
            break;
        case 38:    //符号切换
        {
            [self.delegate pressKey:@"符号" keyType:LTKeyTypeSymbolSwitch keyboardType:LTKeyboardTypeLetter];
        }
            break;
        case 39:    //数字切换
        {
            [self.delegate pressKey:@"123" keyType:LTKeyTypeNumberSwitch keyboardType:LTKeyboardTypeLetter];
        }
            break;
        default:
        {
            [self.delegate pressKey:sender.titleLabel.text keyType:LTKeyTypeLetter keyboardType:LTKeyboardTypeLetter];
        }
            break;
    }
    
}

/**
 切换大小写
 
 @param isUp 是否切换大写
 */
- (void)switchUpLowCase:(BOOL)isUp
{
    __block NSMutableArray *titleArray = [NSMutableArray array];
    [self.letterButtonArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *currentTitle = obj.currentTitle.copy;
        NSString *title = isUp ? currentTitle.uppercaseString : currentTitle.lowercaseString;
        [obj setTitle:title forState:UIControlStateNormal];
        [titleArray addObject:title];
    }];
    self.normalLetterArray = titleArray.copy;
}

- (UIButton *)keyboardButtonWithLocation:(CGPoint)location
{
    for (UIButton *btn in _buttonArray)
    {
        if (CGRectContainsPoint(btn.frame, location))
        {
            // 过滤
            if (btn.tag == 29 || btn.tag == 30 || btn.tag == 38 || btn.tag == 39) return nil;
            
            return btn;
        }
    }
    return nil;
}

- (void)randomKeyBoard
{
    [super randomKeyBoard];
    
    NSArray *numberTitleArray = self.isRandom ? self.randomNumberArray : self.normalNumberArray;
    NSArray *letterTitleArray = self.isRandom ? self.randomLetterArray : self.normalLetterArray;
    
    [self randomKeyBoardWithButtonArray:self.numberButtonArray titleArray:numberTitleArray];
    [self randomKeyBoardWithButtonArray:self.letterButtonArray titleArray:letterTitleArray];
}

- (void)randomKeyBoardWithButtonArray:(NSArray <UIButton *> *)buttonArray titleArray:(NSArray <NSString *> *)titleArray
{
    NSAssert(buttonArray.count == titleArray.count, @"传入的按钮数字跟title数组数量不相等");
    NSUInteger count = titleArray.count;
    for (int i = 0; i < count; i++)
    {
        UIButton *button = buttonArray[i];
        NSString *number = titleArray[i];
        [button setTitle:number forState:UIControlStateNormal];
    }
}

#pragma mark - setter and getter
- (LTKeyboardType)keyboardType
{
    return LTKeyboardTypeLetter;
}

- (NSArray *)randomLetterArray
{
    return [self.normalLetterArray randomArray];
}

- (NSArray *)randomNumberArray
{
    return [self.normalNumberArray randomArray];
}

@end
