extends Control

var menuScene := load("res://scenes/menu.tscn")
var list = [DisplayServer.WINDOW_MODE_FULLSCREEN,DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,DisplayServer.WINDOW_MODE_WINDOWED]

func _ready() -> void:
	verifyMode()

func verifyMode() -> void:
	#Display the resolution menu if window mode in windowed
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN or DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN :
		$CenterContainer/VBoxContainer/Resolution.visible = false
	else:
		$CenterContainer/VBoxContainer/Resolution.visible = true
	#Disable the window mode in use
	for mode in list:
		if mode == DisplayServer.window_get_mode():
			$CenterContainer/VBoxContainer/ScreenMode/ScreenMode.set_item_disabled(list.find(mode),true)
		else:
			$CenterContainer/VBoxContainer/ScreenMode/ScreenMode.set_item_disabled(list.find(mode),false)
			
func _on_screen_mode_id_pressed(id: int) -> void:
	#Set the display mode and verify 
	DisplayServer.window_set_mode(list[id])
	verifyMode()


func _on_resolution_id_pressed(id: int) -> void:
	#Change the resolution
	var window_size = $CenterContainer/VBoxContainer/Resolution/Resolution.get_item_text(id).split('x')
	var width = int(window_size[0])
	var height = int(window_size[1])
	DisplayServer.window_set_size(Vector2(width, height))


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(menuScene)
