//
//  AUUPWDGroupModel.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWDGroupEntity.h"


@interface AUUPWDGroupModel : NSObject

@property (nullable, nonatomic, retain) NSDate *g_date;
@property (nullable, nonatomic, retain) NSString *g_id;
@property (nullable, nonatomic, retain) NSString *g_name;
@property (nonatomic, assign) BOOL g_synced;
@property (nullable, nonatomic, retain) NSArray *passwords_ship;

- (void)assignToEntity:(PWDGroupEntity *)entity withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (id)generate;

@end
