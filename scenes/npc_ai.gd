extends Node

@onready var taskManager = $"../../TaskManager"
@onready var itemManager = $"../../ItemManager"

@onready var charController = $".."


enum PawnAction {Idle, DoingSubTask}

var currentAction : PawnAction = PawnAction.Idle

var currentTask : Task = null

var harvestSkill : float = 1

var inHand;

func _process(delta):
	if currentTask != null:
		DoCurrentTask(delta)
	else:
		currentTask = taskManager.RequestTask()
		
func OnPickupItem(item):
	inHand = item
	itemManager.RemoveItemFromWorld(item)
		
func OnFinishedSubTask():
	currentAction = PawnAction.Idle
	
	if currentTask.IsFinished():
		currentTask = null
		
func DoCurrentTask(delta):
	var subTask = currentTask.GetCurrentSubTask()
	
	if currentAction == PawnAction.Idle:
		StartCurrentSubTask(subTask)
	else:
		match subTask.taskType:
			Task.TaskType.WalkTo:
				if charController.HasReachedDestination():
					currentTask.OnReachedDestination()
					OnFinishedSubTask();
					
			Task.TaskType.Harvest:
				var targetItem = currentTask.GetCurrentSubTask().targetItem
				if targetItem.TryHarvest(harvestSkill * delta):
					currentTask.OnFinishSubTask()
					OnFinishedSubTask()
				else:
					print(targetItem.harvestProgress)

func StartCurrentSubTask(subTask):
	print ("Starting subtask: " + Task.TaskType.keys()[subTask.taskType])
	
	match subTask.taskType:
		Task.TaskType.FindItem:
			var targetItem = itemManager.FindNearestItem(subTask.targetItemType, charController.position)
			if targetItem == null:
				print("no item, force task to finish")
				currentTask.Finish()
			else:
				currentTask.OnFoundItem(targetItem)
				
			OnFinishedSubTask()
			
		Task.TaskType.WalkTo:
			charController.SetMoveTarget(subTask.targetItem.position)
			currentAction = PawnAction.DoingSubTask
			
		Task.TaskType.Pickup:
			OnPickupItem(subTask.targetItem)
			currentTask.OnFinishSubTask()
			OnFinishedSubTask()
			
			
		Task.TaskType.Harvest:
			currentAction = PawnAction.DoingSubTask
