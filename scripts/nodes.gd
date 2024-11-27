extends Panel

var scriptnode = load("res://scripts/graph_node.gd")

var hasStartNode = {}
var hasEndNode = {}

func _on_node_click(node: Variant) -> void:
	if Global.presetSelected != null:
		if node.name == "Start" and hasStartNode[Global.presetSelected.name]:
			return
		if node.name == "End" and hasEndNode[Global.presetSelected.name]:
			return
		if node.name == "Start":
			hasStartNode[Global.presetSelected.name] = true
		if node.name == "End":
			hasEndNode[Global.presetSelected.name] = true
		var graph = get_node("../../Graphs/graph_" + Global.presetSelected.text)
		var duplicated_node = node.duplicate()
		duplicated_node.position_offset = Vector2(-300,50)
		duplicated_node.script = scriptnode
		graph.add_child(duplicated_node)
