//
//  LTPasswordKeyboard.m
//  testAPP
//
//  Created by huanyu.li on 2017/9/11.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import "LTPasswordKeyboard.h"

@interface LTPasswordKeyboard ()

/**  正常的数字数组  */
@property (nonatomic, strong) NSArray *normalArray;
/**  乱序的数字数组  */
@property (nonatomic, strong) NSArray *randomArray;
/**  数字按钮数组  */
@property (nonatomic, strong) NSArray<UIButton *> *numberButtonArray;

@end

@implementation LTPasswordKeyboard

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
    
    [numberArray safeChangeObjectIndexFrom:0 toIndex:numberArray.count-1];
    
    _normalArray = numberArray.copy;
    
    _numberButtonArray = [NSMutableArray array];
}

- (void)setupUI
{
    // 隐藏右上角完成按钮
    self.hideTopDoneButton = YES;
    // 添加按钮
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
        UIButton * button = [[UIButton alloc] init];
        
        button.tag = i;
        [button setBackgroundImage:[[UIImage imageNamed:@"shuzibaikuang"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:22.f];
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [btSuperView addSubview:button];
        
        switch (i)
        {
            case 9:
            {
                [button setTitle:@"完成" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:17.f];
            }
                break;
            case 11:
            {
                [button setTitle:@"" forState:UIControlStateNormal];
                [button setBackgroundImage:[[UIImage imageNamed:@"dasahnchu"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
            }
                break;
            default:
            {
                [numberButtonArray addObject:button];
            }
                break;
        }
    }
    
    self.numberButtonArray = numberButtonArray.copy;
    
    [self randomKeyBoard];
    [btSuperView.subviews mas_distributeSudokuViewsWithFixedLineSpacing:5 fixedInteritemSpacing:3 warpCount:3 topSpacing:8 bottomSpacing:8 leadSpacing:8 tailSpacing:8];
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

#pragma mark - 事件处理
- (void)buttonTap:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 9:
        {
            [self.delegate pressKey:@"完成" keyType:LTKeyTypeDone keyboardType:LTKeyboardTypePassword];
        }
            break;
        case 11:
        {
            [self.delegate pressKey:@"删除" keyType:LTKeyTypeDelete keyboardType:LTKeyboardTypePassword];
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

- (NSArray *)randomArray
{
    return [self.normalArray randomArray];
}

- (LTKeyboardType)keyboardType
{
    return LTKeyboardTypePassword;
}

@end
