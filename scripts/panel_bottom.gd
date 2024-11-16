@tool
extends Panel

@export var reset : bool = false
@onready var UI = $".."

var buttons = []

func _ready() -> void:
	loadButtons()
	for button in buttons:
		button.connect("pressed", onButtonPressed.bind(button))

func _process(_delta: float) -> void:
	if reset:
		reset = false
		loadButtons()
		arrangeButtons()
		
func onButtonPressed(button: Button):
	openSubMenu(button.text)
	
#Permet d'ouvrir les menus grâce aux boutons du bas sans impacter les UI Level et Ressources
func openSubMenu(menu : String):
	for submenu in get_parent().get_children():
		if submenu != self and submenu.name != 'Level' and submenu.name != 'Ressources':
			if menu == submenu.name:
				if submenu.is_visible():
					submenu.set_visible(false)
				else:
					submenu.set_visible(true)
			else:
				submenu.set_visible(false)
	IsInMenu()
	
func IsInMenu():
	for submenu in get_parent().get_children():
		if submenu.is_visible() and submenu.name != 'Level' and submenu.name != 'Ressources' and submenu.name != "Panel_bottom":
			Global.inMenu= true
			return
	Global.inMenu = false
	

func arrangeButtons():
	var div := float(1) / len(buttons)
	
	for i in range(len(buttons)):
		buttons[i].anchor_left = div * i
		buttons[i].anchor_right = (div * i) + div
		buttons[i].anchor_top = 0
		buttons[i].anchor_bottom = 1
		buttons[i].offset_bottom = 0
		buttons[i].offset_top = 0
		buttons[i].offset_left = 0
		buttons[i].offset_right = 0
		
	
func loadButtons():
	buttons = []
	for child in get_children():
		if child is Button:
			buttons.append(child)
