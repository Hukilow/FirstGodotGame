extends Node

class_name Task

enum TaskType {BaseTask, FindItem, WalkTo, PickUp, Eat, Manipulate, Harvest, Store, Find}

var taskName: String
var taskType: TaskType = TaskType.BaseTask

var subTasks = []
var currentSubTask : int = 0

var targetItem
var targetItemType

func IsFinished() -> bool:
	return currentSubTask == len(subTasks)
	
func Finish():
	currentSubTask = len(subTasks)
	
func GetCurrentSubTask():
	return subTasks[currentSubTask]
	
func OnFinishSubTask():
	currentSubTask += 1
	
func OnFoundItem(item):
	OnFinishSubTask()
	GetCurrentSubTask().targetItem = item

func OnReachedDestination():
	OnFinishSubTask()
	GetCurrentSubTask().targetItem = subTasks[currentSubTask - 1].targetItem
	
	
func InitHarvestPlantTask(target):
	var subTask = Task.new()
	subTask.taskType = TaskType.WalkTo
	subTask.targetItem = target
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.Harvest
	subTask.targetItem = target
	subTasks.append(subTask)
	
func InitPickUpTask(target):
	var subTask = Task.new()
	subTask.taskType = TaskType.WalkTo
	subTask.targetItem = target
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.PickUp
	subTask.targetItem = target
	subTasks.append(subTask)
	
func InitStoreTask(target):
	var subTask = Task.new()
	subTask.taskType = TaskType.WalkTo
	subTask.targetItem = target
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.Store
	subTask.targetItem = target
	subTasks.append(subTask)
	
func InitFindAndWalkTask():
	var subTask = Task.new()
	subTask.taskType = TaskType.FindItem
	subTask.targetItemType = ItemManager.ItemCategory.WOOD
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.WalkTo
	subTasks.append(subTask)
	
func CreateCustomTask(nodes):
	var subTask = Task.new()
	for node in range(len(nodes)):
		match nodes[node]:
			'Find':
				subTask = Task.new()
				subTask.taskType = TaskType.FindItem
				match nodes[node+1]:
					'SmTree':
						subTask.targetItemType = ItemManager.ItemCategory.WOOD
				subTasks.append(subTask)
				subTask = Task.new()
				subTask.taskType = TaskType.WalkTo
				subTasks.append(subTask)
			'Harvest':
				subTask = Task.new()
				subTask.taskType = TaskType.Harvest
				subTask.targetItem = GetCurrentSubTask().targetItem
				subTasks.append(subTask)
			'PickUp':
				subTask = Task.new()
				subTask.taskType = TaskType.FindItem
				match nodes[node+1]:
					'Log':
						subTask.targetItemType = ItemManager.ItemCategory.WOOD
				subTasks.append(subTask)
				subTask = Task.new()
				subTask.taskType = TaskType.WalkTo
				subTasks.append(subTask)
				subTask = Task.new()
				subTask.taskType = TaskType.PickUp
				subTask.targetItem = GetCurrentSubTask().targetItem
				subTasks.append(subTask)
	print(subTasks)
				
				
				
				
		

	
