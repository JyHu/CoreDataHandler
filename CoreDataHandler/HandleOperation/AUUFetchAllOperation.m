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
    
    if ([self initVariableWithEntityClass:self.entityClass sortedKey:self.sortedKey])
    {
        [self fetchedResultsController];
        
        if (self.fetchedEntitiesResultBlock)
        {
            self.fetchedEntitiesResultBlock([[self fetchedResultsController] fetchedObjects]);
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:AUUFetchAllRecordsNotification object:[[[self fetchedResultsController] fetchedObjects] convertEntitiesToModels]];
        }
    }
    
    AUUDebugFinishWithInfo(@"查询实体类%@所有数据的线程结束", NSStringFromClass(self.entityClass));
}

@end
