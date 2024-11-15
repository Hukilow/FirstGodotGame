extends GraphNode

func _on_connection_request(from_node, from_port, to_node, to_port):
	print('dino')
	get_node("Graph").connect_node(from_node, from_port, to_node, to_port)
