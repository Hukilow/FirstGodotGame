extends Node

class_name TaskManager

var taskQueue = []

func RequestTask():
	if len(taskQueue) > 0:
		
		var task = taskQueue[0]
		taskQueue.erase(task)
		return task
	return null
	
	
	
func AddTask(taskType, targetItem):
	var newTask = Task.new()
	
	if taskType == Task.TaskType.Harvest:
		newTask.InitHarvestPlantTask(targetItem)
		taskQueue.append(newTask)
		
	if taskType == Task.TaskType.PickUp:
		newTask.InitPickUpTask(targetItem)
		taskQueue.append(newTask)
		
	if taskType == Task.TaskType.Store:
		newTask.InitStoreTask(targetItem)
		taskQueue.append(newTask)
