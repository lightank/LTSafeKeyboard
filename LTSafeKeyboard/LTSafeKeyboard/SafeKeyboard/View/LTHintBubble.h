//
//  LTHintBubble.h
//  testAPP
//
//  Created by huanyu.li on 2017/9/12.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>
#

@interface LTHintBubble : UIView

/**
 显示气泡
 
 @param button 按钮
 */
- (void)showFromButton:(UIButton *)button;

/**
 显示气泡
 
 @param button 按钮
 @param superView 相对位置父视图
 */
- (void)showFromButton:(UIButton *)button toSuperView:(UIView *)superView;


@end
