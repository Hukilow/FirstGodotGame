@tool
extends Panel

@export var reset: bool = false
@onready var details = $"../Details"
@onready var playerBuild = $"../../../Player_build"
@onready var popupModify = $MarginContainer2/ModifyName/PopupModify
@onready var input_fieldModify = $MarginContainer2/ModifyName/PopupModify/VBoxContainer/LineEdit
@onready var ok_buttonModify = $MarginContainer2/ModifyName/PopupModify/VBoxContainer/OkModify
@onready var allHousesButtons = $AllHouses
@onready var NPCManager = $"../../../NPCManager"
@onready var NPCs = $"../../../NPCs"

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
	var i = 0
	var disabled := false
	var presetName = null
	for child in details.get_children():
		i = 0
		if child.is_class("MenuBar"):
			var popup = child.get_child(0)
			popup.clear()
			for preset in Global.presetsWork.keys():
				print(Global.presetsWork.keys())
				popup.add_item(preset)
				if popup.name == preset:
					popup.set_item_disabled(i,true)
					disabled = true
					presetName = popup.name
				i += 1
			popup.add_item("None")
			if !disabled:
				if popup.name == "None":
					popup.set_item_disabled(i,true)
				Global.presetsHouses[presetName] = null
		
func _on_house_button_pressed(button):
	details.visible = true
	Global.houseSelected = button
	for child in details.get_children():
		if child.is_class('MenuBar'):
			if child.name == button.name:
				child.set_visible(true)
			else:
				child.set_visible(false)
		if child.is_class('Button'):
			if child.name == "start_" + button.name or child.name == "pause_" + button.name:
				child.set_visible(true)
			else:
				child.set_visible(false)

func _on_modify_name_pressed() -> void:
	if allHousesButtons.get_child_count() > 0:
		popupModify.popup_centered()
		input_fieldModify.text = ""


func _on_ok_modify_pressed() -> void:
	var old_name = Global.houseSelected.name
	var new_name = input_fieldModify.text
	popupModify.hide()
	if len(new_name) > 2:
		for child in allHousesButtons.get_children():
			if child.name == new_name:
				return
		Global.houseSelected.name = new_name
		buttons[buttons.find(Global.houseSelected)].name = new_name
		buttons[buttons.find(Global.houseSelected)].text = new_name
		for child in details.get_children():
			if child.name == old_name:
				child.name = new_name
			if "pause_" + old_name == child.name:
				child.name = "pause_" + new_name
			if "start_" + old_name == child.name:
				child.name = "start_" + new_name
		for child in playerBuild.get_children():
			if child.name == "house_" + old_name:
				child.name = "house_" + new_name
				child.get_node("Name").text = new_name
		Global.presetsHouses[new_name] = Global.presetsHouses[old_name]
		Global.presetsHouses.erase(old_name)
		Global.isNPCWorking[new_name] = Global.isNPCWorking[old_name]
		Global.isNPCWorking.erase(old_name)
		for child in NPCs.get_children():
			if child.name == "FellowNPC_" + old_name:
				child.name = "FellowNPC_" + new_name
			
func _on_preset_id_pressed(id) -> void:
	var itemSelected = null
	var presets = Global.GetPresetsList()
	for child in details.get_children():
		if child.name == Global.houseSelected.name:
			var popup = child.get_child(0)
			itemSelected = popup.get_item_text(id)
			popup.name = itemSelected
			for i in len(presets)+1:
				if i == id:
					popup.set_item_disabled(id,true)
				else:
					popup.set_item_disabled(i,false)
	if itemSelected == "None":
		Global.isNPCWorking[Global.houseSelected.name] = false
		UpdateStartAndPauseButton("none")
		Global.presetsHouses[Global.houseSelected.name] = null
	else:
		Global.isNPCWorking[Global.houseSelected.name] = false
		UpdateStartAndPauseButton()
		Global.presetsHouses[Global.houseSelected.name] = itemSelected


func _on_start_button_pressed(StartWorkButton):
	var house_name = Global.houseSelected.name
	if !Global.isNPCWorking.has(house_name):
		Global.isNPCWorking[house_name] = true
	Global.isNPCWorking[house_name] = true
	for child in NPCs.get_children():
		if child.name =="FellowNPC_"+ house_name:
			NPCManager.AddCustomTask(child)
	UpdateStartAndPauseButton()
			
func _on_pause_button_pressed(PauseWorkButton):
	var house_name = Global.houseSelected.name
	if !Global.isNPCWorking.has(house_name):
		Global.isNPCWorking[house_name] = false
	Global.isNPCWorking[house_name] = false
	UpdateStartAndPauseButton()


func UpdateStartAndPauseButton(none=null):
	if none != null:
		details.get_node("pause_" + Global.houseSelected.name).disabled = true
		details.get_node("start_" + Global.houseSelected.name).disabled = true
		return
	if Global.isNPCWorking[Global.houseSelected.name] == false:
		details.get_node("start_" + Global.houseSelected.name).disabled = false
		details.get_node("pause_" + Global.houseSelected.name).disabled = true
	else:
		details.get_node("start_" + Global.houseSelected.name).disabled = true
		details.get_node("pause_" + Global.houseSelected.name).disabled = false
	
