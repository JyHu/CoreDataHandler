//
//  AUUPWDManagerModel.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWDManagerEntity.h"

@interface AUUPWDManagerModel : NSObject

@property (nonatomic, assign) BOOL m_visiable;
@property (nonatomic, assign) BOOL m_uploaded;
@property (nullable, nonatomic, retain) NSString *m_id;
@property (nonatomic, assign) BOOL m_synced;

- (void)assignToEntity:(PWDManagerEntity * _Nonnull)entity withManagedObjectContext:(NSManagedObjectContext * _Nonnull)managedObjectContext;

+ (nonnull id)generate;

@end
