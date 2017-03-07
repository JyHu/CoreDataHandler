//
//  PWDDetailEntity+CoreDataProperties.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PWDDetailEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWDDetailEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *p_account;
@property (nullable, nonatomic, retain) NSString *p_cellphone;
@property (nullable, nonatomic, retain) NSString *p_pwd;
@property (nullable, nonatomic, retain) NSString *p_website;
@property (nullable, nonatomic, retain) NSNumber *p_synced;
@property (nullable, nonatomic, retain) NSNumber *p_visiable;
@property (nullable, nonatomic, retain) NSNumber *p_visiable_count;
@property (nullable, nonatomic, retain) NSString *p_id;
@property (nullable, nonatomic, retain) NSManagedObject *group_ship;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *extra_ship;
@property (nullable, nonatomic, retain) NSSet<PWDHistoryEntity *> *history_ship;
@property (nullable, nonatomic, retain) PWDManagerEntity *manager_ship;

@end

@interface PWDDetailEntity (CoreDataGeneratedAccessors)

- (void)addExtra_shipObject:(NSManagedObject *)value;
- (void)removeExtra_shipObject:(NSManagedObject *)value;
- (void)addExtra_ship:(NSSet<NSManagedObject *> *)values;
- (void)removeExtra_ship:(NSSet<NSManagedObject *> *)values;

- (void)addHistory_shipObject:(PWDHistoryEntity *)value;
- (void)removeHistory_shipObject:(PWDHistoryEntity *)value;
- (void)addHistory_ship:(NSSet<PWDHistoryEntity *> *)values;
- (void)removeHistory_ship:(NSSet<PWDHistoryEntity *> *)values;

@end

NS_ASSUME_NONNULL_END
