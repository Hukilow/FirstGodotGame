extends Panel

@onready var presets = $"../Presets"
var scriptnode = load("res://scripts/graph_node.gd")

func _on_node_click(node: Variant) -> void:
	if Global.presetSelected != null:
		var graph = get_node("../Graphs/graph_" + Global.presetSelected.text)
		var duplicated_node = node.duplicate()
		duplicated_node.position_offset = Vector2(-300,50)
		duplicated_node.script = scriptnode
		graph.add_child(duplicated_node)
