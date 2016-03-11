//
//  AUUUtil.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUUtil.h"

@implementation AUUUtil

+ (NSString *)generateUniqueIdentifier
{
    CFUUIDRef uniqueIdentifier = CFUUIDCreate(NULL);
    CFStringRef uniqueIdentifierString = CFUUIDCreateString(NULL, uniqueIdentifier);
    CFRelease(uniqueIdentifier);
    return CFBridgingRelease(uniqueIdentifierString);
}

@end
