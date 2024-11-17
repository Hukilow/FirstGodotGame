extends Item

class_name Log


@export var weight = 1



func _init():
	super._init();
	add_to_group("Log")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func OnClick():
	taskManager.AddTask(Task.TaskType.PickUp, self)
