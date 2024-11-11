extends TileMapLayer

var source_id_general_tileset := 0
var source_id_fournitures_tileset := 1
var base_grass_atlas = [Vector2i(5,0),Vector2i(6,1),Vector2i(6,0),Vector2i(5,1),Vector2i(5,1),Vector2i(5,1),Vector2i(5,1)]
var base_water_atlas = Vector2i(5,6)
var sand_atlas = Vector2i(5,3)
var sand1_atlas = Vector2i(5,4)
var herb_atlas = Vector2i(4,1)
var mountain_atlas = Vector2i(18,4)

var _rng = RandomNumberGenerator.new()
var width := Global.width
var height := Global.height


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generation_top_layer(tilemap):
	for _i in range(-width, width):
		for _j in range(-height, height):
			var pos = Vector2(_i, _j)
			var tile_coords = tilemap.get_cell_atlas_coords(pos)
			if tile_coords == Vector2i(5,1) or tile_coords == Vector2i(5,0):
				$".".set_cell(pos, source_id_general_tileset, Vector2i(8,4))
				
