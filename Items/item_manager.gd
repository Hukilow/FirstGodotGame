extends Node

enum ItemCategory {ITEM = 0, WOOD = 1, FOOD = 2}
var itemCategories = ["Item","Trees","Food"]

var itemPrototypes = []
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
	LoadItem("res://Items/TreeAndBushs/")
	LoadItem("res://Items/RockAndCobble/")
	#SpawnForest(50)
	SpawnItemWorld(itemPrototypes[4],0.1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

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
	itemsInWorld.append(newItem)
	newItem.position = MapToWorldPosition(mapPosition.x, mapPosition.y)


func SpawnItemWorld(item, odd):
	for i in range(-width+5, width-5):
		for j in range(-height+5, height-5):
			var pos = Vector2(i, j)
			var tile_coords = tilemap.get_cell_atlas_coords(pos)
			if tile_coords in base_grass_atlas and rng.randf_range(0,100) <= odd:
				SpawnItem(item, Vector2(pos))
				
func SpawnForest(odd):
	for i in range(-width, width-20):
		for j in range(-height, height-20):
			if CheckMap(i, j, 20, base_grass_atlas) and rng.randf_range(0,100) <= odd:
				var pos = Vector2(i, j)
				for y in range(7):
					while pos.x < i+20:
						pos.x += rng.randi_range(3,5)
						pos.y = j + (y * 3) + rng.randi_range(0,3)
						SpawnItem(itemPrototypes[rng.randi_range(0,3)], Vector2(pos))
				

func CheckMap(i, j, decalage, atlas):
	for k in range (i,i+decalage):
		for l in range(j,j+decalage):
			var pos = Vector2(k, l)
			var tile_coords = tilemap.get_cell_atlas_coords(pos)
			if tile_coords not in atlas:
				return false
	return true

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


func LoadItem(way):
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
			itemPrototypes.append(load(path + "/" + file_name))
		
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
