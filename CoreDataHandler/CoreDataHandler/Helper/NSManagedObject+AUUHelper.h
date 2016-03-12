//
//  NSManagedObject+AUUHelper.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSObject+AUUHelper.h"

@interface NSManagedObject (AUUHelper)

/**
 *  @author JyHu, 16-03-11 13:03:28
 *
 *  清空coredata中当前数据模型下的所有数据
 *
 *  @param managedObjectedContext <#managedObjectedContext description#>
 *
 *  @since v1.0
 */
- (void)cleanupWithManagedObjectContext:(NSManagedObjectContext *)managedObjectedContext
                ignoreAttributeTypeName:(NSString *)attributeTypeName;

/**
 *  @author JyHu, 16-03-11 13:03:04
 *
 *  将Entity转换成目标model
 *
 *  如果子类Entity含有其他的Entity作为属性的数据类型的话，必须重写的方法
 *  如果是一对多中的“多”里面包含的“一”的Entity就不需要重写了。
 *
 *  @return return value description
 *
 *  @since v1.0
 */
- (id)assignToModel;

/**
 *  @author JyHu, 16-03-11 13:03:32
 *
 *  相当于是半私有方法，在子类重写 assignToModel 方法的时候使用
 *
 *  @param cls 目标model的class类型
 *
 *  @return 填充完数据的model
 *
 *  @since v1.0
 */
- (id)assignToModelWithClass:(Class)cls;

@end
