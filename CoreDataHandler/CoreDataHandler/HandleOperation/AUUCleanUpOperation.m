//
//  AUUCleanUpOperation.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUCleanUpOperation.h"
#import "AUUBaseManagedObject.h"


@interface AUUCleanUpOperation()

@property (assign, nonatomic) Class entityClass;

@property (retain, nonatomic) NSString *sortedKey;

@property (copy, nonatomic) void (^completion)();

@end

@implementation AUUCleanUpOperation

- (void)cleanupWithEnityClass:(Class)cls sortedKey:(NSString *)skey
                   completion:(void (^)(void))completion
{
    self.entityClass = cls;
    self.sortedKey = skey;
    self.completion = completion;
}

- (void)cleanup
{
    for (id obj in [[self fetchedResultsController] fetchedObjects])
    {
        if ([obj isMemberOfClass:[AUUBaseManagedObject class]])
        {
            [(AUUBaseManagedObject *)obj cleanupWithManagedObjectContext:self.managedObjectContext];
        }
        
        [self.managedObjectContext deleteObject:obj];
    }
    
    [self saveChangesWithFlag:NO];
}

- (void)main
{
    AUUDebugLog(@"清空实体类%@数据的线程开始", self.entityClass);
    
    if ([self initVariableWithEntityClass:self.entityClass sortedKey:self.sortedKey])
    {
        [self fetchedResultsController];
        
        [self cleanup];
    }
    
    AUUDebugLog(@"清空实体类%@数据的线程结束", self.entityClass);
}

@end
