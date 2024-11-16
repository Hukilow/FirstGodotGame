@tool
extends Panel

@export var reset: bool = false
@onready var UI = $".."
@onready var presets = $Presets
@onready var graphs = $"../Graphs"
@onready var popup = $MarginContainer2/Popup
@onready var input_field = $MarginContainer2/Popup/VBoxContainer/LineEdit
@onready var ok_button = $MarginContainer2/Popup/VBoxContainer/Button
@onready var houses = $"../../Assign/Houses"
var scriptgraph = load("res://scripts/graph_edit.gd")
var buttons = []

func _ready() -> void:
	loadButtons()
	arrangeButtons()
	ok_button.connect("pressed", _on_ok_pressed)

func _process(_delta: float) -> void:
	if reset:
		reset = false
		loadButtons()
		arrangeButtons()

func loadButtons():
	buttons = []
	for child in get_children():
		if child is Button:
			buttons.append(child)

	
func arrangeButtons():
	for i in range(len(buttons)):
		buttons[i].anchor_top = (i * 0.1)
		buttons[i].anchor_bottom = 1 - (1-i * 0.1)
		buttons[i].anchor_left = 0
		buttons[i].anchor_right = 1
		buttons[i].offset_bottom = 0
		buttons[i].offset_left = 0
		buttons[i].offset_right = 0
		buttons[i].offset_top = 0


func _on_add_pressed() -> void:
	popup.popup_centered()
	input_field.text = ""

		
func _on_delete_pressed() -> void:
	get_node("../Graphs/graph_" + Global.presetSelected.text).queue_free()
	buttons.erase(Global.presetSelected)
	Global.presetSelected.queue_free()
	arrangeButtons()
	

# Exemple de callback pour le nouveau bouton
func _on_preset_button_pressed(button) -> void:
	Global.presetSelected = button
	for child in graphs.get_children():
		if child.name == "graph_" + button.text:
			child.set_visible(true)
		else:
			child.set_visible(false)
	
	
func _on_ok_pressed():
	var user_input = input_field.text
	#Vérifie si le nom n'existe pas déjà
	for child in graphs.get_children():
		if child.name == "graph_" + user_input:
			popup.hide()
			return
	popup.hide()
	#Vérfie qu'il y'a moins de 10 presets et crée le bouton et le graph
	if presets.get_child_count() < 10:
		var new_button = Button.new()
		new_button.text = user_input
		new_button.name = "preset_" + user_input
		Global.presetSelected = new_button
		new_button.connect("pressed",_on_preset_button_pressed.bind(new_button))
		presets.add_child(new_button)
		buttons.append(new_button)
		Global.presetsWork[user_input] = []
		arrangeButtons()
		print(Global.presetsWork)
		
		var graph := GraphEdit.new()
		graph.name = "graph_"+ user_input
		graph.anchor_right = 1
		graph.anchor_bottom = 1
		graph.right_disconnects = true
		graph.show_grid = false
		graph.show_grid_buttons = false
		graph.show_minimap_button = false
		graph.minimap_enabled = false
		graph.script = scriptgraph
		graphs.add_child(graph)
		
		houses.updatePresets()
