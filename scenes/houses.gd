@tool
extends Panel

@export var reset: bool = false
@onready var details = $"../Details"
@onready var playerBuild = $"../../../Player_build"
@onready var popupModify = $MarginContainer2/ModifyName/PopupModify
@onready var input_fieldModify = $MarginContainer2/ModifyName/PopupModify/VBoxContainer/LineEdit
@onready var ok_buttonModify = $MarginContainer2/ModifyName/PopupModify/VBoxContainer/OkModify
@onready var allHousesButtons = $AllHouses

var buttons = []

func _ready() -> void:
	loadButtons()
	arrangeButtons()
	
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
		buttons[i].anchor_bottom = (i * 0.1) + 0.1
		buttons[i].anchor_left = 0
		buttons[i].anchor_right = 1
		buttons[i].offset_bottom = 0
		buttons[i].offset_left = 0
		buttons[i].offset_right = 0
		buttons[i].offset_top = 0
		
func updatePresets():
	for child in details.get_children():
		var popup = child.get_child(0)
		popup.clear()
		for preset in Global.presetsWork.keys():
			popup.add_item(preset)

func _on_house_button_pressed(button):
	Global.houseSelected = button
	for child in details.get_children():
		if child.name == button.name:
			child.set_visible(true)
		else:
			child.set_visible(false)

func _on_modify_name_pressed() -> void:
	popupModify.popup_centered()
	input_fieldModify.text = ""


func _on_ok_modify_pressed() -> void:
	var old_name = Global.houseSelected.name
	var new_name = input_fieldModify.text
	for child in allHousesButtons.get_children():
		if child.name == new_name:
			popupModify.hide()
			return
	popupModify.hide()
	Global.houseSelected.name = new_name
	buttons[buttons.find(Global.houseSelected)].name = new_name
	buttons[buttons.find(Global.houseSelected)].text = new_name
	for child in details.get_children():
		if child.name == old_name:
			child.name = new_name
	for child in playerBuild.get_children():
		if child.name == "house_" + old_name:
			child.name = "house_" + new_name
			child.get_node("Name").text = new_name
			
	
