//
//  AUUTestRecordsCenter.h
//  CoreDataOperate
//
//  Created by JyHu on 2017/3/10.
//
//

#import <CoreDataHandler/CoreDataHandler.h>

@class AUUPWDGroupModel;

@interface AUUTestRecordsCenter : AUUBaseRecordsCenter

+ (instancetype)shareInstance;

/**
 *  @author JyHu, 16-03-12 22:03:46
 *
 *  测试插入Group数据
 *
 *  @param groupModel GroupModel
 *
 *  @since v1.0
 */
- (void)insertGroup:(AUUPWDGroupModel *)groupModel;

/**
 *  @author JyHu, 16-03-12 22:03:04
 *
 *  测试获取所有的Group数据
 *
 *  @since v1.0
 */
- (void)fetchAllGroup;

/**
 *  @author JyHu, 16-03-12 22:03:24
 *
 *  测试清空所有的Group数据
 *
 *  @since v1.0
 */
- (void)cleanupGroup;

/**
 *  @author JyHu, 16-03-12 22:03:50
 *
 *  测试获取所有密码数据
 *
 *  @since v1.0
 */
- (void)fetchAllDetails;

/**
 *  @author JyHu, 16-03-12 22:03:35
 *
 *  测试清空所有的密码数据
 *
 *  @since v1.0
 */
- (void)cleanupDetails;

@end
