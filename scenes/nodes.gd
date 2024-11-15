extends Panel

@onready var presets = $"../Presets"

func _on_node_click(node: Variant) -> void:
	if presets.presetSelected != null:
		var graph = get_node("../Graphs/graph_" + presets.presetSelected.text)
		var duplicated_node = node.duplicate()
		duplicated_node.position_offset = Vector2(-300,50)
		duplicated_node.script = null
		graph.add_child(duplicated_node)
