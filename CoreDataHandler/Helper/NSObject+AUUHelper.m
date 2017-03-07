//
//  NSObject+AUUHelper.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "NSObject+AUUHelper.h"
#import "AUUMacros.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation NSObject (AUUHelper)

- (id)assignToEntity:(NSManagedObject *)entity managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                primaryKeyGenerateBlock:(AUUPrimeValueGenerateBlock)generateBlock
{
    unsigned int property_count = 0;
    
    objc_property_t *property_ptr = class_copyPropertyList([self class], &property_count);
    
    for (unsigned int i = 0; i < property_count; i ++)
    {
        objc_property_t property_t = property_ptr[i];
        NSString *propertyAttributeName = [NSString stringWithUTF8String:property_getName(property_t)];     // 当前属性的名称
        
        // 当前model的属性值
        id curValue = [self valueForKey:propertyAttributeName];
        
        // 当前model的主键
        NSString *curPrimaryKey = [self primaryKey];
        
        // 如果存在主键并且当前的属性刚好是主键
        if (curPrimaryKey && [curPrimaryKey isEqualToString:propertyAttributeName])
        {
            // 拿出model主键的值
            id value = [self valueForKey:curPrimaryKey];
            
            // 如果存在主键的值，则直接赋值给当前的entity，这个主键以外部改动的为主
            if (value)
            {
                [entity setValue:value forKey:propertyAttributeName];
            }
            // 如果不存在主键的值，则根据传进来的block创建一个主键的值
            else
            {
                // 先取出entity中的主键
                NSString *entityPrimaryValue = [entity valueForKey:curPrimaryKey];
                
                // 如果entity中有主键，则直接赋值给当前model
                if (entityPrimaryValue)
                {
                    [self setValue:entityPrimaryValue forKey:curPrimaryKey];
                }
                // 否则就生成主键值
                else
                {
                    // 如果存在生成主键的block，则拿block来生成主键
                    if (generateBlock)
                    {
                        value = generateBlock(curPrimaryKey, entity);
                    }
                    // 如果没有block，则自动的生成一个uuid来当做主键
                    else
                    {
                        value = [self generateUUIDString];
                    }
                    
                    [entity setValue:value forKey:curPrimaryKey];
                    
                    [self setValue:value forKey:curPrimaryKey];
                }
            }
        }
        else
        {
            // 拿到entity当前属性的数据类型
            objc_property_t entity_property_t = class_getProperty([entity class], [propertyAttributeName UTF8String]);
            NSString *entity_attribute_type = [self attributeTypeOfProperty_t:entity_property_t];
            
            // 如果是数组类型或者集合类型，说明curValue是一个model数组或者集合，需要遍历所有的model数据，而对应的entity中的数据肯定是NSSet
            if ([NSClassFromString(entity_attribute_type) isSubclassOfClass:[NSSet class]])
            {
                // 只有满足这些条件才能进去循环
                // 当前的属性有值   当前属性有有效值            当前model有对应的entity          当前model对应的entity中也有这个属性，避免当前model的属性是后加上的，导致无用的循环
                if (curValue && [curValue count] > 0 && [self mapEntityClass] && class_getProperty([self mapEntityClass], [propertyAttributeName UTF8String]) != NULL)
                {
                    // 从entity中取出当前属性的值，能进到这里说明这个数据类型是数组
                    NSArray *objects = [entity valueForKey:propertyAttributeName];
                    
                    // 存放最后转换过的entity数据
                    NSMutableArray *objectsMutableArr = [[NSMutableArray alloc] init];
                    
                    if (!objects)
                    {
                        objectsMutableArr = [[NSMutableArray alloc] init];
                    }
                    else if (objects.count > 0)
                    {
                        [objectsMutableArr addObjectsFromArray:objects];
                    }
                    
                    // 遍历所有的models，因为外部的model是可以改变的，外部的数量是不定的，要以外部的数据为主
                    for (id model in curValue)
                    {
                        // 从model中拿到所对应的primaryKey
                        NSString *primaryKey = [model primaryKey];
                        
                        // 根据主键从取出的entity数组中找到mode对应的entity
                        NSManagedObject *object = primaryKey ? [self matchedObjectFrom:objectsMutableArr primaryKey:primaryKey value:[model valueForKey:primaryKey]] : nil;
                        
                        // 如果存在主键并且存在entity，则直接将数据映射过去
                        if (object)
                        {
                            [model assignToEntity:object managedObjectContext:managedObjectContext primaryKeyGenerateBlock:generateBlock];
                        }
                        // 如果不存在主键或者存在主键但是对应的entity为nil，则则直接添加一个新entity数据即可
                        else
                        {
                            NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([model mapEntityClass])
                                                                                    inManagedObjectContext:managedObjectContext];
                            [model assignToEntity:object managedObjectContext:managedObjectContext primaryKeyGenerateBlock:generateBlock];
                            
                            [objectsMutableArr addObject:object];
                        }
                    }
                    
                    // 不管model里是数组还是集合，到coredata中都是以集合(NSSet)的形式存在
                    [entity setValue:[NSSet setWithArray:objectsMutableArr] forKey:propertyAttributeName];
                }
            }
            // 如果entity对应的属性是NSManagedObject类型的话，说明这是一个一对一的属性，则直接对应的赋值过去
            else if ([NSClassFromString(entity_attribute_type) isSubclassOfClass:[NSManagedObject class]])
            {
                NSManagedObject *object = [entity valueForKey:propertyAttributeName];
                
                if (object)
                {
                    [curValue assignToEntity:object managedObjectContext:managedObjectContext primaryKeyGenerateBlock:generateBlock];
                }
                else
                {
                    object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([curValue mapEntityClass])
                                                           inManagedObjectContext:managedObjectContext];
                    
                    [curValue assignToEntity:object managedObjectContext:managedObjectContext primaryKeyGenerateBlock:generateBlock];
                    
                    [entity setValue:object forKey:propertyAttributeName];
                }
            }
            // 到这里来，说明是一些可以直接赋值的数据类型
            else
            {
                [entity setValue:curValue forKey:propertyAttributeName];
            }
        }
    }
    
    free(property_ptr);
    
    return entity;
}

/**
 从已有的entities中取出主键对应的数据，用于update

 @param objects 数据数组
 @param pkey 主键
 @param value 主键值
 @return coredata所对应的entity，如果存在则返回，如果不存在则返回nil
 */
- (NSManagedObject *)matchedObjectFrom:(NSArray *)objects primaryKey:(NSString *)pkey value:(NSString *)value
{
    for (NSManagedObject *obj in objects) {
        if ([[obj valueForKey:pkey] isEqualToString:value]) {
            return obj;
        }
    }
    
    return nil;
}

/**
 根据property_t，取出数据类型

 @param property_t property_t
 @return 数据类型，如NSArray， B， I， NSSet 等
 */
- (NSString *)attributeTypeOfProperty_t:(objc_property_t)property_t
{
    unsigned int outCount = 0;
    objc_property_attribute_t *attribute_t =  property_copyAttributeList(property_t, &outCount);
    NSString *attribute = [NSString stringWithUTF8String:attribute_t->value];
    NSRange range = [attribute rangeOfString:@"\""];
    return range.location != NSNotFound ?
                        [attribute substringWithRange:NSMakeRange(range.location + range.length,
                                                                  attribute.length - range.location - range.length - 1)] : attribute;
}

- (NSString *)generateUUIDString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

@end

#pragma clang diagnostic pop
