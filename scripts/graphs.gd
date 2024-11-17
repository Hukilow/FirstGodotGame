extends Panel


func _ready() -> void:
	connect("validGraph", on_validGraph)

func on_validGraph(boolean : bool):
	prin
