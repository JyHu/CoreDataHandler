//
//  NSObject+AUUHelper.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "NSObject+AUUHelper.h"
#import <objc/runtime.h>

@implementation NSObject (AUUHelper)

/**
 *  @author JyHu, 16-03-11 12:03:47
 *
 *  根据查找类型查找property的属性名称（propertyAttributeTypeName）
 *
 *  @param type 查找类型
 *
 *  @return propertyAttributeName
 *
 *  @since v1.0
 */
- (NSString *)findoutPropertyAttributeNameWithFindType:(AUUFindoutType)type
{
    unsigned int properties_count = 0;
    
    objc_property_t *property_ptr = class_copyPropertyList([self class], &properties_count);
    
    for (unsigned int i = 0; i < properties_count; i ++)
    {
        objc_property_t property_t = property_ptr[i];
        
        const char *attributes = property_getAttributes(property_t);
        
        NSString *attributesString = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
        
        if (attributesString && attributesString.length > 0)
        {
            BOOL contained = NO;
            
            if (type == AUUFindoutTypeSet && [attributesString rangeOfString:@"@\"NSSet\""].location != NSNotFound)
            {
                contained = YES;
            }
            else if (type == AUUFindoutTypeEntity)
            {
                NSString *attributeString = [attributesString containedEntityAttributeTypeName];
                
                contained = (attributeString && attributeString.length > 0);
            }
            
            if (contained)
            {
                const char *name = property_getName(property_t);
                                
                return [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            }
        }
    }
    
    return nil;
}

/**
 *  @author JyHu, 16-03-11 13:03:59
 *
 *  根据属性名（propertyAttributeName）查找这个属性的类型（propertyAttributeTypeName）
 *
 *  @param name 属性的名称（propertyAttributeName）
 *
 *  @return 属性的类型（propertyAttributeTypeName）
 *
 *  @since v1.0
 */
- (NSString *)findoutAttributeTypeNameWithAttributeName:(NSString *)name
{
    unsigned int properties_count = 0;
    
    objc_property_t *property_ptr = class_copyPropertyList([self class], &properties_count);
    
    for (unsigned int i = 0; i < properties_count; i ++)
    {
        objc_property_t property_t = property_ptr[i];
        
        const char *cname = property_getName(property_t);
        
        if ([[NSString stringWithCString:cname encoding:NSUTF8StringEncoding] isEqualToString:name])
        {
            const char *attribtues = property_getAttributes(property_t);
            
            NSString *propertyAttributeString = [NSString stringWithCString:attribtues encoding:NSUTF8StringEncoding];
            
            property_ptr = NULL;
            
            return [propertyAttributeString propertyAttributeTypeName];
        }
    }
    
    property_ptr = NULL;
    
    return nil;
}

- (id)assignToEntityWithClass:(Class)cls
{
    id entity = [[cls alloc] init];
    
    unsigned int property_count = 0;
    
    objc_property_t *property_ptr = class_copyPropertyList(cls, &property_count);
    
    for (unsigned int i = 0; i < property_count; i ++)
    {
        objc_property_t property_t = property_ptr[i];
        
        const char *cname = property_getName(property_t);
        
        
    }
    
    return entity;
}

/**
 *  @author JyHu, 16-03-11 13:03:51
 *
 *  判断当前类是否包含某个属性
 *
 *  @param attribtue 要判断的属性
 *
 *  @return BOOL
 *
 *  @since v1.0
 */
+ (BOOL)whetherContainsAttribute:(NSString *)attribtue
{    
    unsigned int propertiesCount = 0;
    
    objc_property_t *propertPtr = class_copyPropertyList([self class], &propertiesCount);
    
    for (unsigned int i = 0; i < propertiesCount; i ++)
    {
        objc_property_t property = propertPtr[i];
        
        const char *name = property_getName(property);
        
        if ([[NSString stringWithCString:name encoding:NSUTF8StringEncoding] isEqualToString:attribtue])
        {
            propertPtr = NULL;
            
            return YES;
        }
    }
    
    propertPtr = NULL;
    
    return NO;
}

+ (void)debugLogAttributes
{
    /*
     
     t_int          Ti,N,V_t_int
     t_float        Tf,N,V_t_float
     t_char         Tc,N,V_t_char
     t_double       Td,N,V_t_double
     t_unsigned_int TI,N,V_t_unsigned_int
     t_integer      Tq,N,V_t_integer
     t_cgfloat      Td,N,V_t_cgfloat
     t_bool         TB,N,V_t_bool
     
     t_number       T@"NSNumber",&,N,V_t_number
     t_string       T@"NSString",&,N,V_t_string
     t_data         T@"NSData",&,N,V_t_data
     t_date         T@"NSDate",&,N,V_t_date
     t_array            T@"NSArray",&,N,V_t_array
     t_mutableArray     T@"NSMutableArray",&,N,V_t_mutableArray
     t_set              T@"NSSet",&,N,V_t_set
     t_mutableSet       T@"NSMutableSet",&,N,V_t_mutableSet
     
     */
    unsigned int properties_count = 0;
    
    objc_property_t *property_ptr = class_copyPropertyList([self class], &properties_count);
    
    for (unsigned int i = 0; i < properties_count; i ++)
    {
        objc_property_t property_t = property_ptr[i];
        
        const char *objc_name = property_getName(property_t);
        
        const char *objc_attributes = property_getAttributes(property_t);
        
        AUUDebugLog(@"%@ %@",   [NSString stringWithCString:objc_name encoding:NSUTF8StringEncoding],
                                [NSString stringWithCString:objc_attributes encoding:NSUTF8StringEncoding]);
    }
    
    property_ptr = NULL;
}

@end
