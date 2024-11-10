extends TileMapLayer

var width := 150
var height := 150

var source_id_general_tileset := 0
var source_id_fournitures_tileset := 1
var base_grass_atlas = Vector2i(5,1)
var base_water_atlas = Vector2i(5,6)
var sand_atlas = Vector2i(5,3)
var sand1_atlas = Vector2i(5,4)
var herb_atlas = Vector2i(4,1)

var _rng = RandomNumberGenerator.new()
var _noise = FastNoiseLite.new() 

var RANGE = 200
var tree_gen = true

func _ready():
	generate_world_and_water()
	
func generate_world_and_water():
	_noise.seed = randi() % 10
	_noise.fractal_octaves = 2
	_noise.fractal_lacunarity = 1.575
	_noise.frequency = 0.03
	_noise.noise_type = 3
	
	var center = Vector2(0, 0)  # Position centrale de l'île
	
	for _i in range(-width, width):
		for _j in range(-height, height):
			var pos = Vector2(_i, _j)
			var distance = pos.distance_to(center)
			
			# Utiliser une atténuation pour la distance au centre
			var distance_factor = clamp(1.0 - (distance / RANGE), 0.0, 1.0)
			var noise_value = _noise.get_noise_2d(_i, _j) * distance_factor
			
			if noise_value < -0.3:
				set_cell(pos, source_id_general_tileset, base_water_atlas)
			elif noise_value > -0.3 && noise_value <= -0.1:
				set_cell(pos, source_id_general_tileset, base_water_atlas)
			elif noise_value > -0.1 && noise_value <= 0:
				set_cell(pos, source_id_general_tileset, base_grass_atlas)
			elif noise_value > 0 && noise_value <= 0.1:
				set_cell(pos, source_id_general_tileset, base_grass_atlas)
			elif noise_value > 0.1 && noise_value <= 0.25:
				set_cell(pos, source_id_general_tileset, base_grass_atlas)
			elif noise_value > 0.25:
				set_cell(pos, source_id_general_tileset, base_grass_atlas)
				
				# Génération d'arbres
				if tree_gen and randi() % 3 == 1:
					set_cell(pos, source_id_general_tileset, base_grass_atlas)
