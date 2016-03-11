//
//  AUUPWDHistoryModel.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWDHistoryEntity.h"

@interface AUUPWDHistoryModel : NSObject

@property (nullable, nonatomic, retain) NSDate *h_date;
@property (nullable, nonatomic, retain) NSString *h_pwd;
@property (nullable, nonatomic, retain) NSString *h_id;
@property (nonatomic, assign) BOOL h_synced;

- (void)assignToEntity:(PWDHistoryEntity *)entity withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (id)generate;

@end
