//
//  AUUPWDDetailModel.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUUPWDManagerModel.h"
#import "AUUBaseManagedObject.h"
#import "PWDDetailEntity.h"


@interface AUUPWDDetailModel : NSObject

@property (nullable, nonatomic, retain) NSString *p_account;
@property (nullable, nonatomic, retain) NSString *p_cellphone;
@property (nullable, nonatomic, retain) NSString *p_pwd;
@property (nullable, nonatomic, retain) NSString *p_website;
@property (nonatomic, assign) BOOL p_synced;
@property (nonatomic, assign) BOOL p_visiable;
@property (nonatomic, assign) NSInteger p_visiable_count;
@property (nullable, nonatomic, retain) NSString *p_id;
@property (nullable, nonatomic, retain) NSArray *extra_ship;
@property (nullable, nonatomic, retain) NSArray *history_ship;
@property (nullable, nonatomic, retain) AUUPWDManagerModel *manager_ship;

- (void)assignToEntity:(PWDDetailEntity *)entity withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (id)generate;

@end
