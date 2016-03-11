//
//  PWDHistoryEntity+CoreDataProperties.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PWDHistoryEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWDHistoryEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *h_date;
@property (nullable, nonatomic, retain) NSString *h_pwd;
@property (nullable, nonatomic, retain) NSString *h_id;
@property (nullable, nonatomic, retain) NSNumber *h_synced;
@property (nullable, nonatomic, retain) NSManagedObject *password_ship;

@end

NS_ASSUME_NONNULL_END
