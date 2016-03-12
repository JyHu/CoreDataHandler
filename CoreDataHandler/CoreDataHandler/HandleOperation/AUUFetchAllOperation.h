//
//  AUUFetchAllOperation.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUBaseHandleOperation.h"


#if defined(__has_include) && __has_include("MJExtension.h")
#   define _HasMJ
#endif

#ifdef _HasMJ
#   import "MJExtension.h"
#else
#   if defined(__has_include) && __has_include(<MJExtension.h>)
#       define _HasMJ
#   endif
#   ifdef _HasMJ
#       import <MJExtension.h>
#   endif
#endif


/**
 *  @author JyHu, 16-03-11 16:03:17
 *
 *  查询某个类的所有数据的operation
 *
 *  @since v1.0
 */
@interface AUUFetchAllOperation : AUUBaseHandleOperation

#ifdef _HasMJ

/**
 *  @author JyHu, 16-03-12 21:03:42
 *
 *  如果项目中又MJExtension的话，可以用这个方法，但由于Relationship的名字还有设置
 *
 *  对于获取数据时的一些参数的设置
 *
 *  @param cls          要查询的Entity的class
 *  @param skey         排序的key
 *  @param convertBlock 将获取到的数据进行回传给调用的地方进行处理转换的block
 *
 *  @warning    block中得操作是在异步线程中
 *
 *  @since v1.0
 */
- (void)fetchAllWithEntityClass:(Class)cls sortedKey:(NSString *)skey
                entitiesConvert:(void (^)(NSManagedObjectContext *managedObjectContext))convertBlock;

#endif

/**
 *  @author JyHu, 16-03-11 16:03:17
 *
 *  对于获取数据时的一些参数的设置
 *
 *  @param cls     要查询的Entity的class
 *  @param skey    排序的key
 *  @param convert 将获取到的数据进行回传给调用的地方进行处理转换的block
 *
 *  @warning    block中得操作是在异步线程中
 *
 *  @since v1.0
 */
- (void)fetchAllWithEnityClass:(Class)cls sortedKey:(NSString *)skey
               entitiesConvert:(void (^)(NSArray* entities))convertBlock;


@end
