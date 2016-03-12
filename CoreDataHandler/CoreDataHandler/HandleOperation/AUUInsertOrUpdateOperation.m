//
//  AUUInsertOrUpdateOperation.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUInsertOrUpdateOperation.h"

@interface AUUInsertOrUpdateOperation()

/**
 *  @author JyHu, 16-03-11 17:03:42
 *
 *  要进行更新操作的model的数组
 *
 *  @since v1.0
 */
@property (retain, nonatomic) NSArray *recordsToUpdate;

/**
 *  @author JyHu, 16-03-11 17:03:04
 *
 *  要操作的Entity数组
 *
 *  @since v1.0
 */
@property (retain, nonatomic) NSMutableArray *insertOrUpdateObjectsArray;

/**
 *  @author JyHu, 16-03-11 17:03:34
 *
 *  操作结束回调的block
 *
 *  @since v1.0
 */
@property (copy, nonatomic) void (^completion)(BOOL successed);

@end

@implementation AUUInsertOrUpdateOperation

- (id)initWithSharedPSC:(NSPersistentStoreCoordinator *)psc
                  model:(id)model completion:(void (^)(BOOL successed))completion
{
    return [self initWithSharedPSC:psc modelsArray:@[model] completion:completion];
}

- (id)initWithSharedPSC:(NSPersistentStoreCoordinator *)psc
            modelsArray:(NSArray *)modelsArray
             completion:(void (^)(BOOL successed))completion
{
    self = [super initWithSharedPSC:psc];
    
    if (self)
    {
        self.recordsToUpdate = modelsArray;
        
        self.completion = completion;
        
        self.needCompletionNotification = NO;
    }
    
    return self;
}

- (void)insertOrUpdateRecords
{
    [self insertOrUpdateRecordsToDB];
    
    self.completion(YES);
}

- (void)insertOrUpdateRecordsToDB
{
    for (id model in self.recordsToUpdate)
    {
        id oriObj = nil;
        
        if (self.primeKey)
        {
            /**
             *  @author JyHu, 16-03-11 17:03:27
             *
             *  如果存在主键的话，就需要检查唯一性，即可能会有更新的操作
             *
             *  @since v1.0
             */
            oriObj = [self originalObjectWithPrimeValue:[model valueForKey:self.primeKey]];
        }
        
        if (oriObj == nil)
        {
            /**
             *  @author JyHu, 16-03-11 17:03:10
             *
             *  新建一个entity
             *
             *  @since v1.0
             */
            oriObj = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self.entityClass)
                                                   inManagedObjectContext:self.managedObjectContext];
            
            AUUDebugLog(@"新建一个存储的数据对象成功，%@", oriObj);
            
            /**
             *  @author JyHu, 16-03-11 17:03:44
             *
             *  添加主键的值
             *
             *  @since v1.0
             */
            if (self.primeKey)
            {
                id primeValue = self.primeValueGenerateBlock(self.primeKey);
                
                [oriObj setValue:primeValue forKey:self.primeKey];
                
                // 同步的设置到model中
                [model setValue:primeValue forKey:self.primeKey];
            }
        }
        
        self.modelConvertBlock(model, oriObj, self.managedObjectContext);
        
        [self.insertOrUpdateObjectsArray addObject:oriObj];
    }
    
    // 保存数据变动
    [self saveChangesWithFlag:self.needCompletionNotification];
}

/**
 *  @author JyHu, 16-03-11 17:03:38
 *
 *  根据主键的名称和值来从数据库中查找是否这个数据模型已经存在
 *
 *  @param value 主键的值
 *
 *  @return 已经存在的Entity
 *
 *  @since v1.0
 */
- (id)originalObjectWithPrimeValue:(id)value
{
    if (!self.primeKey)
    {
        return nil;
    }
    
    for (id obj in [[self fetchedResultsController] fetchedObjects])
    {
        id oriPrimeKeyValue = [obj valueForKey:self.primeKey];
        
        if ([oriPrimeKeyValue isEqual:value])
        {
            AUUDebugLog(@"在本地数据库中找到相应的实体对象，%@", obj);
            
            return obj;
        }
    }
    
    AUUDebugLog(@"在本地数据库中没有找到相对应的实体对象，primeKey=%@, value=%@", self.primeKey, value);
    
    return nil;
}

- (void)main
{
    NSAssert(self.entityClass, @"Entity的Class没有设置");
    NSAssert(self.sortedKey, @"用来排序的key没有设置");
    NSAssert(self.modelConvertBlock, @"用来进行model和object转换的Block没有设置");
    
    AUUDebugBeginWithInfo(@"插入或更新实体类%@数据的线程开始", self.entityClass);
    
    if (self.recordsToUpdate && self.recordsToUpdate.count > 0)
    {
        if ([self initVariableWithEntityClass:self.entityClass sortedKey:self.sortedKey])
        {
            [self fetchedResultsController];
            
            [self insertOrUpdateRecords];
        }
        
        AUUDebugFinishWithInfo(@"插入或更新实体类%@数据的线程成功结束", self.entityClass);
    }
    else
    {
        AUUDebugFinishWithInfo(@"插入或更新实体类%@数据的线程结束，因为没有数据", self.entityClass);
    }
}

#pragma mark - getter methods

- (NSMutableArray *)insertOrUpdateObjectsArray
{
    if (!_insertOrUpdateObjectsArray)
    {
        _insertOrUpdateObjectsArray = [[NSMutableArray alloc] initWithCapacity:self.recordsToUpdate.count];
    }
    
    return _insertOrUpdateObjectsArray;
}

@end
