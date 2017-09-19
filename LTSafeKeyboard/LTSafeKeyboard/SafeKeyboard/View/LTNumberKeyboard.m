//
//  LTNumberKeyboard.m
//  testAPP
//
//  Created by huanyu.li on 2017/9/11.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import "LTNumberKeyboard.h"

@interface LTNumberKeyboard ()

/**  正常的数字数组  */
@property (nonatomic, strong) NSArray *normalArray;
/**  乱序的数字数组  */
@property (nonatomic, strong) NSArray *randomArray;
/**  数字按钮数组  */
@property (nonatomic, strong) NSArray<UIButton *> *numberButtonArray;

@end

@implementation LTNumberKeyboard

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
    NSUInteger count = 10;
    NSMutableArray *numberArray = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++)
    {
        [numberArray addObject:NSStringFromValue(i)];
    }

    [numberArray safeChangeObjectIndexFrom:0 toIndex:numberArray.count - 1];
    
    _normalArray = numberArray.copy;
}

- (void)setupUI
{
    [self creatButtons];
}

- (void)creatButtons
{
    // 添加按钮父视图
    UIView * btSuperView = [[UIView alloc] init];
    [self addSubview:btSuperView];
    
    [btSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.mas_offset(kLogoViewHeight);
    }];
    
    NSMutableArray *numberButtonArray = [NSMutableArray array];

    
    // 添加按钮
    for (int i = 0 ; i < 12; i++)
    {
        if (i != 9)
        {
            UIButton * button = [[UIButton alloc] init];
            button.tag = i > 9 ? i + 1 : i;
            [button setBackgroundImage:[[UIImage imageNamed:@"shuzibaikuang"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = UIFontWithNameAndSize(KRFONTNAME,22);
            [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
            [btSuperView addSubview:button];
            
            switch (i)
            {
                case 11:
                {
                    [button setTitle:@"" forState:UIControlStateNormal];
                    [button setBackgroundImage:[[UIImage imageNamed:@"dasahnchu"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
                    
                    self.deleteKey = button;
                }
                    break;
                default:
                {
                    [numberButtonArray addObject:button];
                }
                    break;
            }
        }
        else
        {
            // 创建2个按钮
            UIView *tempSuperView = [[UIButton alloc] init];
            [btSuperView addSubview:tempSuperView];
            
            // 符号按钮
            UIButton *symbolSwitchButton = [[UIButton alloc] init];
            symbolSwitchButton.tag = i;
            [symbolSwitchButton setBackgroundImage:[[UIImage imageNamed:@"shuzibaikuang"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            [symbolSwitchButton setTitle:@"符" forState:UIControlStateNormal];
            [symbolSwitchButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            symbolSwitchButton.titleLabel.font = UIFontWithNameAndSize(KRFONTNAME,17);
            [symbolSwitchButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
            [tempSuperView addSubview:symbolSwitchButton];
            
            // 字母按钮
            UIButton *letterSwitchButton = [[UIButton alloc] init];
            letterSwitchButton.tag = i + 1;
            [letterSwitchButton setBackgroundImage:[[UIImage imageNamed:@"shuzibaikuang"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            [letterSwitchButton setTitle:@"abc" forState:UIControlStateNormal];
            [letterSwitchButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            letterSwitchButton.titleLabel.font = UIFontWithNameAndSize(KRFONTNAME,17);
            [letterSwitchButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
            [tempSuperView addSubview:letterSwitchButton];
            
            [tempSuperView.subviews mas_distributeSudokuViewsWithFixedLineSpacing:5 fixedInteritemSpacing:5 warpCount:2 topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
        }
    }
    
    self.numberButtonArray = numberButtonArray.copy;
    
    [btSuperView.subviews mas_distributeSudokuViewsWithFixedLineSpacing:5 fixedInteritemSpacing:3 warpCount:3 topSpacing:8 bottomSpacing:8 leadSpacing:8 tailSpacing:8];
}

#pragma mark - 事件处理
/**  按钮点击事件  */
- (void)buttonTap:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 9:
        {
            [self.delegate pressKey:@"符号" keyType:LTKeyTypeSymbolSwitch keyboardType:LTKeyboardTypeNumber];
        }
            break;
        case 10:
        {
            [self.delegate pressKey:@"字母" keyType:LTKeyTypeLetterSwitch keyboardType:LTKeyboardTypeNumber];
        }
            break;
        case 12:
        {
            [self.delegate pressKey:@"删除" keyType:LTKeyTypeDelete keyboardType:LTKeyboardTypeNumber];
        }
            break;
        default:
        {
            if (sender.titleLabel.text.length > 0 && isdigit([sender.titleLabel.text characterAtIndex:0]) != 0)
            {
                [self.delegate pressKey:sender.titleLabel.text keyType:LTKeyTypeNumber keyboardType:LTKeyboardTypePassword];
            }
        }
            break;
    }
}

- (void)randomKeyBoard
{
    [super randomKeyBoard];
    
    NSUInteger count = self.numberButtonArray.count;
    NSArray *numberArray = self.isRandom ? self.randomArray : self.normalArray;
    for (int i = 0; i < count; i++)
    {
        UIButton *button = self.numberButtonArray[i];
        NSString *number = numberArray[i];
        [button setTitle:number forState:UIControlStateNormal];
    }
}

#pragma mark - setter and getter
- (NSArray *)randomArray
{
    return [self.normalArray randomArray];
}

- (LTKeyboardType)keyboardType
{
    return LTKeyboardTypeNumber;
}

@end
