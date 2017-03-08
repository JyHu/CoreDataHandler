//
//  AUUFetchAllOperation.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUFetchAllOperation.h"
#import "AUUMacros.h"
#import "NSArray+AUUHelper.h"
#import "AUUBaseRecordsCenter.h"

@interface AUUFetchAllOperation()

@property (assign, nonatomic) Class entityClass;

@property (retain, nonatomic) NSString *sortedKey;

@property (copy, nonatomic) void (^fetchedEntitiesResultBlock)(NSArray *entities);

@property (retain, nonatomic) NSArray *entities;

@end

@implementation AUUFetchAllOperation

- (void)fetchAllWithEnityClass:(Class)cls sortedKey:(NSString *)skey
{
    [self fetchAllWithEnityClass:cls sortedKey:skey fetchedEntities:nil];
}

- (void)fetchAllWithEnityClass:(Class)cls sortedKey:(NSString *)skey
               fetchedEntities:(void (^)(NSArray *))fetchedResultBlock
{
    self.entityClass = cls;
    self.sortedKey = skey;
    self.fetchedEntitiesResultBlock = fetchedResultBlock;
}

- (void)main
{
    AUUDebugBeginWithInfo(@"查询实体类%@所有数据的线程开始",NSStringFromClass(self.entityClass));
    
    BOOL exitStatus = NO;
    
    // 初始化coredata数据的查询操作
    if ([self initVariableWithEntityClass:self.entityClass sortedKey:self.sortedKey])
    {
        self.entities = [[self fetchedResultsController] fetchedObjects];
        
        if (self.fetchedEntitiesResultBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.fetchedEntitiesResultBlock(self.entities);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:AUUFetchAllRecordsNotification object:[self.entities convertEntitiesToModels]];
            });
        }
        
        if ([self respondsToSelector:@selector(asyncHandleWithExitStatus:error:)]) {
            [self asyncHandleWithExitStatus:&exitStatus error:nil];
        } else if ([self respondsToSelector:@selector(asyncHandleWithEntities:exitStatus:fetchError:)]) {
            [self asyncHandleWithEntities:self.entities exitStatus:&exitStatus fetchError:nil];
        } else {
            exitStatus = YES;
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:@{@"errorInfo" : @"初始化查询失败，请检查一下sortedKey和entityClass是否有效"}];
        
        if ([self respondsToSelector:@selector(asyncHandleWithExitStatus:error:)]) {
            [self asyncHandleWithExitStatus:&exitStatus error:error];
        } else if ([self respondsToSelector:@selector(asyncHandleWithEntities:exitStatus:fetchError:)]) {
            [self asyncHandleWithEntities:self.entities exitStatus:&exitStatus fetchError:error];
        } else {
            exitStatus = YES;
        }
    }
    
    while (!exitStatus)
    {
        [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
    }
    
    AUUDebugFinishWithInfo(@"查询实体类%@所有数据的线程结束", NSStringFromClass(self.entityClass));
}

@end
