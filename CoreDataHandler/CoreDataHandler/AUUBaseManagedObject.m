//
//  AUUBaseManagedObject.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUBaseManagedObject.h"
#import <objc/runtime.h>


@implementation AUUBaseManagedObject

- (void)cleanupWithManagedObjectContext:(NSManagedObjectContext *)managedObjectedContext
{
    // 先找一下Entity中关联的有Entity但不是NSSet的属性
    NSString *entityProperty = [self findoutPropertyAttributeNameWithFindType:AUUFindoutTypeEntity];
    
    if (entityProperty)
    {
        id obj = [self valueForKey:entityProperty];
        
        if ([obj isMemberOfClass:[AUUBaseManagedObject class]])
        {
            [obj cleanupWithManagedObjectContext:managedObjectedContext];
            
            [managedObjectedContext deleteObject:obj];
        }
    }
    
    // 然后再找出属性中一对多的属性，即属性类型名为NSSet
    NSString *setProperty = [self findoutPropertyAttributeNameWithFindType:AUUFindoutTypeSet];
    
    if (setProperty)
    {
        // 如果存在的话，就说明当前的Entity存在一对多的关系，循环去删除
        for (AUUBaseManagedObject *obj in [self valueForKey:setProperty])
        {
            [obj cleanupWithManagedObjectContext:managedObjectedContext];
            
            [managedObjectedContext deleteObject:obj];
        }
    }
}


/**
 *  @author JyHu, 16-03-11 13:03:33
 *
 *  将Entity转换成Model，在fetchall的时候使用
 *
 *  @param cls 要转换成的Model的class类型
 *
 *  @return cls对应的Model
 *
 *  @since v1.0
 */
- (id)assignToModelWithClass:(Class)cls
{
    // 初始化一个目标model
    id destinationModel = [[cls alloc] init];
    
    unsigned int properties_count = 0;
    
    objc_property_t *property_ptr = class_copyPropertyList([self class], &properties_count);
    
    // 循环获取并设置当前Entity的属性值到目标model
    for (unsigned int i = 0; i < properties_count; i ++)
    {
        objc_property_t property_t = property_ptr[i];
        
        const char *name = property_getName(property_t);
        
        const char *attributes = property_getAttributes(property_t);
        
        // 存取值时的key
        NSString *propertyAttributeName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        // 当前key所对应的数据类型。
        NSString *propertyAttributeTypeName = [[NSString stringWithCString:attributes encoding:NSUTF8StringEncoding] propertyAttributeTypeName];
        
        // 判断一下取到的属性类型是否是NSObject的子类，避免取值出错造成赋值失败
        if ([NSClassFromString(propertyAttributeTypeName) isSubclassOfClass:[NSObject class]])
        {
            if (![cls whetherContainsAttribute:propertyAttributeName])
            {
                // 如果目标model中不包含当前属性的话，就不需要往下取值与赋值了。
                continue ;
            }
            
            if ([NSClassFromString(propertyAttributeTypeName) isSubclassOfClass:[AUUBaseManagedObject class]])
            {
                // 判断一下是否是AUUBaseManagedObject的子类，如果是的话需要取出Entity然后再次转换并赋值
                [destinationModel setValue:[[self valueForKey:propertyAttributeName] assignToModel] forKey:propertyAttributeName];
            }
            else if ([propertyAttributeTypeName isEqualToString:@"NSSet"])
            {
                // 如果属性的类型是NSSet的话，说明是一对多的关系，需要遍历一下然后转换赋值
                
                
                NSMutableArray *subModels = [[NSMutableArray alloc] init];
                
                for (id subObj in [self valueForKey:propertyAttributeName])
                {
                    if ([subObj respondsToSelector:@selector(assignToModel)])
                    {
                        [subModels addObject:[subObj assignToModel]];
                    }
                }
                
                // 获取当前目标model中一对多用的属性类型是数组还是集合
                NSString *destPropertyAttributeTypeName = [destinationModel findoutAttributeTypeNameWithAttributeName:propertyAttributeName];
                
                if ([destPropertyAttributeTypeName isEqualToString:@"NSArray"])
                {
                    [destinationModel setValue:[NSArray arrayWithArray:subModels] forKey:propertyAttributeName];
                }
                else if ([destPropertyAttributeTypeName isEqualToString:@"NSMutableArray"])
                {
                    [destinationModel setValue:subModels forKey:propertyAttributeName];
                }
                else if ([destPropertyAttributeTypeName isEqualToString:@"NSSet"])
                {
                    [destinationModel setValue:[NSSet setWithArray:subModels] forKey:propertyAttributeName];
                }
                else if ([destPropertyAttributeTypeName isEqualToString:@"NSMutableSet"])
                {
                    [destinationModel setValue:[NSMutableSet setWithArray:subModels] forKey:propertyAttributeName];
                }
            }
            else
            {
                // 过滤了以上的几种情况，剩下的就是简单的数据类型了，可以直接赋值
                [destinationModel setValue:[self valueForKey:propertyAttributeName] forKey:propertyAttributeName];
            }
        }
        else
        {
            // 取出数据类型失败
            NSLog(@"取出数据类型失败");
        }
    }
    
    return destinationModel;
}

- (id)assignToModel { return nil; }

@end





