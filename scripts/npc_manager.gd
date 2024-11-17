extends Node

#@onready var FNPC = $"../FellowNPC"
@onready var taskManager = $"../TaskManager"
@onready var itemManager = $"../ItemManager"



func _ready() -> void:
	pass
	#var targetItem = itemManager.FindNearestItem(ItemManager.ItemCategory.WOOD, FNPC.position)
	#FNPC.SetMoveTarget(targetItem.position)

		
func BeginWork():
	for preset in Global.presetsHouses:
		pass
		
