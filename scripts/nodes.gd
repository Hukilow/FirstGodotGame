extends Panel

var scriptnode = load("res://scripts/graph_node.gd")

var hasStartNode = false
var hasEndNode = false

func _on_node_click(node: Variant) -> void:
	if node.name == "Start" and hasStartNode:
		return
	if node.name == "End" and hasEndNode:
		return
	if node.name == "Start":
		hasStartNode = true
	if node.name == "End":
		hasEndNode = true
	if Global.presetSelected != null:
		var graph = get_node("../../Graphs/graph_" + Global.presetSelected.text)
		var duplicated_node = node.duplicate()
		duplicated_node.position_offset = Vector2(-300,50)
		duplicated_node.script = scriptnode
		graph.add_child(duplicated_node)
