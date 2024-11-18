extends Item

class_name Trees

enum TreesType {LOG = 0, ROOT = 1, SMALL = 2, BIG = 3, ENORMOUS = 4}
var harvestProgress : float = 0

@export var treesType : TreesType

@export var harvestItem : String = "res://Items/TreeAndBushs/Log_pickable.tscn"
@export var preregisterCaracteristics : bool = false
# ↑ ça change en fonction du type de l'item de façon prédéfinit
@export var harvestDifficulty : float = 4
@export var XP_drop : int = 1
@export var harvestAmount : Vector2i = Vector2i(8, 10) 

@onready var progressBar = $ProgressBar

func _init():
	super._init()
	add_to_group("Trees")
	
func _ready() -> void:
	if preregisterCaracteristics:
		load_preregister_caracteristics()
	
func _process_(delta: float) -> void:
	if progressBar.value > 0:
		progressBar.visible = true

func load_preregister_caracteristics():
	if treesType == 0:
		harvestDifficulty = 1
		XP_drop = 1
		harvestAmount = Vector2i(1, 1)
	if treesType == 1:
		harvestDifficulty = 1
		XP_drop = 1
		harvestAmount = Vector2i(2, 3)
	if treesType == 2:
		harvestDifficulty = 2
		XP_drop = 1
		harvestAmount = Vector2i(5, 7)
	if treesType == 3:
		harvestDifficulty = 5
		XP_drop = 7
		harvestAmount = Vector2i(10, 15)
	if treesType == 4:
		harvestDifficulty = 10
		XP_drop = 20
		harvestAmount = Vector2i(20, 40)
		

func TryHarvest(amount : float, targetItem) -> bool:
	progressBar.visible = true
	harvestProgress += amount * 1/harvestDifficulty
	if harvestProgress >= 1:
		var pos = targetItem.position
		var newPos = Vector2i(randi_range(pos.x-20,pos.x+20), pos.y+20)
		itemManager.RemoveItemFromWorld(self)
		itemManager.SpawnItemByName(harvestItem, randi_range(harvestAmount.x, harvestAmount.y), itemManager.WorldToMapPosition(newPos))
		Global.actualXP += XP_drop
		
		return true
	else:
		progressBar.value = harvestProgress
		return false
		
func OnClick():
	taskManager.AddTask(Task.TaskType.Harvest, self)
