//
//  LTSymbolKeyboard.m
//  testAPP
//
//  Created by huanyu.li on 2017/9/11.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import "LTSymbolKeyboard.h"
#import "LTHintBubble.h"

#define FIXEDLINESPACING 5 // 行间距
#define FIXEDINTERITEMSPACING 2 // 列间距
#define WARPCOUNT 10 // 折行点
#define TOPSPACING 8 // 顶间距
#define BOTTOMSPACING 8 // 底间距
#define LEADSPACING 8 // 左间距
#define TAILSPACING 8 // 右间距
#define ITEM_HEIGHT(f) ((KRKEYBOARDHEIGHT-(((f)-1)*FIXEDLINESPACING)-BOTTOMSPACING-TOPSPACING-KRLOGOVIEW_HEIGHT)/(f))
#define ITEM_WIDTH ((kScreenWidth-(((WARPCOUNT-1)*FIXEDINTERITEMSPACING)+LEADSPACING+TAILSPACING))/WARPCOUNT)

@interface LTSymbolKeyboard ()

/**  放按钮的父控件  */
@property (nonatomic, strong) UIView *buttonSuperView;
/** 标识触摸最后的按钮 **/
@property (nonatomic, strong) UIButton *lastButton;
/** 按钮数组 **/
@property (nonatomic, strong) NSArray<UIButton *> *buttonArray;

/**  正常的符号数组  */
@property (nonatomic, strong) NSArray *normalArray;
/**  乱序的符号数组  */
@property (nonatomic, strong) NSArray *randomArray;
/** 符号按钮数组 **/
@property (nonatomic, strong) NSArray<UIButton *> *symbolButtonArray;

@end

@implementation LTSymbolKeyboard

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

//初始化UI
- (void)setupUI
{
    // 添加按钮
    [self creatButtons];
}

