extends Camera2D

var zoom_target : Vector2
@export var zoom_speed := 4
@export var zoom_min := 0.1
@export var zoom_max := 5.0

var dragStartMousePos := Vector2.ZERO
var dragStartCameraPos := Vector2.ZERO
var isDragging := false

func _ready() -> void:
	zoom_target = zoom

func _process(delta: float) -> void:
	if !Global.inMenu:
		Zoom(delta)
		SimplePan(delta)
		ClickAndDrag()
		
		
func Zoom(delta):
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoom_target *= 1.1
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoom_target *= 0.9
		
	#Smooth
	zoom_target = clamp(zoom_target, Vector2(zoom_min, zoom_min), Vector2(zoom_max,zoom_max))
	zoom = zoom.slerp(zoom_target, zoom_speed * delta)
	
func SimplePan(delta):
	var move_amount = Vector2.ZERO
	var direction = Input.get_vector("camera_move_left","camera_move_right","camera_move_up","camera_move_down")
	move_amount += direction
	position += move_amount.normalized() * delta * 750 * (1/zoom.x)
	
func ClickAndDrag():
	if !isDragging and Input.is_action_just_pressed("camera_pan"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
		
	if isDragging and Input.is_action_just_released("camera_pan"):
		isDragging = false

	if isDragging:
		var move_vector = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - move_vector * (1/zoom.x)
