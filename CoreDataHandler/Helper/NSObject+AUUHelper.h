//
//  NSObject+AUUHelper.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "AUUInsertOrUpdateOperation.h"

@interface NSObject (AUUHelper)

/**
 根据property_t，取出数据类型
 
 @param property_t property_t
 @return 数据类型，如NSArray， B， I， NSSet 等
 */
- (NSString *)attributeTypeOfProperty_t:(objc_property_t)property_t;

/**
 将model转换成对应的entity

 @return 返回转换后的entity
 */
- (id)assignToEntity:(NSManagedObject *)entity managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                        primaryKeyGenerateBlock:(AUUPrimeValueGenerateBlock)generateBlock;

/**
 *  @author JyHu, 16-03-12 12:03:44
 *
 *  生成一个32位随机的字符串
 *
 *      eg : 965DD1C9-7C75-466F-9D3B-681F96440A57
 *
 *  @return NSString
 *
 *  @since v1.0
 */
- (NSString *)generateUUIDString;

#pragma mark - 由所有model子类实现的方法

/**
 所对应的Entity实体类的class

 @return Class
 */
- (Class)mapEntityClass;

/**
 主键名

 @return NSString
 */
- (NSString *)primaryKey;

@end
