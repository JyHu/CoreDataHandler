//
//  PWDGroupEntity+CoreDataProperties.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PWDGroupEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWDGroupEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *g_date;
@property (nullable, nonatomic, retain) NSString *g_id;
@property (nullable, nonatomic, retain) NSString *g_name;
@property (nullable, nonatomic, retain) NSNumber *g_synced;
@property (nullable, nonatomic, retain) NSSet<PWDDetailEntity *> *passwords_ship;

@end

@interface PWDGroupEntity (CoreDataGeneratedAccessors)

- (void)addPasswords_shipObject:(PWDDetailEntity *)value;
- (void)removePasswords_shipObject:(PWDDetailEntity *)value;
- (void)addPasswords_ship:(NSSet<PWDDetailEntity *> *)values;
- (void)removePasswords_ship:(NSSet<PWDDetailEntity *> *)values;

@end

NS_ASSUME_NONNULL_END
