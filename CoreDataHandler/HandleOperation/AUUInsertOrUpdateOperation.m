//
//  AUUInsertOrUpdateOperation.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUInsertOrUpdateOperation.h"
#import "NSObject+AUUHelper.h"
#import "AUUMacros.h"

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

- (id)initWithSharedPSC:(NSPersistentStoreCoordinator *)psc SortKey:(NSString *)sortKey
{
    self = [super initWithSharedPSC:psc];
    
    if (self)
    {
        self.sortedKey = sortKey;
        self.needCompletionNotification = YES;
    }
    
    return self;
}

- (void)insertOrUpdateObject:(id)model
{
    [self insertOrUpdateObjects:@[model]];
}

- (void)insertOrUpdateObjects:(NSArray *)models
{
    [self insertOrUpdateObjects:models completion:nil];
}

- (void)insertOrUpdateObject:(id)model completion:(void (^)(BOOL))completion
{
    [self insertOrUpdateObjects:@[model] completion:completion];
}

- (void)insertOrUpdateObjects:(NSArray *)models completion:(void (^)(BOOL))completion
{
    self.completion = completion;
    self.recordsToUpdate = models;
}

- (void)insertOrUpdateRecords
{
    [self insertOrUpdateRecordsToDB];
}

- (void)insertOrUpdateRecordsToDB
{
    for (id model in self.recordsToUpdate)
    {
        id oriObj = nil;
        
        if ([model primaryKey])
        {
            /**
             *  @author JyHu, 16-03-11 17:03:27
             *
             *  如果存在主键的话，就需要检查唯一性，即可能会有更新的操作
             *
             *  @since v1.0
             */
            oriObj = [self originalObjectWithPrimeValue:[model valueForKey:[model primaryKey]] primaryKey:[model primaryKey]];
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
            oriObj = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([model mapEntityClass])
                                                   inManagedObjectContext:self.managedObjectContext];
            
            AUUDebugLog(@"新建一个存储的数据对象成功，%@", oriObj);
            
            /**
             *  @author JyHu, 16-03-11 17:03:44
             *
             *  添加主键的值
             *
             *  @since v1.0
             */
            if ([model primaryKey])
            {
                id primeValue = self.primeValueGenerateBlock ? self.primeValueGenerateBlock([model primaryKey], oriObj) : [self generateUUIDString];
                
                [oriObj setValue:primeValue forKey:[model primaryKey]];
                
                // 同步的设置到model中
                [model setValue:primeValue forKey:[model primaryKey]];
            }
        }
        
        [model assignToEntity:oriObj managedObjectContext:self.managedObjectContext primaryKeyGenerateBlock:self.primeValueGenerateBlock];
        
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
- (id)originalObjectWithPrimeValue:(id)value primaryKey:(NSString *)primaryKey
{
    if (!primaryKey)
    {
        return nil;
    }
    
    for (id obj in [[self fetchedResultsController] fetchedObjects])
    {
        id oriPrimeKeyValue = [obj valueForKey:primaryKey];
        
        if ([oriPrimeKeyValue isEqual:value])
        {
            AUUDebugLog(@"在本地数据库中找到相应的实体对象，%@", obj);
            
            return obj;
        }
    }
    
    AUUDebugLog(@"在本地数据库中没有找到相对应的实体对象，primeKey=%@, value=%@", primaryKey, value);
    
    return nil;
}

- (void)main
{
    NSAssert([[self.recordsToUpdate firstObject] mapEntityClass], @"Entity的Class没有设置");
    NSAssert(self.sortedKey, @"用来排序的key没有设置");
    
    AUUDebugBeginWithInfo(@"插入或更新实体类%@数据的线程开始", [[self.recordsToUpdate firstObject] mapEntityClass]);
    
    BOOL exitStatus = NO;
    
    // 只有当前要插入或更新的有数据的时候才去更新与插入，否则没必要，可以直接退出
    if (self.recordsToUpdate && self.recordsToUpdate.count > 0)
    {
        // 初始化coredata数据的查询操作
        if ([self initVariableWithEntityClass:[[self.recordsToUpdate firstObject] mapEntityClass] sortedKey:self.sortedKey])
        {
            [self fetchedResultsController];
            
            [self insertOrUpdateRecords];
        }
        
        if (self.completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completion(YES);
            });
        }
        
        if ([self respondsToSelector:@selector(asyncHandleWithExitStatus:error:)]) {
            [self asyncHandleWithExitStatus:&exitStatus error:nil];
        } else if ([self respondsToSelector:@selector(asyncHandleWithEntities:exitStatus:insertOrUpdateError:)]) {
            [self asyncHandleWithEntities:self.insertOrUpdateObjectsArray exitStatus:&exitStatus insertOrUpdateError:nil];
        } else {
            exitStatus = YES;
        }
        
        AUUDebugFinishWithInfo(@"插入或更新实体类%@数据的线程成功结束", [[self.recordsToUpdate firstObject] mapEntityClass]);
    }
    else
    {
        if (self.completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completion(YES);
            });
        }
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:@{@"errorInfo" : @"没有要插入的数据"}];
        
        if ([self respondsToSelector:@selector(asyncHandleWithExitStatus:error:)]) {
            [self asyncHandleWithExitStatus:&exitStatus error:error];
        } else if ([self respondsToSelector:@selector(asyncHandleWithEntities:exitStatus:insertOrUpdateError:)]) {
            [self asyncHandleWithEntities:self.insertOrUpdateObjectsArray exitStatus:&exitStatus insertOrUpdateError:error];
        } else {
            exitStatus = YES;
        }
        
        AUUDebugFinishWithInfo(@"插入或更新实体类%@数据的线程结束，因为没有数据", [[self.recordsToUpdate firstObject] mapEntityClass]);
    }
    
    while (!exitStatus) {
        [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
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
