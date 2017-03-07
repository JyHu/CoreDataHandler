//
//  PWDManagerEntity+CoreDataProperties.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PWDManagerEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWDManagerEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *m_visiable;
@property (nullable, nonatomic, retain) NSNumber *m_uploaded;
@property (nullable, nonatomic, retain) NSString *m_id;
@property (nullable, nonatomic, retain) NSNumber *m_synced;
@property (nullable, nonatomic, retain) NSManagedObject *password_ship;

@end

NS_ASSUME_NONNULL_END
