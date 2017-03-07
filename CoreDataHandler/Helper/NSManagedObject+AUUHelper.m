//
//  NSManagedObject+AUUHelper.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "NSManagedObject+AUUHelper.h"
#import <objc/runtime.h>
#import "NSObject+AUUHelper.h"
#import "AUUMacros.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation NSManagedObject (AUUHelper)

- (void)cleanupWithManagedObjectContext:(NSManagedObjectContext *)managedObjectedContext
{
    AUUDebugLog(@"正在清理实体类对象 %@", self);
    
    unsigned int properties_count = 0;
    
    /*
     
     递归去删除 coredata 中的Entity
     
     先取出当前Entity的所有属性
        -->如果是当前属性值还是Entity，则递归去删除它
        -->如果当前属性值是一个集合，则递归它里面的所有元素，删除
     
     遍历属性的原因是因为，如果一个Entity A下面有个是集合类型，如果我直接删除A，那么A下所有的数据都还会存在，这就是一个bug。
                如果A下得有个Entity B类型，如果我删除A的话，B还会存在，这也是bug。
     所以需要便利所有的Entity属性，直到某个Entity所有的属性都不是集合或者Entity的时候，出了for就删除当前的entity，
     然后递归往回退一层
     
     */
    
    objc_property_t *property_ptr = class_copyPropertyList([self class], &properties_count);
    
    
    for (unsigned int i = 0; i < properties_count; i ++)
    {
        objc_property_t property_t = property_ptr[i];
                
        NSString *attributeName = [NSString stringWithUTF8String:property_getName(property_t)];
        
        NSString *attributeType = [self attributeTypeOfProperty_t:property_t];
        
        if (attributeType && attributeType.length > 0)
        {
            // 如果是集合类型，就继续遍历去删除
            if ([NSClassFromString(attributeType) isSubclassOfClass:[NSSet class]])
            {
                AUUDebugLog(@"在清理的实体类%@中存在一对多的属性，循环清理中", NSStringFromClass([self class]));
                
                // 如果存在的话，就说明当前的Entity存在一对多的关系，循环去删除
                for (NSManagedObject *obj in [self valueForKey:attributeName])
                {
                    [obj cleanupWithManagedObjectContext:managedObjectedContext];
                }
            }
            // 如果是Entity类型的话，就遍历它的属性，然后删除
            else if ([NSClassFromString(attributeType) isSubclassOfClass:[NSManagedObject class]])
            {
                id obj = [self valueForKey:attributeName];
                
                AUUDebugLog(@"在清理的对象%@中有是Entity(%@)的属性%@", NSStringFromClass([self class]), NSStringFromClass([obj class]), attributeName);
                
                [obj cleanupWithManagedObjectContext:managedObjectedContext];
            }
        }
    }
    
    [managedObjectedContext deleteObject:self];
    free(property_ptr);
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
- (id)assignToModel
{
    Class cls = [self mapModelClass];
    // 初始化一个目标model
    id destinationModel = [[cls alloc] init];
    
    unsigned int properties_count = 0;
    
    objc_property_t *property_ptr = class_copyPropertyList([self class], &properties_count);
    
    // 循环获取并设置当前Entity的属性值到目标model
    for (unsigned int i = 0; i < properties_count; i ++)
    {
        objc_property_t property_t = property_ptr[i];
        
        const char *name = property_getName(property_t);
        
        // 存取值时的key
        NSString *propertyAttributeName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        // entity当前属性值
        id currentEntityValue = [self valueForKey:propertyAttributeName];
        
        if (currentEntityValue)
        {
            // 当前key所对应的数据类型。
            NSString *propertyAttributeTypeName = [self attributeTypeOfProperty_t:property_t];
            
            // 判断一下取到的属性类型是否是NSObject的子类，避免取值出错造成赋值失败
            if (propertyAttributeName && [NSClassFromString(propertyAttributeTypeName) isSubclassOfClass:[NSObject class]])
            {
                if (class_getProperty(cls, [propertyAttributeName UTF8String]) == NULL)
                {
                    // 如果目标model中不包含当前属性的话，就不需要往下取值与赋值了。
                    continue ;
                }
                
                if ([NSClassFromString(propertyAttributeTypeName) isSubclassOfClass:[NSManagedObject class]])
                {
                    // 判断一下是否是AUUBaseManagedObject的子类，如果是的话需要取出Entity然后再次转换并赋值
                    [destinationModel setValue:[[self valueForKey:propertyAttributeName] assignToModel]
                                        forKey:propertyAttributeName];
                }
                else if ([NSClassFromString(propertyAttributeTypeName) isSubclassOfClass:[NSSet class]])
                {
                    // 如果属性的类型是NSSet的话，说明是一对多的关系，需要遍历一下然后转换赋值
                    
                    
                    NSMutableArray *subModels = [[NSMutableArray alloc] init];
                    
                    for (NSManagedObject *subObj in [self valueForKey:propertyAttributeName])
                    {
                        if ([subObj respondsToSelector:@selector(assignToModel)])
                        {
                            [subModels addObject:[subObj assignToModel]];
                        }
                    }
                    
                    // 获取当前目标model中一对多用的属性类型是数组还是集合
                    objc_property_t dest_property_t = class_getProperty([destinationModel class], [propertyAttributeName UTF8String]);
                    NSString *destPropertyAttributeTypeName = [destinationModel attributeTypeOfProperty_t:dest_property_t];
                    
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
                // 取出数据失败
                AUUDebugLog(@"取出数据失败");
            }
        }
        
    }
    
    property_ptr = NULL;
    
    return destinationModel;
}

@end


#pragma clang diagnostic pop
