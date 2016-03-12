# CoreDataHandler
对`Coredata`增删改查数据进行的封装

##说明

这是一个对`Coredata`的进行增删改查操作封装的`Project`，

* 将各种操作都放在线程中，减小对于主线程的影响。
* 提供数据管理中心的支持
* 提供`Entity` -> `Model`转换的方法
* ……

## 使用方法

1. `Core Data`操作的标准步骤
	- 新建自己的`.xcdatamodeld`文件
		New File --> iOS --> Core Data --> Data Model
	- 选择自己新建的`.xcdatamodeld`文件，新建`Entity`(类似于sqlite中的数据表)
	- 添加`Entity`属性
	- 添加`Entity`依赖(relation ship)
	- 新建`EntityClass`文件(即项目中测试文件中得`Entities`中得所有文件)
		New File --> iOS --> Core Data --> NSManagedObject subclass
	- 根据新建的Entity创建所有对应的Model
	
1. 接入步骤
	- 将项目中得`CoreDataHandler`文件夹拖入自己的项目中
	- 在第一步中新建的Entity文件中引入`NSManagedObject+AUUHelper`，用于提供一些已经封装好的和以后将要进行优化的方法
		- 暂时提供以下两种方法
		
		> `cleanupWithManagedObjectContext:ignoreAttributeTypeName:`
		>> 清空`Coredata`中当前数据模型下的所有数据
		>
		> `assignToModel`
		>> 将`Entity`转换成目标`model`，如果该`Entity`种包含有其他的`Entity`，那么就需要重写这个方法，可以省去自己进行数据转换时很多的代码。
		>>
		>> 需要添加一个方法的调用`assignToModelWithClass:`，不然将无法知道将要转换到的数据类型。
	- 在每个`Entity`的`.m`文件中，都需要添加以下代码

		>
		> `- (id)assignToModel { return [self assignToModelWithClass:[AUUPWDDetailModel class]]; }`
		>
		> 后面添加的是要转换到的model的class，以便于自动的转换数据模型。

	- 添加一个`AUUBaseRecordsCenter`的`category`来作为`CoreData`的数据管理中心，所有的操作都放到这里来统一管理。
	- 需要在自己的所有`model`中添加自己转换成`Entity`的方法。
	
	
	
##继续优化中。。。
