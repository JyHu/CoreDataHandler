//
//  AUUBaseHandleOperation.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AUUBaseRecordsCenter;

/**
 *  @author JyHu, 16-03-10 23:03:27
 *
 *  数据操作的基类线程
 *
 *  @since 1.0
 */
@interface AUUBaseHandleOperation : NSOperation

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext; // 管理数据的上下文

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController; // 管理查询到的数据

@property (nonatomic, strong) NSFetchRequest *fetchRequest; // 获取数据的请求，相当于sql语句

@property (weak, nonatomic) AUUBaseRecordsCenter *baseRecordsCenter;

@property (retain, nonatomic) NSPredicate *predicate;

/**
 *  @author JyHu, 16-03-10 23:03:05
 *
 *  初始化方法
 *
 *  @param psc 持久化存储助理
 *
 *  @return self
 *
 *  @since 1.0
 */
- (id)initWithSharedPSC:(NSPersistentStoreCoordinator *)psc;

/**
 *  @author JyHu, 16-03-10 23:03:42
 *
 *  保存数据变动
 *
 *  @param flag 是否发送数据变动时的通知
 *          YES 影响
 *          NO  不影响
 *
 *  @since 1.0
 */
- (void)saveChangesWithFlag:(BOOL)flag;

/**
 *  @author JyHu, 16-03-10 23:03:26
 *
 *  初始化NSFetchRequest查询类
 *
 *  @param cls 要查询的实体的类名
 *  @param key 对查询到的数据排序的key
 *
 *  @return 是否初始化成功
 *
 *  @since 1.0
 */
- (BOOL)initVariableWithEntityClass:(Class)cls sortedKey:(NSString *)key;

/**
 在operation中做一些异步的操作，这个方法需要在子类中去实现，如果不需要在coredata操作的时候去做一些异步的操作的话，可以不实现这个方法
 这个操作是跟当前所在的operation同一条异步线程

 @param exitStatus BOOL指针，如果设置为yes，就会退出线程
 @param error 操作中出现的错误
 */
- (void)asyncHandleWithExitStatus:(BOOL *)exitStatus error:(NSError *)error;


@end
