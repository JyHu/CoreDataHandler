//
//  AUUPWDExtraInfoModel.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWDExtraInfoEntity.h"

@interface AUUPWDExtraInfoModel : NSObject

@property (nullable, nonatomic, retain) NSString *e_attrname;
@property (nonatomic, assign) NSInteger e_type;
@property (nullable, nonatomic, retain) NSString *e_value;
@property (nonatomic, assign) BOOL e_synced;
@property (nullable, nonatomic, retain) NSString *e_id;

- (void)assignToEntity:(PWDExtraInfoEntity *)entity withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (id)generate;

@end
