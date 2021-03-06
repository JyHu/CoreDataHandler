//
//  AUUFetchAllOperation.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUBaseHandleOperation.h"

/**
 *  @author JyHu, 16-03-11 16:03:17
 *
 *  查询某个类的所有数据的operation
 *
 *  @since v1.0
 */
@interface AUUFetchAllOperation : AUUBaseHandleOperation

/**
 *  @author JyHu, 16-03-11 16:03:17
 *
 *  对于获取数据时的一些参数的设置
 *
 *  @param cls     要查询的Entity的class
 *  @param skey    排序的key
 *  @param fetchedResultBlock 将获取到的数据进行回传给调用的地方进行处理转换的block
 *
 *  @warning    block中得操作是在异步线程中
 *
 *  @since v1.0
 */
- (void)fetchAllWithEnityClass:(Class)cls sortedKey:(NSString *)skey
               fetchedEntities:(void (^)(NSArray* entities))fetchedResultBlock;
- (void)fetchAllWithEnityClass:(Class)cls sortedKey:(NSString *)skey;


/**
 异步操作

 @param entities 获取到的所有的entity
 @param exitStatus 线程是否要退出
 @param error 错误
 */
- (void)asyncHandleWithEntities:(NSArray *)entities exitStatus:(BOOL *)exitStatus fetchError:(NSError *)error;

@end