- (void)creatButtons
{
    //------  添加按钮父视图  ------//
    _buttonSuperView = [[UIView alloc] init];
    [self addSubview:_buttonSuperView];
    
    [_buttonSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.mas_offset(kLogoViewHeight);
    }];
    
    NSMutableArray *buttonArray = [NSMutableArray array];
    NSMutableArray *symbolButtonArray = [NSMutableArray array];
    NSMutableArray *normalArray = [NSMutableArray array];
    
    NSString *str = @"~ ` ! @ # $ % ^ & * ( ) _ - + = { } [ ] | \\ : ; “ ‘ < , > back 123 abc ? . space / € ￡ ¥";
    NSArray *symbolArray = [str componentsSeparatedByString:@" "];
    //------  添加按钮  ------//
    for (int i = 0; i < symbolArray.count; i++)
    {
        UIButton * button = [[UIButton alloc] init];
        button.tag = i;
        [button setBackgroundImage:[[UIImage imageNamed:kKeyBackgroundImageName] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [button setTitle:symbolArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = UIFontWithNameAndSize(KRFONTNAME,22);
        button.enabled = NO;
        
        switch (i)
        {
            case 29:    //删除按钮
            {
                [button setTitle:@"" forState:UIControlStateNormal];
                [button setBackgroundImage:[[UIImage imageNamed:kDeleteKeyImageName] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
                
                self.deleteKey = button;
            }
                break;
            case 30:    //切换数字键盘
            case 31:    //切换字母
            {
                button.titleLabel.font = UIFontWithNameAndSize(KRFONTNAME,16);
            }
                break;
            case 34:    //空格
            {
                [button setTitle:@"" forState:UIControlStateNormal];
                [button setBackgroundImage:[[UIImage imageNamed:kSpaceKeyImageName] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            }
                break;
            default:
            {
                [normalArray addObject:symbolArray[i]];
                [symbolButtonArray addObject:button];
            }
                break;
        }
        
        // 启用点击事件
        if (i == 29 || i == 30 || i == 31 || i == 34)
        {
            [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
            button.enabled = YES;
        }
        
        // 添加到父视图
        if (i < 34)
        {
            [_buttonSuperView addSubview:button];
        }
        
        // 添加到数组
        [buttonArray addObject:button];
    }
    
    self.normalArray = normalArray.copy;
    self.symbolButtonArray = symbolButtonArray.copy;
    self.buttonArray = buttonArray.copy;
    
    [_buttonSuperView.subviews mas_distributeSudokuViewsWithFixedLineSpacing:FIXEDLINESPACING fixedInteritemSpacing:FIXEDINTERITEMSPACING warpCount:WARPCOUNT topSpacing:TOPSPACING bottomSpacing:BOTTOMSPACING leadSpacing:LEADSPACING tailSpacing:TAILSPACING];
    
    //------  添加最后5个按钮约束  ------//
    UIButton * referenceBt = _buttonArray[33];
    UIButton * preBt;
    
    for (NSInteger i = _buttonArray.count - 1; i >= 34; i--)
    {
        UIButton * currentBt = _buttonArray[i];
        [_buttonSuperView addSubview:currentBt];
        
        if (i == _buttonArray.count - 1)
        {
            // 最后按钮
            [currentBt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(referenceBt);
                make.right.mas_offset(-TAILSPACING);
                make.width.mas_equalTo(ITEM_WIDTH);
            }];
        }
        else if (i == 34)
        {
            // 空格按钮
            [currentBt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(referenceBt.mas_right).mas_offset(FIXEDINTERITEMSPACING);
                make.top.bottom.mas_equalTo(referenceBt);
                make.right.mas_equalTo(preBt.mas_left).mas_offset(-FIXEDINTERITEMSPACING);
            }];
        }
        else
        {
            // 中间按钮
            [currentBt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(preBt.mas_left).mas_offset(-FIXEDINTERITEMSPACING);
                make.top.bottom.mas_equalTo(referenceBt);
                make.width.mas_equalTo(ITEM_WIDTH);
            }];
        }
        
        preBt = currentBt;
    }
}

#pragma mark - 事件处理
- (void)buttonTap:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 29:    //删除按钮
        {
            [self.delegate pressKey:@"删除" keyType:LTKeyTypeDelete keyboardType:LTKeyboardTypeSymbol];
        }
            break;
        case 30:    //切换数字键盘
        {
            [self.delegate pressKey:@"数字" keyType:LTKeyTypeNumberSwitch keyboardType:LTKeyboardTypeSymbol];
        }
            break;
        case 31:    //切换字母
        {
            [self.delegate pressKey:@"字母" keyType:LTKeyTypeLetterSwitch keyboardType:LTKeyboardTypeSymbol];
        }
            break;
        case 34:    //空格
        {
            [self.delegate pressKey:@" " keyType:LTKeyTypeSymbol keyboardType:LTKeyboardTypeSymbol];
        }
            break;
        default:
        {
            [self.delegate pressKey:sender.titleLabel.text keyType:LTKeyTypeSymbol keyboardType:LTKeyboardTypeSymbol];
        }
            break;
    }
}

/**  获取当前按钮  */
- (UIButton *)keyboardButtonWithLocation:(CGPoint)location
{
    for (UIButton *btn in _buttonArray)
    {
        if (CGRectContainsPoint(btn.frame, location))
        {
            // 过滤
            if (btn.tag == 29 || btn.tag == 30 || btn.tag == 31 || btn.tag == 34) return nil;
            return btn;
        }
    }

    return nil;
}

- (void)randomKeyBoard
{
    [super randomKeyBoard];

    NSUInteger count = self.symbolButtonArray.count;
    NSArray *numberArray = self.isRandom ? self.randomArray : self.normalArray;
    for (int i = 0; i < count; i++)
    {
        UIButton *button = self.symbolButtonArray[i];
        NSString *number = numberArray[i];
        [button setTitle:number forState:UIControlStateNormal];
    }
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
    if (touch.view != self.buttonSuperView) return;

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
    if (touch.view != self.buttonSuperView) return;

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

#pragma mark - setter and getter
- (NSArray *)randomArray
{
    return [self.normalArray randomArray];
}

- (LTKeyboardType)keyboardType
{
    return LTKeyboardTypeSymbol;
}


@end
