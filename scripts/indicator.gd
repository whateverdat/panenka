class_name Indicator

extends Node2D

@export var Arrow : Sprite2D
@export var Name : String
@export var NameLabel : Label

const BOUNDARY : int = 68
const speed : float = 250

var is_active : bool = true
var arrow_direction : bool = true

func _ready() -> void:
	NameLabel.text = Name.to_upper()

func _process(delta: float) -> void:
	if (not is_active): return
	
	if (arrow_direction):
		Arrow.position.x += speed * delta
		if (Arrow.position.x >= BOUNDARY):
			arrow_direction = not arrow_direction
			Arrow.position.x = BOUNDARY
	else:
		Arrow.position.x -= speed * delta
		if (Arrow.position.x <= -BOUNDARY):
			arrow_direction = not arrow_direction
			Arrow.position.x = -BOUNDARY
			
func set_state(state : bool) -> void:
	is_active = state
	
func reset_arrow() -> void:
	Arrow.position.x = randf_range(-36, 36)
	set_state(false)
	
func get_bar_position() -> float:
	return Arrow.position.x
