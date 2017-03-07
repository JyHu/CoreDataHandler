//
//  AUUCleanUpOperation.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUCleanUpOperation.h"
#import "NSManagedObject+AUUHelper.h"
#import "AUUMacros.h"


@interface AUUCleanUpOperation()

@property (assign, nonatomic) Class entityClass;

@property (retain, nonatomic) NSString *sortedKey;

@property (copy, nonatomic) void (^completion)();

@end

@implementation AUUCleanUpOperation

- (void)cleanupWithEnityClass:(Class)cls sortedKey:(NSString *)skey
{
    [self cleanupWithEnityClass:cls sortedKey:skey completion:nil];
}

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
        if ([obj isKindOfClass:[NSManagedObject class]])
        {
            /**
             *  @author JyHu, 16-03-12 22:03:38
             *
             *  循环去清空当前查询到的数据
             *
             *  @since v1.0
             */
            [(NSManagedObject *)obj cleanupWithManagedObjectContext:self.managedObjectContext
                                            ignoreAttributeTypeName:NSStringFromClass([obj class])];
        }
        
        [self.managedObjectContext deleteObject:obj];
    }
    
    [self saveChangesWithFlag:YES];
    
    if (self.completion) {
        self.completion();
    }
}

- (void)main
{
    AUUDebugBeginWithInfo(@"清空实体类%@数据的线程开始", self.entityClass);
    
    if ([self initVariableWithEntityClass:self.entityClass sortedKey:self.sortedKey])
    {
        [self fetchedResultsController];
        
        [self cleanup];
    }
    
    AUUDebugFinishWithInfo(@"清空实体类%@数据的线程结束", self.entityClass);
}

@end
