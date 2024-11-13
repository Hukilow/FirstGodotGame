extends Item

class_name Trees

enum TreesType {ROOT = 0, LOG = 1, SMALL = 2, BIG = 3, ENORMOUS = 4}
@export var weight = 1
@export var treesType : TreesType


func _init():
	super._init();
	add_to_group("Trees")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func OnClick():
	taskManager.AddTask(Task.TaskType.PickUp, self)
