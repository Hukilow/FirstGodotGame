extends CharacterBody2D

@onready var terrain := $"../TileMapLayer1"
@onready var pathfinding := $"../Pathfinding"
@onready var animation = $AnimatedSprite2D
@onready var itemManager = $"../ItemManager"
const SPEED = 300.0
var path = []

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		var pos = position / terrain.rendering_quadrant_size
		var target_pos = get_global_mouse_position() / terrain.rendering_quadrant_size
		path = pathfinding.requestPath(pos, target_pos)
	
	if Input.is_action_just_pressed("ui_accept"):
		var pos = position / terrain.rendering_quadrant_size
		var target_pos = itemManager.FindNearestItem(itemManager.ItemCategory.WOOD, position).position / terrain.rendering_quadrant_size
		path = pathfinding.requestPath(pos, target_pos)
		
	if len(path) > 0:
		var direction = global_position.direction_to(path[0])
		
		update_animation(direction)
		
		var terrainDiddiculty = pathfinding.getTerrainDifficulty(position / terrain.rendering_quadrant_size)
		velocity = direction * SPEED * (1/ terrainDiddiculty)
		
		if position.distance_to(path[0]) < SPEED * delta:
			path.remove_at(0)
			
	else:
		velocity = Vector2.ZERO
		animation.play("idle_front")
		
	move_and_slide()
	
func update_animation(direction: Vector2) -> void:
	var angle = direction.angle()

	# Définir les plages d'angle pour chaque direction
	if angle > -PI/8 and angle <= PI/8:
		animation.play("walk_right")
	elif angle > PI/8 and angle <= 3*PI/8:
		animation.play("walk_front")
	elif angle > 3*PI/8 and angle <= 5*PI/8:
		animation.play("walk_front")
	elif angle > 5*PI/8 and angle <= 7*PI/8:
		animation.play("walk_front")
	elif angle > 7*PI/8 or angle <= -7*PI/8:
		animation.play("walk_left")
	elif angle > -7*PI/8 and angle <= -5*PI/8:
		animation.play("walk_back")
	elif angle > -5*PI/8 and angle <= -3*PI/8:
		animation.play("walk_back")
	elif angle > -3*PI/8 and angle <= -PI/8:
		animation.play("walk_back")
