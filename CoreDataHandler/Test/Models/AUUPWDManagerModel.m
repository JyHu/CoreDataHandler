//
//  AUUPWDManagerModel.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUPWDManagerModel.h"

@implementation AUUPWDManagerModel

- (void)assignToEntity:(PWDManagerEntity *)entity withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    entity.m_id = self.m_id;
    entity.m_synced = @(self.m_synced);
    entity.m_uploaded = @(self.m_uploaded);
    entity.m_visiable = @(self.m_visiable);
}

+ (id)generate
{
    AUUPWDManagerModel *model = [[AUUPWDManagerModel alloc] init];
    
    model.m_id = [AUUBaseRecordsCenter generateUniqueIdentifier];
    model.m_synced = arc4random_uniform(2);
    model.m_uploaded = arc4random_uniform(2);
    model.m_visiable = arc4random_uniform(2);
    
    return model;
}

@end
