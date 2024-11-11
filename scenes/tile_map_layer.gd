@tool # crée catégore pour gérer génération map

extends TileMapLayer

@export var generateTerrain : bool
@export var clearTerrain : bool
var width := Global.width
var height := Global.height

# plus c'est bas plus y en a
@export var base_water_Threshold := -0.455 
@export var sand_Threshold := -0.470
@export var sand1_Threshold := -0.485
@export var base_grass_Threshold := -0.73
@export var mountain_Threshold := -1.0
@export var herb_Threshold := 0.0


var source_id_general_tileset := 0
var source_id_fournitures_tileset := 1
var base_grass_atlas = [Vector2i(5,1),Vector2i(5,0),Vector2i(6,1),Vector2i(6,0)]
var base_water_atlas = Vector2i(5,6)
var sand_atlas = Vector2i(5,3)
var sand1_atlas = Vector2i(5,4)
var herb_atlas = Vector2i(4,1)
var mountain_atlas = Vector2i(18,4)
var mountain_up = Vector2i(13,14)
var mountain_down = Vector2i(18,5)
var mountain_right = Vector2i(14,14)
var mountain_left = Vector2i(15,14)


var _rng = RandomNumberGenerator.new()
@export var TerrainSeed := 0

var RANGE = 200
var tree_gen = true

func _ready():
	pass
	
func _process(_delta: float) -> void:
	if generateTerrain:
		generateTerrain = false
		generate_world_and_water()
	if clearTerrain:
		clearTerrain = false
		clear()
	


func generate_world_and_water():
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	
	if TerrainSeed == 0:
		noise.seed = _rng.randi()
	else:
		noise.seed = TerrainSeed
	
	for _i in range(-width, width):
		for _j in range(-height, height):
			var pos = Vector2(_i, _j)
			var noise_value = noise.get_noise_2d(_i, _j)

			if noise_value > base_water_Threshold:
				set_cell(pos, source_id_general_tileset, base_water_atlas)
			elif noise_value >= sand_Threshold:
				set_cell(pos, source_id_general_tileset, sand_atlas)
			elif noise_value >= sand1_Threshold:
				set_cell(pos, source_id_general_tileset, sand1_atlas)
			elif noise_value >= base_grass_Threshold:
				if _rng.randi_range(0,12) < 10:
					set_cell(pos, source_id_general_tileset, base_grass_atlas[0])
				else:
					set_cell(pos, source_id_general_tileset, base_grass_atlas[_rng.randi_range(1,3)])
				if noise.get_noise_2d(_i, _j + 1) <= base_grass_Threshold:
					set_cell(pos, source_id_general_tileset, mountain_up)
				if noise.get_noise_2d(_i, _j - 1) <= base_grass_Threshold:
					set_cell(pos, source_id_general_tileset, mountain_down)
			elif noise_value >= mountain_Threshold:
				set_cell(pos, source_id_general_tileset, mountain_atlas)
			
			
