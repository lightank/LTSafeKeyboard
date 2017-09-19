//
//  NSMutableArray+LTAdd.h
//  testAPP
//
//  Created by huanyu.li on 2017/9/12.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray<ObjectType> (LTAdd)

/**
 安全插入一个元素,如果index超过count(系统的:如果index是count的话会把元素放到最后一位),那么将会将元素添加到最后一个

 @param anObject 被插入的元素
 @param index 插入元素后元素所处的位置
 */
- (void)safeInsertObject:(ObjectType)anObject atIndex:(NSUInteger)index;

/**
 安全的改变元素的index,任一超过元素(count - 1)的index,将会修正为(count - 1)

 @param idx1 原始index,交换前元素index
 @param idx2 目标index,交换后元素index
 */
- (void)safeChangeObjectIndexFrom:(NSUInteger)idx1 toIndex:(NSUInteger)idx2;

@end
