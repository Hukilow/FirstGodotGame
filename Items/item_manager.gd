extends Node

enum ItemCategory {ITEM = 0, WOOD = 1, FOOD = 2, ROCK = 3}
var itemCategories = ["Item","Trees","Food", "Rocks"]

var itemPrototypes = {}
var itemPickable = []

var itemsInWorld = []

var width := Global.width
var height := Global.height
@onready var tilemap = $"../TileMapLayer"
var rng = RandomNumberGenerator.new()
var base_grass_atlas = [Vector2i(5,0),Vector2i(6,1),Vector2i(6,0),Vector2i(5,1),Vector2i(5,1),Vector2i(5,1),Vector2i(5,1)]
var base_water_atlas = Vector2i(5,6)
var sand_atlas = Vector2i(5,3)
var sand1_atlas = Vector2i(5,4)
var herb_atlas = Vector2i(4,1)
var mountain_atlas = Vector2i(18,4)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	SpawnItemWorld(itemPrototypes["Rocks"][1],0.1)
	SpawnForest(0.05)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setup():
	LoadItem("res://Items/TreeAndBushs/", "Trees")
	LoadItem("res://Items/RockAndCobble/", "Rocks")
	for i in range(-width, width):
		var ligne = []
		for j in range(-height, height):
			ligne.append(0)
		itemsInWorld.append(ligne)
	
	
func MapToWorldPosition(mapPosX : int, mapPosY : int) -> Vector2:
	return Vector2(mapPosX * 16 + 8, mapPosY * 16 + 8)
	
static func WorldToMapPosition(worldPos : Vector2) -> Vector2i:
	return Vector2i(worldPos.x / 16, worldPos.y / 16)
	
func RemoveItemFromWorld(item):
	remove_child(item)
	itemsInWorld.erase(item)

	
func SpawnItemByName(itemName : String, amount: int, mapPosition : Vector2i):
	var newItem
	
	for item in itemPickable:
		if item.get_path() == itemName:
			newItem = item.instantiate()
			newItem.count = amount
			
	if newItem != null:
		add_child(newItem)
		itemsInWorld.append(newItem)
		newItem.position = MapToWorldPosition(mapPosition.x, mapPosition.y)


func SpawnItem(item, mapPosition):
	var newItem = item.instantiate()
	add_child(newItem)
	itemsInWorld[mapPosition.x][mapPosition.y] = newItem
	newItem.position = MapToWorldPosition(mapPosition.x, mapPosition.y)


func SpawnItemWorld(item, odd):
	for i in range(-width+5, width-5):
		for j in range(-height+5, height-5):
			var pos = Vector2(i, j)
			var tile_coords = tilemap.get_cell_atlas_coords(pos)
			if tile_coords in base_grass_atlas and rng.randf_range(0,100) <= odd and typeof(itemsInWorld[i][j]) == TYPE_INT:
				SpawnItem(item, Vector2(pos))
				
func SpawnForest(odd):
	# Taille des zones denses et clairsemées
	var cluster_size = rng.randi_range(5, 10)  # Taille des clusters denses (en tuiles)
	var sparse_size = rng.randi_range(10, 20)  # Taille des zones sans arbres (en tuiles)
	# Itération sur la carte
	for i in range(-width + 5, width - 5, sparse_size):
		for j in range(-height + 5, height - 5, sparse_size):
			# Décider aléatoirement si cette zone sera dense ou claire
			if rng.randf() < 0.2:  # 20% de chances d'avoir une zone dense
				SpawnTreeCluster(Vector2i(i, j), cluster_size, odd * 2)  # Densité augmentée
			else:
				SpawnTreeCluster(Vector2i(i, j), cluster_size, odd * 0.1)  # Densité réduite


func SpawnTreeCluster(center: Vector2i, size: int, odd: float):
	# Crée un cluster d'arbres autour d'un point central
	for i in range(center.x - size, center.x + size):
		for j in range(center.y - size, center.y + size):
			# Vérifie si la position est valide
			if -width + 5 <= i and i < width - 5 and -height + 5 <= j and j < height - 5:
				var pos = Vector2(i, j)
				var tile_coords = tilemap.get_cell_atlas_coords(pos)
				# Place un arbre avec une probabilité donnée
				if tile_coords in base_grass_atlas and rng.randf() < odd and typeof(itemsInWorld[i][j]) == TYPE_INT:
					var tree_prototype = null
					if itemPrototypes.has("Trees") and itemPrototypes["Trees"].size() > 0:
						tree_prototype = itemPrototypes["Trees"][rng.randi_range(0,3)]
					if tree_prototype:
						SpawnItem(tree_prototype, Vector2i(i, j))

	

func FindNearestItem(itemCategory: ItemCategory, worldPos: Vector2):
	if len(itemsInWorld) == 0:
		return false
	
	var NearestItem = null
	var NearestDistance = 999999999999999
	for item in itemsInWorld:
		if IsItemInCategory(item, itemCategory):
			var distance = worldPos.distance_to(item.position)
			if NearestItem == null:
				NearestItem = item
				NearestDistance = distance
				continue
			if distance < NearestDistance:
				NearestItem = item
				NearestDistance = distance
	return NearestItem
				
			
func IsItemInCategory(item, itemCategory):
	return item.is_in_group(itemCategories[itemCategory])
	
func LoadItemPrototypes():
	var allFileNames = _dir_contents("res://Item/", ".tscn")
	for fileName in allFileNames:
		itemPrototypes.append(load(fileName))
		print(fileName)


func LoadItem(way,type):
	itemPrototypes[type] = []
	var path = way
	var dir = DirAccess.open(path)
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif file_name.ends_with("pickable.tscn"):
			itemPickable.append(load(path + "/" + file_name))
		elif file_name.ends_with(".tscn"):
			itemPrototypes[type].append(load(path + "/" + file_name))
		
	dir.list_dir_end()
	
	
static func _dir_contents(path, suffix) -> Array[String]:
	var dir = DirAccess.open(path)
	if !dir:
		print("An error occurred when trying to access path: %s" % [path])
		return []

	var files: Array[String]
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		file_name = file_name.replace('.remap', '') 
		if dir.current_is_dir():
			files.append_array(_dir_contents("%s/%s" % [path, file_name], suffix))
		elif file_name.ends_with(suffix):
			files.append("%s/%s" % [path, file_name])
		file_name = dir.get_next()
		
	return files
