# CoreDataHandler
对`Coredata`增删改查数据进行的封装

##说明

这是一个对`Coredata`的进行增删改查操作封装的`Project`，

* 将各种操作都放在线程中，减小对于主线程的影响。
* 提供数据管理中心的支持
* 提供`Entity` -> `Model`转换的方法
* 提供`Model`->`Entity`转换的方法

## 使用方法

### `Core Data`操作的标准步骤
1. 新建自己的`.xcdatamodeld`文件
   New File --> iOS --> Core Data --> Data Model
2. 选择自己新建的`.xcdatamodeld`文件，新建`Entity`(类似于sqlite中的数据表)
3. 添加`Entity`属性
4. 添加`Entity`依赖(Relation ship)
5. 新建`EntityClass`文件(即项目中测试文件中得`Entities`中得所有文件)
   `New File` --> `iOS` —> `Core Data` --> `NSManagedObject subclass`
6. 根据新建的`Entity`创建所有对应的`Model`

### 接入步骤
- 将项目中得`CoreDataHandler`文件夹拖入自己的项目中，或者

  `pod 'CoreDataHandler', :git => 'https://github.com/JyHu/CoreDataHandler.git'`


- 添加一个`AUUBaseRecordsCenter`的`category`来作为`CoreData`的数据管理中心，所有的操作都放到这里来统一管理。

- 需要在自己的所有`model`中添加两个方法

  ```
  /**
   所对应的Entity实体类的class，用于自动将model转换成Entity时用
   */
  - (Class)mapEntityClass;

  /**
   主键名，用于update，因为如果没有主键的话，就无法找到唯一的值，可以不设置，如果不设置的话，则不会更新，只能插入。
   */
  - (NSString *)primaryKey;
  ```

- 需要在所有的`Entity`中添加一个方法

  ```
  /**
   Entity对应的Model的class
   用于自动将Entity转换成model
   */
  - (Class)mapModelClass;
  ```

  ​
##使用方法说明

按照`CoreData`的原生的操作方法，见`AppDelegate.m`中得一堆示例代码。

### `insert`

* 封装好的操作方法

```Objective-C
- (void)insertGroup:(AUUPWDGroupModel *)groupModel
{
    AUUInsertOrUpdateOperation *operation = [[AUUInsertOrUpdateOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator SortKey:@"g_id"];
    [operation insertOrUpdateObject:groupModel];
    [self enQueueRecordOperation:operation];
}
```

###`Search`

* 封装好的操作方法

```Objective-C
- (void)fetchAllGroup
{
    AUUFetchAllOperation *operation = [[AUUFetchAllOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator];
    [operation fetchAllWithEnityClass:[PWDGroupEntity class] sortedKey:@"g_id" fetchedEntities:^(NSArray *entities) {
        NSLog(@"%@", [[entities firstObject] description]);
    }];
    [self enQueueRecordOperation:operation];
}
```

###`Clean up`

* 封装好的操作方法

```Objective-C
- (void)cleanupGroup
{
    AUUCleanUpOperation *operation = [[AUUCleanUpOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator];
    [operation cleanupWithEnityClass:[PWDGroupEntity class] sortedKey:@"g_id"];
    [self enQueueRecordOperation:operation];
}
```

### `Delete`

```objective-c
AUUDeleteOperation *deleteOperation = [[AUUDeleteOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator];
[deleteOperation deleteobjectWithModel:groupModel completion:^(BOOL successed) {
	NSLog(@"delete object %@", successed ? @"yes" : @"no");
}];
[[AUUBaseRecordsCenter shareCenter] enQueueRecordOperation:deleteOperation];
```



##继续优化中。。。