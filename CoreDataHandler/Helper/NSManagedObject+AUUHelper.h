//
//  NSManagedObject+AUUHelper.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (AUUHelper)

/**
 *  @author JyHu, 16-03-12 22:03:38
 *
 *  清空coredata中当前数据模型下的所有数据
 *
 *  @param managedObjectedContext 上下文
 *  @param attributeTypeName      当前Entity的Class名
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
 Entity对应的Model的class

 @return Class
 */
- (Class)mapModelClass;

@end



/*
 
 property           attribute type
 
 t_int16            T@"NSNumber",&,D,N
 t_int32            T@"NSNumber",&,D,N
 t_int64            T@"NSNumber",&,D,N
 t_decimal          T@"NSDecimalNumber",&,D,N
 t_double           T@"NSNumber",&,D,N
 t_float            T@"NSNumber",&,D,N
 t_string           T@"NSString",&,D,N
 t_bool             T@"NSNumber",&,D,N
 t_date             T@"NSDate",&,D,N
 t_binary           T@"NSData",&,D,N
 t_transformable    T@,&,D,N
 password_ship      T@"PWDDetailEntity",&,D,N
 history_ship       T@"PWDHistoryEntity",&,D,N
 
 */

// 在CoreData中得Entity所有的OC类型的数据类型只有以下几个
//NSArray *coredataOriginalAttribtues = @[@"NSNumber",
//                                        @"NSDecimalNumber",
//                                        @"NSString",
//                                        @"NSDate",
//                                        @"NSData",
//                                        @"NSSet"];
