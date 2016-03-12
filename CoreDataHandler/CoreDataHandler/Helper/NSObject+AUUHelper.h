//
//  NSObject+AUUHelper.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+AUUHelper.h"
#import "AUUMacros.h"

typedef NS_ENUM(NSUInteger, AUUFindoutType) {
    AUUFindoutTypeSet,
    AUUFindoutTypeEntity
};

@interface NSObject (AUUHelper)

/**
 *  @author JyHu, 16-03-11 17:03:07
 *
 *  根据查找类型查找property的属性名称（propertyAttributeName）
 *
 *  @param type AUUFindoutType
 *
 *  eg：
 *      @property (retain, nonatomic) NSString *username;
 *      根据查找结果会返回 username
 *
 *
 *  @return 查找到的propertyAttributeName
 *
 *  @since v1.0
 */
- (NSString *)findoutPropertyAttributeNameWithFindType:(AUUFindoutType)type;

/**
 *  @author JyHu, 16-03-11 17:03:28
 *
 *  根据属性名查找属性类型名
 *
 *  @param name 属性名称
 *
 *  eg：
 *      @property (retain, nonatomic) NSString *username;
 *      查询的时候，根据username查找它的数据类型，即NSString
 *
 *  @return 属性的类型名
 *
 *  @since v1.0
 */
- (NSString *)findoutAttributeTypeNameWithAttributeName:(NSString *)name;

/**
 *  @author JyHu, 16-03-11 17:03:22
 *
 *  是否包含有某个属性
 *
 *  @param attribtue 要判断的属性
 *
 *  @return BOOL
 *
 *  @since v1.0
 */
+ (BOOL)whetherContainsAttribute:(NSString *)attribtue;

@end
