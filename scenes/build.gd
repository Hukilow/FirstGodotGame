@tool
extends Panel

@export var reset: bool = false
@onready var UI = $".."


var buttons = []
var columns := 5

func _ready() -> void:
	loadButtons()
	arrangeSelf()
	arrangeButtons()

func _process(delta: float) -> void:
	if reset:
		reset = false
		loadButtons()
		arrangeSelf()
		arrangeButtons()

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
	
func arrangeButtons():
	var rows = ceil(len(buttons) / float(columns))
	for i in range(len(buttons)):
		var column = i%columns
		var row = i / columns
		buttons[i].anchor_top = row / float(rows)
		buttons[i].anchor_bottom = (row + 1) / float(rows)
		buttons[i].anchor_left = column / float(columns)
		buttons[i].anchor_right = (column + 1) / float(columns)
		buttons[i].offset_bottom = 0
		buttons[i].offset_left = 0
		buttons[i].offset_right = 0
		buttons[i].offset_top = 0
		
		buttons[i].icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		buttons[i].vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		buttons[i].expand_icon = true
