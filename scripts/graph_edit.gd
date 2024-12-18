extends GraphEdit


#@onready var validRect = $UI/Work/ImgValid/ValidRect
#@onready var validLabel = $UI/Work/LabelValid/ValidLabel
# Dictionnaire pour stocker les connexions
var connections = {}

@onready var Nodes = $"../../NodesPages/NodesP1"
@onready var validRect = $"../../ImgValid/ValidRect"
@onready var validLabel = $"../../LabelValid/ValidLabel"

var start_node = null
var end_node = null

var pathIsValid = false

var pickableItems = ["SmTree", "Rock"]
var harvestableItems = ["Log"]


func _ready():
	# Connecter le signal de connexion
	connect("connection_request", _on_connection_request)
	connect("disconnection_request", _on_disconnection_request)
	connect("delete_nodes_request", _on_Graph_delete_nodes_request)

func _on_connection_request(from_node, from_port, to_node, to_port):
	# Récupère les titres directement depuis les GraphNodes
	if from_node == "Start":
		start_node = from_node
	if to_node == "End":
		end_node = to_node
	var from_title = ""
	var to_title = ""
	for child in get_children():
		if child.name == from_node:
			from_title = child.title
		if child.name == to_node:
			to_title = child.title

	# Vérifie si la connexion existe déjà
	for con in get_connection_list():
		if con.to_node == to_node and con.to_port == to_port:
			return

	# Ajoute la connexion dans un dictionnaire
	if !connections.has(from_title):
		connections[from_title] = []
	connections[from_title] = {"to_node": to_title}
	
	# Crée la connexion visuelle dans le GraphEdit
	connect_node(from_node, from_port, to_node, to_port)
	var path = IsValidPath()
	if pathIsValid:
		if !Global.presetsWork.has(Global.presetSelected.text):
			Global.presetsWork[Global.presetSelected.text] = []
		Global.presetsWork[Global.presetSelected.text] = path

	
func _on_disconnection_request(from_node, from_port, to_node, to_port):
	# Récupère les titres directement depuis les GraphNodes
	var from_title = ""
	for child in get_children():
		if child.name == from_node:
			from_title = child.title
	
	connections.erase(from_title)
	# Supprime la connexion visuelle dans le GraphEdit
	disconnect_node(from_node, from_port, to_node, to_port)
	# Met à jour Global.presetsWork
	var path = IsValidPath()
	if pathIsValid:
		if Global.presetsWork.has(Global.presetSelected.text):
			Global.presetsWork[Global.presetSelected.text] = path

	


func IsValidPath() -> Array:
	var path = []
	var visited = []  # Garde une trace des nœuds visités
	var current_node = "Start"

	# On commence par vérifier si "Start" existe
	if !connections.has(current_node):
		PathIsValid(false)
		return []

	# Parcours du chemin à partir de "Start"
	while current_node != "End":
		# Vérifie si le nœud courant est connecté à d'autres nœuds
		if connections.has(current_node) and connections[current_node].size() > 0:
			# Si plusieurs connexions, choisissez-en une (par exemple, la première)
			var next_node = connections[current_node]["to_node"]

			# Empêche les boucles infinies
			if next_node in visited:
				PathIsValid(false)
				return []

			# Ajoute au chemin et passe au nœud suivant
			visited.append(current_node)
			path.append(current_node)
			current_node = next_node
		else:
			# Si aucun chemin valide n'est trouvé
			PathIsValid(false)
			return []

	# Ajoute "End" au chemin une fois terminé
	path.append("End")
	
	#Vérification des bonnes relations (ex : PickUp -> Log != Tree)
	for node in len(path):
		if path[node] == "Find" and !harvestableItems.has(path[node+1]) and !pickableItems.has(path[node+1]):
			PathIsValid(false)
			return []
		if path[node] == "Harvest" and !harvestableItems.has(path[node-1]):
			PathIsValid(false)
			return []
		if path[node] == "PickUp" and !pickableItems.has(path[node+1]):
			PathIsValid(false)
			return []
			
	print(path)
	if len(path) > 2:
		PathIsValid(true)
	else:
		PathIsValid(false)
	return path
	
func PathIsValid(validity) -> void:
	pathIsValid = validity
	if validity:
		validLabel.text = "Valid"
		validRect.color = Color.GREEN
	else:
		validLabel.text = "Not valid"
		validRect.color = Color.RED


func _on_Graph_delete_nodes_request(nodes):
	if nodes.has("Start"):
		Nodes.hasStartNode[Global.presetSelected.name] = false
	if nodes.has("End"):
		Nodes.hasEndNode[Global.presetSelected.name] = false
	for child in get_children():
		if child.name in nodes:
			child.queue_free()
