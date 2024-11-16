extends GraphNode

signal click(node)

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		click.emit(self)
