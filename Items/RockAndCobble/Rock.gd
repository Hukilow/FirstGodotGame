extends Item

class_name Rocks

enum RocksType {LITTLE = 0, SMALL = 1, BIG = 2}
var harvestProgress : float = 0

@export var rocksType : RocksType

@export var harvestItem : String = "res://Items/RockAndCobble/cobble_pickable.tscn"
@export var preregisterCaracteristics : bool = true
# ↑ ça change en fonction du type de l'item de façon prédéfinit
@export var harvestDifficulty : float = 4
@export var XP_drop : int = 1
@export var harvestAmount : Vector2i = Vector2i(8, 10)
@export var hardness : int = 3
@onready var progressBar = $ProgressBar


func _init():
	super._init()
	add_to_group("Rocks")
	
func _ready() -> void:
	if preregisterCaracteristics:
		load_preregister_caracteristics()




func load_preregister_caracteristics():
	if rocksType == 0:
		harvestDifficulty = 1
		XP_drop = 1
		harvestAmount = Vector2i(1, 1)
		hardness = randi_range(3,6)
	if rocksType == 1:
		harvestDifficulty = 2
		XP_drop = 1
		harvestAmount = Vector2i(1, 2)
		hardness = randi_range(5,10)
	if rocksType == 2:
		harvestDifficulty = 1
		XP_drop = 3
		harvestAmount = Vector2i(3, 4)
		hardness = randi_range(15,20)
		

func TryHarvest(amount : float, targetItem) -> bool:
	harvestProgress += amount * 1/harvestDifficulty
	progressBar.visible = true
	if harvestProgress >= 1:
		hardness -= 1
		if hardness == 0:
			itemManager.RemoveItemFromWorld(self)
		var newPos = Vector2i(randi_range(position.x-20,position.x+20), position.y+20) # ici faut mettre pour la position celle du centre de l'item mais jsp comment faire
		print(targetItem.position)
		itemManager.SpawnItemByName(harvestItem, randi_range(harvestAmount.x, harvestAmount.y), itemManager.WorldToMapPosition(newPos))
		Global.actualXP += XP_drop
		harvestProgress = 0
		progressBar.visible = false
		return true
	else:
		progressBar.value = harvestProgress
		return false
		
func OnClick():
	taskManager.AddTask(Task.TaskType.Harvest, self)
