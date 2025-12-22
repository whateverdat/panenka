class_name Keeper

extends Node2D

@export var Sprite : AnimatedSprite2D
@export var Collider : Area2D

const START_POSITION : Vector2 = Vector2(160, 33)
const VELOCITY_DECAY : float = 2.5
const DECAY_SIDE_MULTIPLIER : float = 5
const ROTATION_HEIGHT_DIFFERENCE : int = 16

var random_direction : int = 0
var random_dive_speed : int = 0
var velocity : Vector2 = Vector2.ZERO
var collider_size : int = 0

func _ready() -> void:
	get_ready()
	
func _process(delta: float) -> void:
	collider_size = Collider.get_overlapping_areas().size()
	if (collider_size > 1):
		velocity = Vector2.ZERO
	if (velocity.y > 0):
		position.y += velocity.y * delta
		velocity.y -= VELOCITY_DECAY * delta
		
	if (velocity.x > 0):
		position.x += velocity.x * random_dive_speed * delta
		velocity.x -= VELOCITY_DECAY * DECAY_SIDE_MULTIPLIER * random_dive_speed * delta
	
	if (velocity.x < 0):
		position.x += velocity.x * random_dive_speed * delta
		velocity.x += VELOCITY_DECAY * DECAY_SIDE_MULTIPLIER * random_dive_speed * delta
	
func get_ready() -> void:
	position = START_POSITION
	Sprite.set_frame_and_progress(0, 0)
	rotation = 0
	random_direction = 0
	velocity = Vector2.ZERO
	rotate(0)
	
func saved() -> void:
	Sprite.set_frame_and_progress(1, 0)
	
func dive() -> void:
	random_direction = randi_range(-2, 2)
	random_dive_speed = randi_range(1, 3)
	if (random_direction < 0):
		velocity.x = -35
		
	elif (random_direction > 0):
		velocity.x = 35
		
	else:
		velocity.y = 10
		pass
	
