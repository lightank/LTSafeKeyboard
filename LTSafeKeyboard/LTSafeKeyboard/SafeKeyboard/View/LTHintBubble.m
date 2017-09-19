//
//  LTHintBubble.m
//  testAPP
//
//  Created by huanyu.li on 2017/9/12.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import "LTHintBubble.h"
#import "SafeKeyboardDefine.h"
#import "Masonry.h"

@interface LTHintBubble ()

/** 背景图 **/
@property (nonatomic, strong) UIImageView *imgageView;

/** 文字标签 **/
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation LTHintBubble

#pragma mark - =============生命周期================

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBubbleUI];
    }
    return self;
}

- (void)setBubbleUI
{
    //------  添加背景和文字  ------//
    [self addSubview:self.imgageView];
    [self addSubview:self.titleLabel];
    
    [_imgageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_offset(0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_offset(8);
    }];
}

/**
 显示气泡
 
 @param button 按钮
 */
- (void)showFromButton:(UIButton *)button
{
    NSInteger tag = button.tag;
    self.titleLabel.text = button.currentTitle;
    
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    
    CGFloat popViewW = AUTO_ADAPT_SIZE_VALUE(72, 82, 88);
    CGFloat popViewH = AUTO_ADAPT_SIZE_VALUE(100, 108, 118);
    CGFloat popViewX = 0;
    
    CGFloat popViewY = btnFrame.origin.y - (popViewH - btnFrame.size.height);

    if (tag == 0 || tag == 10 || tag == 20)
    {
        // 按钮在左边的情形
        self.imgageView.image = [UIImage imageNamed:@"keyboard_pop_left"];
        popViewX = btnFrame.origin.x - AUTO_ADAPT_SIZE_VALUE(4, 4, 4);
    }
    else if (tag == 9 || tag == 19 || tag == 38)
    {
        // 按钮在右边的情形
        self.imgageView.image = [UIImage imageNamed:@"keyboard_pop_right"];
        popViewX = btnFrame.origin.x + btnFrame.size.width - AUTO_ADAPT_SIZE_VALUE(69, 79, 85);
        
    }
    else
    {
        // 按钮在中间部分
        self.imgageView.image = [UIImage imageNamed:@"keyboard_pop"];
        popViewX = btnFrame.origin.x - (popViewW - btnFrame.size.width) * 0.5;
    }
    
    CGRect frame = CGRectMake(popViewX, popViewY, popViewW, popViewH);
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    self.frame = frame;
    [window addSubview:self];
}

/**
 显示气泡
 
 @param button 按钮
 @param superView 相对位置父视图
 */
- (void)showFromButton:(UIButton *)button toSuperView:(UIView *)superView
{
    self.titleLabel.text = button.currentTitle;
    
    CGRect btnFrame = [button convertRect:button.bounds toView:superView];
    
    CGFloat popViewW = AUTO_ADAPT_SIZE_VALUE(72, 82, 88);
    CGFloat popViewH = AUTO_ADAPT_SIZE_VALUE(100, 108, 118);
    CGFloat popViewX = 0;
    
    CGFloat popViewY = btnFrame.origin.y - (popViewH - btnFrame.size.height);
    if ([button.currentTitle.lowercaseString isEqualToString:@"q"] ||
        [button.currentTitle isEqualToString:@"1"] ||
        [button.currentTitle isEqualToString:@"a"] ||
        [button.currentTitle isEqualToString:@"~"] ||
        [button.currentTitle isEqualToString:@"("] ||
        [button.currentTitle isEqualToString:@"|"] )
    {
        // 按钮在左边的情形
        self.imgageView.image = [UIImage imageNamed:@"keyboard_pop_left"];
        popViewX = btnFrame.origin.x - AUTO_ADAPT_SIZE_VALUE(4, 4, 4);
    }
    else if ([button.currentTitle.lowercaseString isEqualToString:@"p"] ||
             [button.currentTitle isEqualToString:@"0"] ||
             [button.currentTitle isEqualToString:@"*"] ||
             [button.currentTitle isEqualToString:@"]"] ||
             [button.currentTitle isEqualToString:@"¥"])
    {
        // 按钮在右边的情形
        self.imgageView.image = [UIImage imageNamed:@"keyboard_pop_right"];
        popViewX = btnFrame.origin.x + btnFrame.size.width - AUTO_ADAPT_SIZE_VALUE(69, 79, 85);
        
    }
    else
    {
        // 按钮在中间部分
        self.imgageView.image = [UIImage imageNamed:@"keyboard_pop"];
        popViewX = btnFrame.origin.x - (popViewW - btnFrame.size.width) * 0.5;
    }
    
    CGRect frame = CGRectMake(popViewX, popViewY, popViewW, popViewH);
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    self.frame = frame;
    [window addSubview:self];
}

#pragma mark - setter and getter
- (UIImageView *)imgageView
{
    if (!_imgageView)
    {
        _imgageView = [[UIImageView alloc] init];
    }
    return _imgageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:30.f];
    }
    return _titleLabel;
}

@end
