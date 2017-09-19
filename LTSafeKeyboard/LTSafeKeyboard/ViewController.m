//
//  ViewController.m
//  LTSafeKeyboard
//
//  Created by huanyu.li on 2017/9/19.
//  Copyright © 2017年 lightank. All rights reserved.
//

#import "ViewController.h"
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "LTSafeKeyboard.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
}

- (void)setupUI
{
    __block NSMutableArray<UIView *> *viewArray = [NSMutableArray array];
    NSArray *title = @[@"这是第一个", @"这是第二个"];
    
    NSInteger count = title.count;
    
    //UITextField
    for (int i = 0; i < count; i++)
    {
        UITextField *textField = [[UITextField alloc] init];
        textField.userInteractionEnabled = YES;
        textField.placeholder = [NSString stringWithFormat:@"UITextField:%@", title[i]];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [viewArray addObject:textField];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        textField.secureTextEntry = YES;
        
        if (i == 0)
        {
            LTSafeKeyboard *keyboard = [LTSafeKeyboard focusOnTextFiled:textField keyboardType:LTKeyboardTypeLetter];
            keyboard.showHintBubble = YES;
        }
        else
        {
            [LTSafeKeyboard focusOnTextFiled:textField keyboardType:LTKeyboardTypeLetter].random = YES;
        }
    }
    
    //UITextView
    for (int i = 0; i < count; i++)
    {
        UITextView *textView = [[UITextView alloc] init];
        textView.text = [NSString stringWithFormat:@"UITextView:%@", title[i]];
        [viewArray addObject:textView];
        textView.secureTextEntry = YES;
        
        if (i == 0)
        {
            LTSafeKeyboard *keyboard = [LTSafeKeyboard focusOnTextView:textView keyboardType:LTKeyboardTypeLetter];
            keyboard.showHintBubble = YES;
        }
        else
        {
            [LTSafeKeyboard focusOnTextView:textView keyboardType:LTKeyboardTypeLetter].random = YES;
        }
    }
    
    [viewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.view addSubview:obj];
        obj.layer.borderColor = [UIColor blackColor].CGColor;
        obj.layer.borderWidth = 2.f;
        obj.layer.cornerRadius = 2.f;
        obj.layer.masksToBounds = YES;
    }];
    
    [viewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0)
        {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.width.equalTo(self.view);
                make.top.equalTo(self.view).offset(66.f);
                make.height.equalTo(44.f);
            }];
        }
        else
        {
            UIView *view = viewArray[idx - 1];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view.mas_bottom);
                make.left.right.width.equalTo(self.view);
                make.height.equalTo(44.f);
            }];
        }
    }];
}

@end
