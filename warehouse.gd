extends Node2D

@onready var taskManager = $"../../TaskManager"
@onready var itemManager = $"../../ItemManager"
var maxCapacity = 100
var actualCapacity = 0
@onready var progressBar = $ProgressBar

func UpdateProgressBar():
	progressBar.value = actualCapacity
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	Global.inCollision.append(area)


func _on_area_2d_area_exited(area: Area2D) -> void:
	Global.inCollision.erase(area)

func OnClick():
	taskManager.AddTask(Task.TaskType.Store, self)
