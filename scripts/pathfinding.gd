@tool
extends Node2D

@onready var terrain = $"../TileMapLayer"

var astar_grid = AStarGrid2D.new()

@export var start : Vector2i
@export var end : Vector2i
@export var calculate : bool

var path = []

func _ready() -> void:
	initPathFinding()
	
func _process(_delta: float) -> void:
	if calculate:
		calculate = false
		initPathFinding()
		requestPath(start, end)
		
func requestPath(start: Vector2i, end: Vector2i):
	if -Global.width < start.x and start.x < Global.width and -Global.height < start.y and start.y < Global.height and -Global.width < end.x and end.x < Global.width and -Global.height < end.y and end.y < Global.height:
	
		path = astar_grid.get_point_path(start, end)
		
		for i in range(len(path)):
			path[i] += Vector2(terrain.rendering_quadrant_size / 2, terrain.rendering_quadrant_size / 2)
		
		queue_redraw()
		return path
	else:
		return []

	
func initPathFinding():
	# Ajuster la région pour couvrir toute la map centrée en (0,0)
	astar_grid.region = Rect2i(-terrain.width, -terrain.height, terrain.width*2, terrain.height*2)
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.update()

	
	for x in range(-terrain.width, terrain.width):
		for y in range(-terrain.height, terrain.height):
			var pos = Vector2i(x, y)
			if getTerrainDifficulty(pos) == -1:
				astar_grid.set_point_solid(pos)
			else:
				astar_grid.set_point_weight_scale(pos, getTerrainDifficulty(pos))
			
			
func _draw():
	if len(path) > 0:
		for i in range(len(path)-1):
			draw_line(path[i], path[i+1], Color.PURPLE)
			
func getTerrainDifficulty(coords : Vector2i):
	var source_id = terrain.get_cell_source_id(coords)
	var source: TileSetAtlasSource = terrain.tile_set.get_source(source_id)
	var atlas_coords = terrain.get_cell_atlas_coords(coords)
	var tile_data = source.get_tile_data(atlas_coords, 0)
	return tile_data.get_custom_data("walk_difficulty")
