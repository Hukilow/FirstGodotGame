extends Node2D

@onready var panel_build = $"../UI/Build"

var house_scene : PackedScene = load("res://building/house.tscn")
var scierie_scene : PackedScene = load("res://building/scierie.tscn")
var warehouse_scene : PackedScene = load("res://building/warehouse.tscn")
@onready var houses = $"../UI/Assign/Houses"
@onready var allHouses = $"../UI/Assign/Houses/AllHouses"
@onready var housesDetails = $"../UI/Assign/Details"
var isPlacing : bool
var delay = 5
var object = null

var buildSelected = null
	
func StartPlacing(new_object):
	panel_build.set_visible(false)
	add_child(new_object)
	object = new_object
	isPlacing = true
	buildSelected = new_object
	

func _process(delta: float) -> void:
	if isPlacing:
		var tween = get_tree().create_tween()
		tween.tween_property(object, "position", get_global_mouse_position(), delay * delta)
		if Input.is_action_just_pressed("click") and len(Global.inCollision) == 0:
			isPlacing = false
			if buildSelected.scene_file_path == "res://building/house.tscn":
				var new_button = Button.new()
				var house_name = FindNameForHouse()
				buildSelected.name = "house_" + house_name
				buildSelected.get_node("Name").text = house_name
				new_button.text = house_name
				new_button.name = house_name
				new_button.connect("pressed",houses._on_house_button_pressed.bind(new_button))
				allHouses.add_child(new_button)
				houses.buttons.append(new_button)
				houses.arrangeButtons()
				var menubar = MenuBar.new()
				menubar.name = house_name
				var popupMenu = PopupMenu.new()
				popupMenu.name = "Preset"
				menubar.add_child(popupMenu)
				housesDetails.add_child(menubar)
				houses.updatePresets()
				Global.houseSelected = new_button
			buildSelected = null
			
func FindNameForHouse() -> String:
	var i = 0
	var allName = []
	for house in houses.buttons:
		allName.append(house.name)
	while "house" + str(i) in allName:
		i += 1
	return "house" + str(i)


func _on_house_pressed() -> void:
	var house = house_scene.instantiate()
	StartPlacing(house)

func _on_scierie_pressed() -> void:
	var scierie = scierie_scene.instantiate()
	StartPlacing(scierie)

func _on_warehouse_pressed() -> void:
	var warehouse = warehouse_scene.instantiate()
	StartPlacing(warehouse)
