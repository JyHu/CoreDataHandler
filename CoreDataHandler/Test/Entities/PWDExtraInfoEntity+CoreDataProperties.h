//
//  PWDExtraInfoEntity+CoreDataProperties.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PWDExtraInfoEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWDExtraInfoEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *e_attrname;
@property (nullable, nonatomic, retain) NSNumber *e_type;
@property (nullable, nonatomic, retain) NSString *e_value;
@property (nullable, nonatomic, retain) NSNumber *e_synced;
@property (nullable, nonatomic, retain) NSString *e_id;
@property (nullable, nonatomic, retain) PWDDetailEntity *password_ship;

@end

NS_ASSUME_NONNULL_END
