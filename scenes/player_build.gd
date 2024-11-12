extends Node2D

@onready var panel_build = $"../UI/Build"

var house_scene : PackedScene = load("res://scenes/house.tscn")
var scierie_scene : PackedScene = load("res://scenes/scierie.tscn")
var isPlacing : bool
var delay = 5
var object = null

	
func StartPlacing(new_object):
	panel_build.set_visible(false)
	add_child(new_object)
	object = new_object
	isPlacing = true
	

func _process(delta: float) -> void:
	if isPlacing:
		var tween = get_tree().create_tween()
		tween.tween_property(object, "position", get_global_mouse_position(), delay * delta)
		if Input.is_action_just_pressed("click") and len(Global.inCollision) == 0:
			isPlacing = false



func _on_house_pressed() -> void:
	var house = house_scene.instantiate()
	StartPlacing(house)

func _on_scierie_pressed() -> void:
	var scierie = scierie_scene.instantiate()
	StartPlacing(scierie)
