# CoreDataHandler
对Coredata增删改查数据进行的封装

##说明

这是一个对Coredata的进行增删改查操作封装的Project，

* 将各种操作都放在线程中，减小对于主线程的影响。
* 提供数据管理中心的支持
* 提供Entity -> Model转换的方法
* ……

## 使用方法
1. Core Data操作的标准步骤
	- 新建自己的`.xcdatamodeld`文件
		New File --> iOS --> Core Data --> Data Model
    - 选择自己新建的`.xcdatamodeld`文件，新建Entity(类似于sqlite中的数据表)
    - 添加Entity属性
    - 添加Entity依赖(relation ship)
	- 新建EntityClass文件(即项目中测试文件中得Entities中得所有文件)
		New File --> iOS --> Core Data --> NSManagedObject subclass
1. 接入步骤
	- 将项目中得`CoreDataHandler`文件夹拖入自己的项目中
	- 将第一部中新建的所有EntityClass的父类都改成`AUUBaseManagedObject`
##继续优化中。。。
