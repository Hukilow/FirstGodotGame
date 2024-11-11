extends Node

enum ItemCategory {ITEM = 0, WOOD = 1, FOOD = 2}
var itemCategories = ["Item","Trees","Food"]

var treesPrototypes = []

var itemsInWorld = []

var width := Global.width
var height := Global.height
@onready var tilemap = $"../TileMapLayer1"
var rng = RandomNumberGenerator.new()
var base_grass_atlas = [Vector2i(5,0),Vector2i(6,1),Vector2i(6,0),Vector2i(5,1),Vector2i(5,1),Vector2i(5,1),Vector2i(5,1)]
var base_water_atlas = Vector2i(5,6)
var sand_atlas = Vector2i(5,3)
var sand1_atlas = Vector2i(5,4)
var herb_atlas = Vector2i(4,1)
var mountain_atlas = Vector2i(18,4)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LoadTrees()
	SpawnItemWorld(treesPrototypes[3],0.1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func WorldtoMapPosition(posx:int,posy:int)->Vector2:
	return Vector2(posx * 16 + 8, posy * 16 + 8)
	

func SpawnItem(item, mapPosition):
	var newItem = item.instantiate()
	add_child(newItem)
	itemsInWorld.append(newItem)
	newItem.position = WorldtoMapPosition(mapPosition.x,mapPosition.y)

func SpawnItemWorld(item, odd):
	for _i in range(-width+5, width-5):
		for _j in range(-height+5, height-5):
			var pos = Vector2(_i, _j)
			var tile_coords = tilemap.get_cell_atlas_coords(pos)
			if tile_coords in base_grass_atlas and rng.randf_range(0,100) <= odd:
				SpawnItem(item, Vector2(pos))

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

func LoadTrees():
	var path = "res://Items/TreeAndBushs"
	var dir = DirAccess.open(path)
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif file_name.ends_with(".tscn"):
			treesPrototypes.append(load(path + "/" + file_name))
	dir.list_dir_end()
