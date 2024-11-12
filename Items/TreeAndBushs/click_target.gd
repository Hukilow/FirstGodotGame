extends Area2D

func _input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("click"):
		get_parent().OnClick()
