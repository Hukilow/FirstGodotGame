extends Node2D
@onready var progressBarLevel = $UI/Level/MarginContainer/ProgressBar
@onready var actualLevel = $UI/Level/MarginContainer2/ActualLevel
@onready var nextLevel = $UI/Level/MarginContainer3/NextLevel

	
func _process(delta: float) -> void:
	updateLevel()
	
	
func updateLevel():
	if Global.actualXP == Global.maxXP:
		Global.level += 1
		Global.actualXP = 0
		Global.maxXP *= 2
	progressBarLevel.value = Global.actualXP
	progressBarLevel.max_value = Global.maxXP
	actualLevel.text = "Lv"+str(Global.level)
	nextLevel.text = "Lv"+str(Global.level + 1)
