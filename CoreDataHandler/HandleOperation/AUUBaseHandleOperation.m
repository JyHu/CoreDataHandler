//
//  AUUBaseHandleOperation.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUBaseHandleOperation.h"
#import "AUUBaseRecordsCenter.h"
#import "NSObject+AUUHelper.h"
#import "AUUMacros.h"


@interface AUUBaseHandleOperation() <NSFetchedResultsControllerDelegate>

// 持久化存储助理
@property (strong) NSPersistentStoreCoordinator *sharedPSC;

@end

@implementation AUUBaseHandleOperation

- (id)initWithSharedPSC:(NSPersistentStoreCoordinator *)psc
{
    self = [super init];
    
    if (self)
    {
        self.sharedPSC = psc;
        
        // 设置线程的优先级
        [self setQueuePriority:NSOperationQueuePriorityNormal];
    }
    
    return self;
}

- (BOOL)initVariableWithEntityClass:(Class)cls sortedKey:(NSString *)key
{
    if (!cls)
    {
        AUUDebugLog(@"要查询的实体类%@不是NSManagedObject的子类或者为空", NSStringFromClass(cls));
        return NO;
    }
    
    if (class_getProperty(cls, [key UTF8String]) != NULL)
    {
        // 要查询的实体类
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(cls)
                                                  inManagedObjectContext:self.managedObjectContext];
        
        // 查询到的数据的排序方式
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
        
        self.fetchRequest = [[NSFetchRequest alloc] init];
        
        [self.fetchRequest setEntity:entity];
        
        [self.fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        [self fetchedResultsController];
        
        return YES;
    }
    
    AUUDebugLog(@"要查询的实体类%@不包含属性%@",cls, key);
    
    return NO;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController)
    {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    NSError *error;
    
    if (![_fetchedResultsController performFetch:&error])
    {
        abort();
    }
    
    return _fetchedResultsController;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    if (_sharedPSC != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        [_managedObjectContext setPersistentStoreCoordinator:self.sharedPSC];
    }
    
    return _managedObjectContext;
}

- (void)saveChangesWithFlag:(BOOL)flag
{
    NSError *error = nil;
    
    if ([self.managedObjectContext hasChanges])
    {
        [[AUUBaseRecordsCenter shareCenter] pushFlag2Queue:flag];
        
        if (![self.managedObjectContext save:&error])
        {
            AUUDebugLog(@"%@ 保存数据变动失败", NSStringFromClass([self class]));
            
            [[AUUBaseRecordsCenter shareCenter] rollbackFlagQueue];
        }
        else
        {
            AUUDebugLog(@"%@ 数据保存成功", NSStringFromClass([self class]));
        }
    }
}

@end
