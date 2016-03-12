//
//  NSString+AUUHelper.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "NSString+AUUHelper.h"

/*
 
 @property      NSString                             *tempID;
        
        propertyAttributeTypeName             propertyAttributeName
 
 */

@implementation NSString (AUUHelper)

/**
 *  @author JyHu, 16-03-11 11:03:19
 *
 *  获取property属性的类型
 *
 *  @return string
 *
 *  @since v1.0
 */
- (NSString *)propertyAttributeTypeName
{
    NSRegularExpression *reqular = [[NSRegularExpression alloc] initWithPattern:@"(?<=T@\").*?(?=\\\",)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *result = [reqular firstMatchInString:self options:NSMatchingWithTransparentBounds range:NSMakeRange(0, self.length)];
    NSRange range = result.range;
    if (range.location != NSNotFound)
    {
        return [self substringWithRange:range];
    }
    
    return nil;
}

/**
 *  @author JyHu, 16-03-11 11:03:58
 *
 *  获取属性是coredata中entity得property
 *
 *  @return Entity class name
 *
 *  @since v1.0
 */
- (NSString *)containedEntityAttributeTypeName
{
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
    
    NSArray *coredataOriginalAttribtues = @[@"NSNumber", @"NSDecimalNumber", @"NSString", @"NSDate", @"NSData", @"NSSet"];
    
    NSString *propertyName = [self propertyAttributeTypeName];
    
    if (![coredataOriginalAttribtues containsObject:propertyName])
    {
        return propertyName;
    }
    
    return nil;
}

@end
