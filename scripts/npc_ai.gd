extends Node

@onready var taskManager = $"../../../TaskManager"
@onready var itemManager = $"../../../ItemManager"

@onready var NPC = $".."


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
	if NPC.CanTakeItem(item):
		NPC.AddItemNPCInventory(item)
		itemManager.RemoveItemFromWorld(item)
		

func CanStoreIn(item):
	if item.maxCapacity - item.actualCapacity > NPC.actualWeight:
		return true
	return false


func StoreItem(item):
	if CanStoreIn(item):
		item.actualCapacity += NPC.actualWeight
		NPC.actualWeight = 0
		item.UpdateProgressBar()
		
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
				if NPC.HasReachedDestination():
					currentTask.OnReachedDestination()
					OnFinishedSubTask();
					
			Task.TaskType.Harvest:
				var targetItem = currentTask.GetCurrentSubTask().targetItem
				if targetItem.TryHarvest(harvestSkill * delta,targetItem):
					currentTask.OnFinishSubTask()
					OnFinishedSubTask()
				else:
					pass
					#print(targetItem.harvestProgress)
					#targetItem.progressBar.value += harvestSkill * delta * 1/targetItem.harvestDifficulty

func StartCurrentSubTask(subTask):
	print ("Starting subtask: " + Task.TaskType.keys()[subTask.taskType])
	
	match subTask.taskType:
		Task.TaskType.FindItem:
			var targetItem = itemManager.FindNearestItem(subTask.targetItemType, NPC.position)
			if targetItem == null:
				print("no item, force task to finish")
				currentTask.Finish()
			else:
				currentTask.OnFoundItem(targetItem)
				
			OnFinishedSubTask()
			
		Task.TaskType.WalkTo:
			NPC.SetMoveTarget(subTask.targetItem.position)
			currentAction = PawnAction.DoingSubTask
			
		Task.TaskType.PickUp:
			OnPickupItem(subTask.targetItem)
			currentTask.OnFinishSubTask()
			OnFinishedSubTask()
			
		Task.TaskType.Harvest:
			currentAction = PawnAction.DoingSubTask
			
		Task.TaskType.Store:
			StoreItem(subTask.targetItem)
			currentTask.OnFinishSubTask()
			OnFinishedSubTask()
			
