//
//  AUUInsertOrUpdateOperation.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUBaseHandleOperation.h"

/**
 *  @author JyHu, 16-03-11 17:03:34
 *
 *  用于做唯一判断查询的值，类似于sqlite中得主键
 *
 *  @param primeKey 主键
 *
 *  @return 自己根据自己定义的Entity设定的主键的值
 *
 *  @since v1.0
 */
typedef id (^AUUPrimeValueGenerateBlock)(id primeKey, NSManagedObject *managedObject);

/**
 数据查询的operation
 */
@interface AUUInsertOrUpdateOperation : AUUBaseHandleOperation

/**
 *  @author JyHu, 16-03-11 17:03:18
 *
 *  初始化方法
 *
 *  @param psc         持久化存储助理
 *  @param sortKey     排序用的key
 *
 *  @return self
 *
 *  @since v1.0
 */
- (instancetype)initWithSharedPSC:(NSPersistentStoreCoordinator *)psc SortKey:(NSString *)sortKey;

/**
 *  @author JyHu, 16-03-11 17:03:20
 *
 *  用来对查询到的数据排序的key
 *
 *  @since v1.0
 */
@property (retain, nonatomic) NSString *sortedKey;

/**
 插入或更新数据到coredata

 @param model 要插入的数据， models 一系列数据
 @param completion 插入成功后的回调
 */
- (void)insertOrUpdateObject:(id)model completion:(void (^)(BOOL successed))completion;
- (void)insertOrUpdateObjects:(NSArray *)models completion:(void (^)(BOOL successed))completion;
- (void)insertOrUpdateObjects:(NSArray *)models;
- (void)insertOrUpdateObject:(id)model;


/**
 异步线程的操作，留给子类实现的

 @param entities 当前插入的model所对应的coredata中的entity
 @param exitStatus 控制线程退出的状态
 @param error 错误信息
 */
- (void)asyncHandleWithEntities:(NSMutableArray *)entities exitStatus:(BOOL *)exitStatus insertOrUpdateError:(NSError *)error;

#pragma mark - 
#pragma mark - 以下的参数是非必须按的参数，是为了保持数据的唯一性，用于数据更新用
#pragma mark -

/**
 *  @author JyHu, 16-03-11 17:03:28
 *
 *  是否需要操作成功后的通知提醒，默认为YES
 *
 *  @since v1.0
 */
@property (assign, nonatomic) BOOL needCompletionNotification;

/**
 *  @author JyHu, 16-03-11 17:03:51
 *
 *  设置的生成主键值的block
 *
 *  @since v1.0
 */
@property (copy, nonatomic) AUUPrimeValueGenerateBlock primeValueGenerateBlock;

@end
