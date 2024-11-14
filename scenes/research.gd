@tool
extends Panel

@export var reset: bool = false
@onready var UI = $".."
@onready var buildingTree = $Building
@onready var skillTree = $Skill



var buttons = []
var columns := 2

func _ready() -> void:
	loadButtons()
	arrangeSelf()
	arrangeButtonsTOP()

func _process(_delta: float) -> void:
	if reset:
		reset = false
		loadButtons()
		arrangeSelf()
		arrangeButtonsTOP()

func loadButtons():
	buttons = []
	for child in get_children():
		if child is Button:
			buttons.append(child)

func arrangeSelf():	
	anchor_left = 0.25
	anchor_right = 0.75
	anchor_top = 0.20
	anchor_bottom = 0.70
	offset_left = 0
	offset_right = 0
	offset_top = 0
	offset_bottom = 0
	
func arrangeButtonsTOP():
	var rows = ceil(len(buttons) / float(columns))
	for i in range(0,2):
		var column = i%columns
		var row = i / columns
		buttons[i].anchor_top = row / float(rows)
		buttons[i].anchor_bottom = 0.10
		buttons[i].anchor_left = column / float(columns)
		buttons[i].anchor_right = (column + 1) / float(columns)
		buttons[i].offset_bottom = 0
		buttons[i].offset_left = 0
		buttons[i].offset_right = 0
		buttons[i].offset_top = 0
		
		buttons[i].icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		buttons[i].vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		buttons[i].expand_icon = true


func _on_btn_buildings_pressed() -> void:
	skillTree.visible = false
	buildingTree.visible = true


func _on_btn_skill_pressed() -> void:
	skillTree.visible = true
	buildingTree.visible = false
