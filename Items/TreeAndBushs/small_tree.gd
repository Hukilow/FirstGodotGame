extends Item

class_name Plant

var harvestProgress : float = 0
var harvestDifficulty : float = 4

var harvestItem : String = "res://Items/TreeAndBushs/Log.tscn"
var harvestAmount : Vector2i = Vector2i(5, 15)

@onready var progressBar = $ProgressBar

func _init():
	super._init()
	add_to_group("Plant")

func _process(delta: float) -> void:
	if progressBar.value > 0:
		progressBar.visible = true

func TryHarvest(amount : float) -> bool:
	harvestProgress += amount * 1/harvestDifficulty
	if harvestProgress >= 1:
		itemManager.RemoveItemFromWorld(self)
		itemManager.SpawnItemByName(harvestItem, randi_range(harvestAmount.x, harvestAmount.y), itemManager.WorldToMapPosition(position))
		return true
	else:
		progressBar.value = harvestProgress
		return false
		
func OnClick():
	taskManager.AddTask(Task.TaskType.Harvest, self)
