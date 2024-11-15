extends GraphEdit

# Dictionnaire pour stocker les connexions
var connections = {}

# Exemple d'instructions associées aux nœuds
var instructions = {
	"aller_a": "Déplacement vers une position",
	"arbre": "Cible: Arbre",
}

func _ready():
	# Connecter le signal de connexion
	connect("connection_request", _on_connection_request)
	connect("disconnection_request", _on_disconnection_request)

func _on_connection_request(from_node, from_port, to_node, to_port):
	# Don't connect to input that is already connected
	for con in get_connection_list():
		if con.to_node == to_node and con.to_port == to_port:
			return
	if !connections.has(from_node):
		connections[from_node] = []
	connections[from_node].append({"to_node": to_node, "from_port": from_port, "to_port": to_port})
	connect_node(from_node, from_port, to_node, to_port)
	print(connections)
	
func _on_disconnection_request(from_node, from_port, to_node, to_port):
	# Retirer une connexion du dictionnaire
	disconnect_node(from_node, from_port, to_node, to_port)
	if connections.has(from_node):
		connections[from_node] = connections[from_node].filter(
			func(c): return c["to_node"] != to_node or c["from_port"] != from_port or c["to_port"] != to_port
		)
	
