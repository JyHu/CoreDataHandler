//
//  NSString+AUUHelper.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AUUHelper)

/**
 *  @author JyHu, 16-03-11 17:03:53
 *
 *  属性的类型名，主要是为了截取property_t中attributes的属性名称
 *
 *  eg:
 *      存储在coredata中得数据如果是基本数据类型的话，在用运行时去获取属性的时候，获取到的attributes是下面这种
 *      T@"NSNumber",&,D,N
 *      这时候这个方法截取到的结果就是 NSNumber 字符串
 *
 *  @return 属性名称
 *
 *  @since v1.0
 */
- (NSString *)propertyAttributeTypeName;

/**
 *  @author JyHu, 16-03-11 17:03:09
 *
 *  根据coredata中存在的数据类型来判断是否含有Entity属性
 *
 *  @return Entity属性的名称
 *
 *  @since v1.0
 */
- (NSString *)containedEntityAttributeTypeName;

@end
