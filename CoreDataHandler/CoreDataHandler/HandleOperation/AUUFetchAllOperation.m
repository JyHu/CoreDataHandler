//
//  AUUFetchAllOperation.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUFetchAllOperation.h"

@interface AUUFetchAllOperation()

@property (assign, nonatomic) Class entityClass;

@property (retain, nonatomic) NSString *sortedKey;

#ifdef _HasMJ

@property (copy, nonatomic) void (^convertBlockOC)(NSManagedObjectContext *managedObjectContext);

#endif

@property (copy, nonatomic) void (^convertBlockAE)(NSArray *entities);

@end

@implementation AUUFetchAllOperation

#ifdef _HasMJ

- (void)fetchAllWithEntityClass:(Class)cls sortedKey:(NSString *)skey
                entitiesConvert:(void (^)(NSManagedObjectContext *managedObjectContext))convertBlock
{
    self.entityClass = cls;
    self.sortedKey = skey;
    self.convertBlockOC = convertBlock;
}

#endif

- (void)fetchAllWithEnityClass:(Class)cls sortedKey:(NSString *)skey
               entitiesConvert:(void (^)(NSArray *))convertBlock
{
    self.entityClass = cls;
    self.sortedKey = skey;
    self.convertBlockAE = convertBlock;
}

- (void)main
{
    AUUDebugBeginWithInfo(@"查询实体类%@所有数据的线程开始",NSStringFromClass(self.entityClass));
    
    if ([self initVariableWithEntityClass:self.entityClass sortedKey:self.sortedKey])
    {
        [self fetchedResultsController];
        
#ifdef _HasMJ
        
        if (self.convertBlockOC)
        {
            self.convertBlockOC(self.managedObjectContext);
        }
        
#endif
        if (self.convertBlockAE)
        {
            self.convertBlockAE([[self fetchedResultsController] fetchedObjects]);
        }
    }
    
    AUUDebugFinishWithInfo(@"查询实体类%@所有数据的线程结束", NSStringFromClass(self.entityClass));
}

@end
