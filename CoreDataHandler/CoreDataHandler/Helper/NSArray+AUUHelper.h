//
//  NSArray+AUUHelper.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/12.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (AUUHelper)

/**
 *  @author JyHu, 16-03-12 22:03:29
 *
 *  将Entities中存在一对多关系的Relationship转换为Model数组的方法
 *
 *  @return 转换后的model数组
 *
 *  @since v1.0
 */
- (NSMutableArray *)convertEntitiesToModels;

@end
