extends Node2D

@onready var panel_build = $"../UI/Build"

var house_scene : PackedScene = load("res://building/house.tscn")
var scierie_scene : PackedScene = load("res://building/scierie.tscn")
var warehouse_scene : PackedScene = load("res://building/warehouse.tscn")
var fellowNPC_scene : PackedScene = load("res://scenes/fellownpc.tscn")
@onready var houses = $"../UI/Assign/Houses"
@onready var allHouses = $"../UI/Assign/Houses/AllHouses"
@onready var housesDetails = $"../UI/Assign/Details"
@onready var NPCs = $"../NPCs"
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
	Global.inMenu = false
	

func _process(delta: float) -> void:
	if isPlacing:
		var tween = get_tree().create_tween()
		tween.tween_property(object, "position", get_global_mouse_position(), delay * delta)
		if Input.is_action_just_pressed("click") and len(Global.inCollision) == 0:
			isPlacing = false
			#On vérifie si le build est une maison
			if buildSelected.scene_file_path == "res://building/house.tscn":
				#On crée un nouveau bouton dans Assign
				var new_button = Button.new()
				var house_name = FindNameForHouse()
				buildSelected.name = "house_" + house_name
				buildSelected.get_node("Name").text = house_name
				new_button.text = house_name
				new_button.name = house_name
				#On connecte le bouton
				new_button.connect("pressed",houses._on_house_button_pressed.bind(new_button))
				allHouses.add_child(new_button)
				houses.buttons.append(new_button)
				houses.arrangeButtons()
				var menubar = MenuBar.new()
				menubar.name = house_name
				menubar.anchor_left = 0.25
				menubar.anchor_top = 0.1
				var popupMenu = PopupMenu.new()
				popupMenu.name = "None"
				#On connecte le popupMenu pour récupérer le choix
				popupMenu.connect("id_pressed", houses._on_preset_id_pressed)
				menubar.add_child(popupMenu)
				menubar.set_visible(false)
				housesDetails.add_child(menubar)
				
				houses.updatePresets()
				Global.houseSelected = new_button
				if !Global.presetsHouses.has(house_name):
					Global.presetsHouses[house_name] = null
					
				var fellowNPC = fellowNPC_scene.instantiate()
				fellowNPC.name = "FellowNPC" + house_name
				fellowNPC.position = Vector2(buildSelected.position.x,buildSelected.position.y+25)
				NPCs.add_child(fellowNPC)
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
