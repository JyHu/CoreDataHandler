//
//  AUUInsertOrUpdateOperation.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUBaseHandleOperation.h"

/**
 *  @author JyHu, 16-03-11 17:03:26
 *
 *  数据转换的Block，将model中得数据转到Entity中
 *
 *  @param oriModel             原始的model
 *  @param object               要将数据转换到的Entity
 *  @param managedObjectContext 上下文
 *
 *  @warning    block中得操作是在异步线程中
 *
 *  @since v1.0
 */
typedef void (^AUUModelConvertBlock)(id oriModel,
                                     id object,
                                     NSManagedObjectContext * managedObjectContext);

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
 插入或更新数据到coredata

 @param model 要插入的数据
 @param models  插入一组数据到coredata
 @param completion 插入成功后的回调
 */
- (void)insertOrUpdateObject:(id)model;
- (void)insertOrUpdateObjects:(NSArray *)models;
- (void)insertOrUpdateObject:(id)model completion:(void (^)(BOOL successed))completion;
- (void)insertOrUpdateObjects:(NSArray *)models completion:(void (^)(BOOL successed))completion;

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
